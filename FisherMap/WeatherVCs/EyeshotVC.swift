//
//  EyeshotVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation

class EyeshotVC: UIViewController {

    @IBOutlet weak var eyeshotLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        backgroundImage.isHidden = true
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
