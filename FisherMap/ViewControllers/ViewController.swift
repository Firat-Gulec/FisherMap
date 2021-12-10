//
//  ViewController.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 30.12.2020.
//

import SideMenu
import MapKit
import UIKit
import CoreLocation
import SwiftUI

class ViewController: UIViewController,  CLLocationManagerDelegate,  MenuControllerDelegate, MyProtocol {
    
    // MARK: - My protocols func here..
    func sendmapType(mapType: MKMapType) {
        mapView.mapType = mapType
        getAllAnnonations()
    }
    
    func sendData(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let pinAnnonation = AnnonationModel(title: title, subtitle: subtitle, coordinate: coordinate, info: "test", favorite: true, createDate: Date())
        mapView.addAnnotation(pinAnnonation)
        print(pinAnnonation.title ?? "Gelmedi")
        mapView.reloadInputViews()
       
    }
    
    
    // MARK: - CoreDATA fetch (get, create, update, delete)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cellitems = [Locationdata]()
    //Get
    func getAllAnnonations() {
        mapView.removeAnnotations(mapView.annotations)
        do {
        cellitems = try context.fetch(Locationdata.fetchRequest())
            DispatchQueue.main.async {
               //Get data..
                for cellitem in self.cellitems {
                    
                    let pinAnnonation = AnnonationModel(title: cellitem.locName ?? "error", subtitle: cellitem.locSub ?? "error", coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(cellitem.cLat), longitude: CLLocationDegrees(cellitem.cLon)), info: cellitem.locNote ?? " ", favorite: cellitem.favorite, createDate: Date())
                    self.mapView.addAnnotation(pinAnnonation)
                    print(pinAnnonation.title ?? "Gelmedi")
                    self.mapView.reloadInputViews()
                    
                }
    
            }
        }catch {
            //error
        }
    }
    
   
    // MARK: - MKMapView all controls code
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    //var annonation = MKPointAnnotation()
    //weatherForcast Location
    var weatherLocation = CLLocationCoordinate2D()
    var previousLocation: CLLocation?
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    
    
    //Create location Manager
    func setupLocationManager() {
        mapView.delegate = self
       // mapView.mapType = .satellite
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        startTackingUserLocation()
    }
    
    func getDirection() {
        guard let currentLocation = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
         
        let request = createDirectionsRequest(from: currentLocation)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            for route in response.routes{
                self.mapView.addOverlay(route.polyline)
                
               // self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
        }
        
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate   = getCenterLocation(for: mapView).coordinate
        let startingLocation        = MKPlacemark(coordinate: coordinate)
        let destination             = MKPlacemark(coordinate: destinationCoordinate)
        
       
        let request                 = MKDirections.Request()
        request.source          = MKMapItem(placemark: startingLocation)
        request.destination     = MKMapItem(placemark: destination)
        //request.transportType   = .transit
        //request.requestsAlternateRoutes = true
        return request
    }
    
    // Alınan Konuma gitme yakınlaştırma..
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        weatherLocation = location
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //Show pin location view action ...
    func pinLocation(pinlocation: CLLocationCoordinate2D, createDate: Date, imageName: String, locName: String, locNote: String, favorite: Bool, locSub: String) {
        plusButtonMenu(openPlusButton: true)
        let vc = LocPinView()
        vc.currentLocation = pinlocation
        vc.locName = locName
        vc.subName = locSub
        vc.locNote = locNote
        vc.favorite = favorite
        vc.createDate = createDate
        vc.locImage = imageName 
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.delegate = self
        self.present(vc, animated: true, completion: nil )
    }
    
    //Long press the screen
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            let location = CLLocationCoordinate2D(latitude: touchedCoordinates.latitude, longitude: touchedCoordinates.longitude)
            plusButtonMenu(openPlusButton: true)
            let vc = PinLocationView()
            let navigation = UINavigationController(rootViewController: vc)
            vc.delegate = self
            vc.currentLocation = location
            present(navigation, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        previousLocation = getCenterLocation(for: mapView)
    }
    
 
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AnnonationModel else { return nil }
        
        let identifier = "AnnotationModel"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "fishing.png")
            annotationView?.canShowCallout = true
            
            let btn1 = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn1
            
        }else {
            annotationView?.annotation = annotation
            annotationView?.image = UIImage(named: "fishing.png")
        }
        return annotationView
    }
    
    //Pin BTN action..
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annonationmodel = view.annotation as? AnnonationModel else { return }
        pinLocation(pinlocation: annonationmodel.coordinate, createDate: annonationmodel.createDate, imageName: "fishing.png", locName: annonationmodel.subtitle ?? "  ", locNote: annonationmodel.info, favorite: annonationmodel.favorite, locSub: annonationmodel.subtitle ?? "vsrv")
        
        /*
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)*/
    }
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuController(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        sideMenu?.navigationBar.barStyle = .black
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        //İlk Konum bilgisi alınıyor
        setupLocationManager()
        getAllAnnonations()
        //PlusButtons Create
        view.addSubview(floatingButton)
        view.addSubview(measureButton)
        view.addSubview(setancorButton)
        view.addSubview(savecatchButton)
        view.addSubview(savecurrentButton)
        view.addSubview(aimImage)
        view.addSubview(closeButton)
        view.addSubview(addButton)
        view.addSubview(backButton)
        view.addSubview(clearButton)
        view.addSubview(totalLabel)
        view.addSubview(pointcountLabel)
        plusButtonMenu(openPlusButton: true)
        aimImage.isHidden = true
        closeButton.isHidden = true
        addButton.isHidden = true
        backButton.isHidden = true
        clearButton.isHidden = true
        totalLabel.isHidden = true
        pointcountLabel.isHidden = true
        floatingButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        measureButton.addTarget(self, action: #selector(didTapmeasureButton), for: .touchUpInside)
        //setancorButton.addTarget(self, action: #selector(didTapsetancorButton), for: .touchUpInside)
        //savecatchButton.addTarget(self, action: #selector(didTapsavecatchButton), for: .touchUpInside)
        savecurrentButton.addTarget(self, action: #selector(didTapsavecurrentButton), for: .touchUpInside)
        savecatchButton.isHidden = true
        setancorButton.isHidden = true
        closeButton.addTarget(self, action: #selector(didTapcloseButton), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapaddButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapbackButton), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didTapclearButton), for: .touchUpInside)
       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //PlusButtons set layout
        floatingButton.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 70, width: 60, height: 60)
        savecurrentButton.frame = CGRect(x: view.frame.size.width - 50, y: view.frame.size.height - 120, width: 40, height: 40)
        //savecatchButton.frame = CGRect(x: view.frame.size.width - 50, y: view.frame.size.height - 170, width: 40, height: 40)
        //setancorButton.frame = CGRect(x: view.frame.size.width - 50, y: view.frame.size.height - 220, width: 40, height: 40)
        measureButton.frame = CGRect(x: view.frame.size.width - 50, y: view.frame.size.height - 170, width: 40, height: 40)
        aimImage.frame = CGRect(x: (view.frame.size.width / 2) - 20, y: (view.frame.size.height / 2) + 20, width: 40, height: 40)
        closeButton.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 70, width: 60, height: 60)
        addButton.frame = CGRect(x: view.frame.size.width - 120, y: view.frame.size.height - 55, width: 40, height: 40)
        backButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - 105, width: 40, height: 40)
        clearButton.frame = CGRect(x: view.frame.size.width - 50, y: view.frame.size.height - 120, width: 40, height: 40)
        totalLabel.frame = CGRect(x: 68, y: view.frame.size.height - 80, width: 200, height: 60)
        pointcountLabel.frame = CGRect(x: 70, y: view.frame.size.height - 63, width: 200, height: 60)
        
    }
    
    //Reload mapview data..
    override func viewWillAppear(_ animated: Bool) {
        mapView.reloadInputViews()
        getAllAnnonations()
    }

    //View controller değişken atama
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weather" {
            let destinationVC = segue.destination as! weatherVC
            destinationVC.currentLocation = weatherLocation
        }
        if segue.identifier == "locations" {
            let destinationVC = segue.destination as! locationsVC
            destinationVC.currentLocation = weatherLocation
        }
        if segue.identifier == "solunar" {
            let destinationVC = segue.destination as! solunarVC
            destinationVC.currentLocation = weatherLocation
        }
        if segue.identifier == "fishing" {
            let destinationVC = segue.destination as! fishingVC
            destinationVC.currentLocation = weatherLocation
        }
       
    }
    
    // MARK: - Button controls
    
    //Map Button click
    @IBAction func mapButton(_ sender: Any) {
        let slideVC = MapTypeView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.delegate = self
        self.present(slideVC, animated: true, completion: nil )
    }
    
    @IBAction func golocationButton(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //plusButtonMenu working scene ..
    var image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
    var tik = Bool(false)
    
    func plusButtonMenu(openPlusButton: Bool) {
        if openPlusButton == false {
            image = UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
            floatingButton.setImage(image, for: .normal)
            tik = true
            //Control Buttons are open..
            measureButton.isHidden = false
            //setancorButton.isHidden = false
            //savecatchButton.isHidden = false
            savecurrentButton.isHidden = false
        } else {
            image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
            floatingButton.setImage(image, for: .normal)
            tik = false
            //Control Buttons are close..
            measureButton.isHidden = true
            //setancorButton.isHidden = true
            //savecatchButton.isHidden = true
            savecurrentButton.isHidden = true
        }
    }
    
    //PlusMenu Action func..
    @objc private func didTapPlusButton() {
        if tik == false {
           plusButtonMenu(openPlusButton: false)
        } else {
            plusButtonMenu(openPlusButton: true)
        }
    }
    
    @objc private func didTapmeasureButton() {
        plusButtonMenu(openPlusButton: true)
        aimImage.isHidden = false
        closeButton.isHidden = false
        floatingButton.isHidden = true
        addButton.isHidden = false
        backButton.isHidden = false
        clearButton.isHidden = false
        totalLabel.isHidden = false
        totalLabel.text = "Total length: "
        pointcountLabel.isHidden = false
        pointcountLabel.text = "Points count: 1"
        locationManager.stopUpdatingLocation()
        
    }
    
    @objc private func didTapsetancorButton() {
        plusButtonMenu(openPlusButton: true)
        closeButton.isHidden = false
        floatingButton.isHidden = true
    }
    

    
    @objc private func didTapsavecatchButton() {
        plusButtonMenu(openPlusButton: true)
        let vc = PinLocationView()
        let navigation = UINavigationController(rootViewController: vc)
        vc.currentLocation = weatherLocation
        vc.delegate = self
        present(navigation, animated: true)
        
        
    }
    
    
    @objc private func didTapsavecurrentButton() {
        plusButtonMenu(openPlusButton: true)
        let vc = PinLocationView()
        let navigation = UINavigationController(rootViewController: vc)
        vc.currentLocation = weatherLocation
        vc.delegate = self
        present(navigation, animated: true)
    }
    
    @objc private func didTapcloseButton() {
       // if aimImage.isHidden == false {
            floatingButton.isHidden = false
            closeButton.isHidden = true
            aimImage.isHidden = true
            addButton.isHidden = true
            backButton.isHidden = true
            clearButton.isHidden = true
            totalLabel.isHidden = true
            pointcountLabel.isHidden = true
            mapView.removeOverlays(mapView.overlays)
            locationManager.startUpdatingLocation()
        //Measurement clears
        mapView.removeOverlays(mapView.overlays)
        totalLabel.text = "Total length: "
        addInt = 0
        secondLoc.removeAll()
        firstLoc.removeAll()
        distanceArray.removeAll()
        desCoordinate.removeAll()
        polyLine.removeAll()       // }
    }

    //Measurement Controls
    
    var addInt: Int = 0
    var secondLoc = [CLLocation]()
    var firstLoc = [CLLocation]()
    var distanceArray = [CLLocationDistance]()
    var desCoordinate = [CLLocationCoordinate2D]()
    var polyLine = [MKPolyline]()
    var distance = String()
    
    
    @objc private func didTapaddButton() {
        //getDirection()
        if addInt == 0 {
        mapView.removeOverlays(mapView.overlays)
            desCoordinate.append(getCenterLocation(for: mapView).coordinate)
            firstLoc.append(CLLocation(latitude:weatherLocation.latitude, longitude:weatherLocation.longitude))
            secondLoc.append(CLLocation(latitude: desCoordinate[addInt].latitude, longitude: desCoordinate[addInt].longitude))
            distanceArray.append(firstLoc[addInt].distance(from: secondLoc[addInt]) / 1000)
            var coordinates = [weatherLocation, desCoordinate[addInt]]
            // Add polyline arrays.
            polyLine.append(MKPolyline(coordinates: &coordinates, count: coordinates.count))
            mapView.addOverlay(polyLine[addInt])
            firstLoc.append(CLLocation(latitude: desCoordinate[addInt].latitude, longitude: desCoordinate[addInt].longitude))
        
            let  totalDistance = firstLoc.dropFirst().reduce((firstLoc.first!, 0.0)) {  ($1 , $0.1 + $0.0.distance(from: $1)) }.1
            if (Locale.current.usesMetricSystem == false) {
                distance = "mi"
                totalLabel.text = "Total length: \(String(format:"%.01f", totalDistance / 1609.344)) \(distance)"
            }else {
               distance = "km"
                totalLabel.text = "Total length: \(String(format:"%.02f", totalDistance / 1000)) \(distance)"
            }
        addInt = +1
            //Add Points
        }else if addInt > 0 {
            desCoordinate.append(getCenterLocation(for: mapView).coordinate)
            secondLoc.append(CLLocation(latitude: desCoordinate[addInt].latitude, longitude: desCoordinate[addInt].longitude))
            distanceArray.append(firstLoc[addInt].distance(from: secondLoc[addInt]) / 1000)
            var coordinates = [firstLoc[addInt].coordinate, desCoordinate[addInt]]
            // Add polyline arrays.
            polyLine.append(MKPolyline(coordinates: &coordinates, count: coordinates.count))
            mapView.addOverlay(polyLine[addInt])
            firstLoc.append(CLLocation(latitude: desCoordinate[addInt].latitude, longitude: desCoordinate[addInt].longitude))
            let  totalDistance = firstLoc.dropFirst().reduce((firstLoc.first!, 0.0)) {  ($1 , $0.1 + $0.0.distance(from: $1)) }.1
            if (Locale.current.usesMetricSystem == false) {
                distance = "mi"
                totalLabel.text = "Total length: \(String(format:"%.01f", totalDistance / 1609.344)) \(distance)"
            }else {
               distance = "km"
                totalLabel.text = "Total length: \(String(format:"%.02f", totalDistance / 1000)) \(distance)"
            }
            addInt = addInt + 1
        }
    }
    
    @objc private func didTapbackButton() {
        //point remove !
        if addInt < 1 {
            addInt = 0
            secondLoc.removeAll()
            firstLoc.removeAll()
            distanceArray.removeAll()
            desCoordinate.removeAll()
            polyLine.removeAll()
            
        }else {
        addInt = addInt - 1
        mapView.removeOverlay(polyLine[addInt])
        secondLoc.removeLast()
        firstLoc.removeLast()
        distanceArray.removeLast()
        desCoordinate.removeLast()
        polyLine.removeLast()
            let  totalDistance = firstLoc.dropFirst().reduce((firstLoc.first!, 0.0)) {  ($1 , $0.1 + $0.0.distance(from: $1)) }.1
            if (Locale.current.usesMetricSystem == false) {
                distance = "mi"
                totalLabel.text = "Total length: \(String(format:"%.01f", totalDistance / 1609.344)) \(distance)"
            }else {
               distance = "km"
                totalLabel.text = "Total length: \(String(format:"%.02f", totalDistance / 1000)) \(distance)"
            }
        }
        
        
        
    }
    @objc private func didTapclearButton() {
        mapView.removeOverlays(mapView.overlays)
        totalLabel.text = "Total length: "
        addInt = 0
        secondLoc.removeAll()
        firstLoc.removeAll()
        distanceArray.removeAll()
        desCoordinate.removeAll()
        polyLine.removeAll()
    }
    
    
    // MARK: - PlusButtonMenu Buttons Layout
    //Buttons Model
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 60, height: 60))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemPink
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let measureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemPink
        let image = UIImage(named: "compass.png")
        button.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let setancorButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemPink
        let image = UIImage(named: "anchor.png")
        button.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let savecatchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemPink
        let image = UIImage(named: "fishing.png")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let savecurrentButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemPink
        let image = UIImage(named: "pin_fishing.png")
        button.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        button.setImage(image, for: .normal)
        //button.tintColor = .white
        //button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let aimImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        let image = UIImage(named: "aim1.png")
        imageView.image = image
        return imageView
    }()
    private let closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 60, height: 60))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGray
        let image = UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemBlue
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemBlue
        let image = UIImage(systemName: "arrow.uturn.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let clearButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 40, height: 40))
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let totalLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                            width: 200, height: 40))
        label.layer.shadowRadius = 30
        label.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        //label.layer.cornerRadius = 20
        //label.backgroundColor = .systemGreen
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
        
    }()
    private let pointcountLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                            width: 200, height: 40))
        label.layer.shadowRadius = 30
        label.layer.shadowOpacity = 0.3
        //button.layer.masksToBounds = true
        //label.layer.cornerRadius = 20
        //label.backgroundColor = .systemGreen
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
        
    }()
    

    //Show Miracle func!!
     @objc func showMiracle(view: UIViewController) {
         let slideVC = view
         slideVC.modalPresentationStyle = .custom
         slideVC.transitioningDelegate = self
         self.present(slideVC, animated: true, completion: nil)
     }


    
    // MARK: - SideMenu all controls..
    
    //Create SideMenu
    private var sideMenu: SideMenuNavigationController?
  
    //Menu Button Click
    @IBAction func menuBtn(_ sender: Any) {
        present(sideMenu!,  animated: true)
    }
    
    //Menu Button Select
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        //title = named.rawValue
        switch named {
        case .buying:
            performSegue(withIdentifier: "buying", sender: nil)
        //case .map:
         //   performSegue(withIdentifier: "buying", sender: nil)
        case .locations:
            performSegue(withIdentifier: "locations", sender: nil)
        case .fishing:
            performSegue(withIdentifier: "fishing", sender: nil)
        case .weather:
            performSegue(withIdentifier: "weather", sender: nil)
        case .solunar:
            performSegue(withIdentifier: "solunar", sender: nil)
        //case .settings:
            //performSegue(withIdentifier: "settings", sender: nil)
        case .about:
            performSegue(withIdentifier: "about", sender: nil)
        }
    }
}

// MARK: - Localization..

//String Dil Localizasyonu
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

//PresentationController bağlantısı
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
               // self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        
        return renderer
    }
    
}

 
 
// MARK: - My protocols here..

protocol MyProtocol: AnyObject {
    func sendData(coordinate: CLLocationCoordinate2D , title: String, subtitle: String)
    func sendmapType(mapType: MKMapType)
}


