//
//  PinLocationView.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 17.02.2021.
//



import UIKit
import CoreLocation
import MapKit


class PinLocationView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    // MARK: -
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var currentLocation = CLLocationCoordinate2D()
    var annonation = MKPointAnnotation()
    var delegate: MyProtocol?
    
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var createDatePicker: UIDatePicker!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        print(currentLocation)
    
    
        slideIdicator.roundCorners(.allCorners, radius: 10)
        //subscribeButton.roundCorners(.allCorners, radius: 10)
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.frame = CGRect(x: view.frame.size.width - 90, y: 40, width: 80, height: 35)
        cancelButton.frame = CGRect(x: view.frame.size.width - 180, y: 40, width: 80, height: 35)
        titleLabel.frame = CGRect(x: 20, y: 20, width: 235, height: 60)
        locationImage.frame = CGRect(x: (view.frame.size.width / 2)-25, y: 100, width: 50, height: 50)
        titleTextField.frame = CGRect(x: 25, y: 190, width: view.frame.size.width - 50, height: 35)
        subtitleTextField.frame = CGRect(x: 25, y: 240, width: view.frame.size.width - 50, height: 35)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: titleTextField.frame.height - 2, width: titleTextField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        titleTextField.borderStyle = .none
        titleTextField.layer.addSublayer(bottomLine)
        let bottomLinee = CALayer()
        bottomLinee.frame = CGRect(x: 0, y: subtitleTextField.frame.height - 2, width: subtitleTextField.frame.width, height: 2)
        bottomLinee.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        subtitleTextField.borderStyle = .none
        subtitleTextField.layer.addSublayer(bottomLinee)
        
        createDatePicker.frame = CGRect(x: 25, y: 290, width: view.frame.size.width - 50, height: 35)
        favoriteButton.frame = CGRect(x: 25, y: 340, width: view.frame.size.width - 50, height: 40)
      /*  let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = .systemPink
        */
       noteTextField.frame = CGRect(x: 25, y: 395, width: view.frame.size.width - 50, height: 35)
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    @IBAction func favoriteButton(_ sender: Any) {
        
    }
    
   
        
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                    
                }
            }
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        createItem(cLat: currentLocation.latitude, cLon: currentLocation.longitude, createDate: createDatePicker.date, imageName: "fishing.png", locName: titleTextField.text!, locNote: noteTextField.text!, favorite: true, locSub: subtitleTextField.text!)
        delegate?.sendData(coordinate: currentLocation , title: titleTextField.text!, subtitle: subtitleTextField.text!)
                self.dismiss(animated: true) {
                    //Image ve Seçimi ve açıklamaları eklenecek!
                }
    }
    
  
    // MARK: - CoreDATA fetch (get, create, update, delete)
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //Create
    func createItem(cLat: Double, cLon: Double, createDate: Date, imageName: String, locName: String, locNote: String, favorite: Bool, locSub: String) {
        let newItem = Locationdata(context: context)
        newItem.id = UUID()
        newItem.cLat =  CLLocationDegrees(cLat)
        newItem.cLon = CLLocationDegrees(cLon)
        newItem.locSub = locSub
        newItem.createDate = createDate
        newItem.imageName = imageName
        newItem.locName = locName
        newItem.locNote = locNote
        newItem.favorite = favorite
        do {
            try context.save()
        }catch {
            //error
        }
    }
  
    
    
}
