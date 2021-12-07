//
//  HumidtyVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation
import Charts

class HumidtyVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var humidtyLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var humidtyPieChart: PieChartView!
    
    var hmdPieChartEntry = ChartDataEntry()
    var hmdminPieChartEntry = ChartDataEntry()
    var pieChart = PieChartView()
    var entries = [ChartDataEntry]()
    
    var text:String = ""
    
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
        //humidtyLabel?.text = text
        pieChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func updateChartData() {
        entries = [hmdPieChartEntry, hmdminPieChartEntry]
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
        
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        pieChart.frame = CGRect(x: 35, y: 30, width: view.frame.size.width, height: view.frame.size.height - 10)
        backgroundImage.isHidden = true
        //pieChart.center = view.center
        view.addSubview(pieChart)
        updateChartData()    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

