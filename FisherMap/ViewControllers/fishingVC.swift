//
//  catchesVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import NVActivityIndicatorView

class fishingVC: UIViewController {

    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var fishingscrollView: UIScrollView!
    @IBOutlet weak var fishingLocLabel: UILabel!
    @IBOutlet weak var dayRateImage: UIImageView!
    @IBOutlet weak var dayDiscLabel: UILabel!
    @IBOutlet weak var dayDatePicker: UIDatePicker!
    @IBOutlet weak var fishGraphicView: UIView!
    @IBOutlet weak var fishingTimeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        fishingscrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 10, height: view.frame.size.height - 10)
        fishingscrollView.contentSize = CGSize(width: view.frame.size.width, height: 900)
        fishingLocLabel.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        dayRateImage.frame = CGRect(x: (view.frame.size.width / 2) - 35, y: 45, width: 70, height: 70)
        dayDiscLabel.frame = CGRect(x: 25, y: 120, width: view.frame.size.width - 50, height: 35)
        dayDatePicker.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        fishGraphicView.frame = CGRect(x: 10, y: 190, width: view.frame.size.width - 20, height: 370)
        fishingTimeView.frame = CGRect(x: 10, y: fishGraphicView.frame.size.height + 200, width: view.frame.size.width - 20, height: 200)
    
        
        
        
    }

    
    @IBAction func dayChange(_ sender: Any) {
        
        
    }
    
    

}
