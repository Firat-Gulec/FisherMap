//
//  WindVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation

class WindVC: UIViewController {

    @IBOutlet weak var windLabel: UILabel!
    
    var currentLocation = CLLocationCoordinate2D()
    
    var list = [List]()
    var temp = [String]()
    var temp_max = [String]()
    var temp_min = [String]()
    var feels_like = [String]()
    var humidity = [String]()
    var dt_txt = [String]()
    var visib = [String]()
    var main = [String]()
    var descrip = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
