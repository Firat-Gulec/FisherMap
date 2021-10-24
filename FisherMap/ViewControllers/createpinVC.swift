//
//  createpinVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 19.02.2021.
//

import UIKit
import CoreLocation
import MapKit




class createpinVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    
    var annonation = MKPointAnnotation()
    var currentLocation = CLLocationCoordinate2D()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    

    
    @IBAction func saveBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        annonation.coordinate = currentLocation
        annonation.title = "New Location"
        annonation.subtitle = "test"
        
        
        
        
        
    }
    
    
    
    
    
    
    
    

}
