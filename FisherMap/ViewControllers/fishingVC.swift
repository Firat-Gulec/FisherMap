//
//  catchesVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import NVActivityIndicatorView
import CoreLocation
import Charts

class fishingVC: UIViewController, ChartViewDelegate {

    var currentLocation = CLLocationCoordinate2D()
  
    var langChar = String()
    var metricSys = String()
    var gmtChar = String()
    var hourlySymbols:[String] = []
    var hourlyValues:[Int] = []
    var degree = Double()
    
    //Chart Testing..
    var barChart = BarChartView()
    
    
    
    
    
    
    
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
        print(currentLocation)
        barChart.delegate = self
        self.startAnimation()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .orbit, color: .gray, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            loading.stopAnimating()
            //tarih çek
            let now = Date()
            print("\(TimeZone.current.abbreviation()!)")
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyyMMdd"
            //moontimeLabel.text = "\(formatter.string(from: now))"
            //regional kısaltması
            self.langChar = Locale.current.identifier
            let langIndex = self.langChar.index(self.langChar.startIndex, offsetBy: 2)
            self.langChar = String(self.langChar[..<langIndex])    // "My
            //Metrik bilgisi
            if (Locale.current.usesMetricSystem == true) {
                self.metricSys = "imperial"
            }else {
                self.metricSys = "metric"
            }
            //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
            self.gmtChar = "\(TimeZone.current.abbreviation()!)"
            self.fetchMoon(lat: "\(self.currentLocation.latitude)", lon: "\(self.currentLocation.longitude)", date: "\(formatter.string(from: now))", locTime: String(self.gmtChar.suffix(2)))
        }
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
        fishGraphicView.isHidden = true
        fishingTimeView.isHidden = true
        
        
        
    }

    
    @IBAction func dayChange(_ sender: Any) {
        barChart.clear()
        
        //regional kısaltması
        langChar = Locale.current.identifier
        let langIndex = langChar.index(langChar.startIndex, offsetBy: 2)
        langChar = String(langChar[..<langIndex])    // "My
        //Metrik bilgisi
        if (Locale.current.usesMetricSystem == false) {
            self.metricSys = "imperial"
        }else {
            self.metricSys = "metric"
        }
        //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
        gmtChar = "\(TimeZone.current.abbreviation()!)"
        //tarih çek
        let now = dayDatePicker.date
        print("\(TimeZone.current.abbreviation()!)")
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd"
        fetchMoon(lat: "\(currentLocation.latitude)", lon: "\(currentLocation.longitude)", date: "\(formatter.string(from: now))", locTime: String(gmtChar.suffix(2)))
        
    }
    
    
    //Ay Durumu çek kardeş
    func fetchMoon(lat: String, lon: String, date: String, locTime: String) {
        guard let url = URL(string: "https://api.solunar.org/solunar/\(lat),\(lon),\(date),\(locTime)")
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
              return
            }
            do {
                let model = try JSONDecoder().decode(SolunarModel.self,
                                                     from: data)
                DispatchQueue.main.async {
                    self.barChart.frame = CGRect(x: 0, y: 0, width: self.fishGraphicView.frame.width, height: self.fishGraphicView.frame.height)
                    self.barChart.center = self.fishGraphicView.center
                    self.fishGraphicView.addSubview(self.barChart)
                    var entries = [BarChartDataEntry]()
                    for (key, value) in model.hourlyRating.sorted(by: <) {
                        //entries.append(BarChartDataEntry(x: Double(Int(key)!), y: Double(value)))
                        self.hourlySymbols.append(key)
                        self.hourlyValues.append(value)
                               }
                    let symbolssorted = self.hourlySymbols.enumerated().sorted(by: {$0.element < $1.element})
                    
                    let sybolson = symbolssorted.map{$0.offset}
                    
                    
                    print("\(self.hourlyValues)")
                    for x in 0..<24 {
                        entries.append(BarChartDataEntry(x: Double(sybolson[x]), y: Double(self.hourlyValues[sybolson[x]])))
                    }
                    let set = BarChartDataSet(entries: entries)
                    set.colors = ChartColorTemplates.joyful()
                    let data = BarChartData(dataSet: set)
                    self.barChart.data = data
                    
                    self.fishGraphicView.isHidden = false
                    self.fishingTimeView.isHidden = false
                    }
            }
            catch {
                print("failed..")
            }
        }
        task.resume()
    }

}
