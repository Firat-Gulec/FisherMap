//
//  uvVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation
import Charts

class CloudsVC: UIViewController, ChartViewDelegate {

    var cloudPieChartEntry = ChartDataEntry()
    var cloudminPieChartEntry = ChartDataEntry()
    var pieChart = PieChartView()
    var entries = [ChartDataEntry]()
    
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        pieChart.frame = CGRect(x: 35, y: 30, width: view.frame.size.width, height: view.frame.size.height - 10)
        backgroundImage.isHidden = true
        //pieChart.center = view.center
        view.addSubview(pieChart)
        updateChartData()    
    }
    
    
    
    func updateChartData() {
        entries = [cloudPieChartEntry, cloudminPieChartEntry]
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        set.label = ""
        let data = PieChartData(dataSet: set)
        
        pieChart.data = data
        pieChart.drawEntryLabelsEnabled = false
        pieChart.data?.setDrawValues(false)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.entryLabelColor = UIColor.clear
        pieChart.drawCenterTextEnabled = false

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
