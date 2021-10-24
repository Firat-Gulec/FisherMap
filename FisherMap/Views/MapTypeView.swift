//
//  OverlayView.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import CoreLocation

class MapTypeView: UIViewController,  CLLocationManagerDelegate {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var delegate: MyProtocol?
    
    var currentLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
      //  subscribeButton.roundCorners(.allCorners, radius: 10)
    }
    
    @IBOutlet weak var mpTypeLabel: UILabel!
    @IBOutlet weak var mpStaButton: UIButton!
    @IBOutlet weak var mpSatButton: UIButton!
    @IBOutlet weak var mpHybButton: UIButton!
    @IBOutlet weak var mpS3DButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        mpTypeLabel.frame = CGRect(x: 20, y: 20, width: 300, height: 40)
        mpStaButton.frame = CGRect(x: 15, y: 75, width: (view.frame.size.width / 2) - 20, height: 120)
        mpSatButton.frame = CGRect(x: (view.frame.size.width / 2) + 5, y: 75, width: (view.frame.size.width / 2) - 20, height: 120)
        mpHybButton.frame = CGRect(x: 15, y: 205, width: (view.frame.size.width / 2) - 20, height: 120)
        mpS3DButton.frame = CGRect(x: (view.frame.size.width / 2) + 5, y: 205, width: (view.frame.size.width / 2) - 20, height: 120)
        
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainVC" {
        //let destinationVC = segue.destination as! ViewController
       // destinationVC.mapView.reloadInputViews()
        }
    }
    

    
    
    @IBOutlet weak var slideIdicator: UIView!

    @IBAction func mpStaButton(_ sender: Any) {
        delegate?.sendmapType(mapType: .standard)
                self.dismiss(animated: true) {
                    //Image ve Seçimi ve açıklamaları eklenecek!
                }
    }
    
    @IBAction func mpHybButton(_ sender: Any) {
        delegate?.sendmapType(mapType: .hybrid)
                self.dismiss(animated: true) {
                    //Image ve Seçimi ve açıklamaları eklenecek!
                }
    }
    
    @IBAction func mpSatButton(_ sender: Any) {
        delegate?.sendmapType(mapType: .satellite)
                self.dismiss(animated: true) {
                    //Image ve Seçimi ve açıklamaları eklenecek!
                }
    }
    
    @IBAction func mpS3dButton(_ sender: Any) {
        delegate?.sendmapType(mapType: .mutedStandard)
                self.dismiss(animated: true) {
                    //Image ve Seçimi ve açıklamaları eklenecek!
                }
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
}
