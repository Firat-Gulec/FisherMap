//
//  OverlayView.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import CoreLocation
import MapKit

class LocPinView: UIViewController,  CLLocationManagerDelegate, MKMapViewDelegate {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var currentLocation = CLLocationCoordinate2D()
    var locName = String()
    var subName = String()
    var locNote = String()
    var createDate = Date()
    var favorite = Bool()
    var locImage = String()
    var annonation = MKPointAnnotation()
    var delegate: MyProtocol?
    
    @IBOutlet weak var locPinLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var slideIdicator: UIView!

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainVC" {
        //let destinationVC = segue.destination as! ViewController
       // destinationVC.mapView.reloadInputViews()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        locPinLabel.text = "Pin Information"
        nameLabel.text = locName
        subLabel.text = subName
        noteLabel.text = locNote
        if favorite == false {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
            favoriteButton.setImage(image, for: .normal)
        }else {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
            favoriteButton.setImage(image, for: .normal)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
      //  subscribeButton.roundCorners(.allCorners, radius: 10)
    }
    
    override func viewDidLayoutSubviews() {
        nameLabel.frame = CGRect(x: 20, y: 270, width: view.frame.size.width - 50, height: 35)
        subLabel.frame = CGRect(x: 20, y: 310, width: view.frame.size.width - 50, height: 35)
        noteLabel.frame = CGRect(x: 20, y: 350, width: view.frame.size.width - 50, height: 35)
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
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
    
    
    // MARK: - CoreDATA fetch (get, create, update, delete)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   // private var item = [Locationdata]()
    
    //Get item
    func getItem(item: Locationdata ) {
           print(item.locName!)
    }
}
