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
    var lineChart = LineChartView()
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var fishingscrollView: UIScrollView!
    @IBOutlet weak var fishingLocLabel: UILabel!
    @IBOutlet weak var dayRateImage: UIImageView!
    @IBOutlet weak var dayDiscLabel: UILabel!
    @IBOutlet weak var dayDatePicker: UIDatePicker!
    @IBOutlet weak var fishgraphLabel: UILabel!
    @IBOutlet weak var fishGraphicView: UIView!
    @IBOutlet weak var fishingTimeView: UIView!
    //Major - Minor Times objects
    @IBOutlet weak var majorImage: UIImageView!
    @IBOutlet weak var minorImage: UIImageView!
    @IBOutlet weak var majorstartLabel: UILabel!
    @IBOutlet weak var majorstopLabel: UILabel!
    @IBOutlet weak var minorstartLabel: UILabel!
    @IBOutlet weak var minorstopLabel: UILabel!
    @IBOutlet weak var majminLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        self.startAnimation()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: .darkGray, padding: 0)
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
            let now = self.dayDatePicker.date
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
        fishingscrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 5, height: view.frame.size.height - 5)
        fishingscrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + 100)
        fishingLocLabel.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        dayRateImage.frame = CGRect(x: (view.frame.size.width / 2) - 35, y: 45, width: 70, height: 70)
        dayDiscLabel.frame = CGRect(x: 25, y: 120, width: view.frame.size.width - 50, height: 35)
        dayDatePicker.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        fishGraphicView.frame = CGRect(x: 10, y: 190, width: view.frame.size.width - 20, height: view.frame.size.height / 3)
        fishgraphLabel.frame = CGRect(x: 15, y: 5, width: view.frame.size.width - 20, height: 25)
        fishingTimeView.frame = CGRect(x: 10, y: fishGraphicView.frame.size.height + 200, width: view.frame.size.width - 20, height: 200)
        majminLabel.frame = CGRect(x: 15, y: 5, width: fishingTimeView.frame.size.width - 15, height: 25)
        majorImage.frame = CGRect(x: 15, y: 30, width: (fishingTimeView.frame.size.width / 2) - 20, height: fishingTimeView.frame.size.height - 50)
        minorImage.frame = CGRect(x: majorImage.frame.size.width + 25, y: 30, width: majorImage.frame.size.width, height: fishingTimeView.frame.size.height - 50)
        minorImage.layer.cornerRadius = 10
        majorImage.layer.cornerRadius = 10
        majorstartLabel.frame = CGRect(x: 15, y: 45, width: (fishingTimeView.frame.size.width / 2) - 30, height: 25)
        majorstopLabel.frame = CGRect(x: 15, y: majorImage.frame.size.height, width: (fishingTimeView.frame.size.width / 2) - 30, height: 25)
        minorstartLabel.frame = CGRect(x: majorImage.frame.size.width + 25, y: 45, width: majorImage.frame.size.width - 15, height: 25)
        minorstopLabel.frame = CGRect(x: majorImage.frame.size.width + 25, y: majorImage.frame.size.height, width: majorImage.frame.size.width - 15, height: 25)
        
        fishGraphicView.isHidden = true
        fishGraphicView.layer.cornerRadius = 10
        fishingTimeView.layer.cornerRadius = 10
        fishingTimeView.isHidden = true
        lineChart.frame = CGRect(x: 0, y: 25, width: fishGraphicView.frame.width, height: fishGraphicView.frame.height - 25)
        //self.lineChart.center = self.fishGraphicView.center
        fishGraphicView.addSubview(lineChart)
        lineChart.layer.cornerRadius = 10
    }
    
    @IBAction func dayChange(_ sender: Any) {
        fishGraphicView.isHidden = true
        fishingTimeView.isHidden = true
        lineChart.removeFromSuperview()
        lineChart.lineData?.clearValues()
        lineChart.clearAllViewportJobs()
        lineChart.frame = CGRect(x: 0, y: 25, width: fishGraphicView.frame.width, height: fishGraphicView.frame.height - 25)
        fishGraphicView.addSubview(lineChart)
        startAnimation()
    }
    
    //Ay Durumu çek kardeş
    func fetchMoon(lat: String, lon: String, date: String, locTime: String) {
        guard let url = URL(string: "https://api.solunar.org/solunar/\(lat),\(lon),\(date),\(locTime)")
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { edata, response, error in
            guard let edata = edata, error == nil else {
              return
            }
            do {
                let model = try JSONDecoder().decode(SolunarModel.self,
                                                     from: edata)
                DispatchQueue.main.async {
                    self.hourlyValues.removeAll()
                    self.hourlySymbols.removeAll()
                    var entries: [ChartDataEntry] = []
                    for (key, value) in model.hourlyRating.sorted(by: <) {
                        //entries.append(BarChartDataEntry(x: Double(Int(key)!), y: Double(value)))
                        self.hourlySymbols.append(key)
                        self.hourlyValues.append(value)
                               }
                    let symbolssorted = self.hourlySymbols.enumerated().sorted(by: {$0.element < $1.element})
                    let sybolson = symbolssorted.map{$0.offset}
                    entries.removeAll()
                    self.dayDiscLabel.text = "\(String(describing: model.dayRating))"
                    self.majorstartLabel.text = "\(model.major1Start ?? "null") - \(model.major1Stop ?? "null")"
                    self.majorstopLabel.text = "\(model.major2Start ?? "null") - \(model.major2Stop ?? "null")"
                    self.minorstartLabel.text = "\(model.minor1Start ?? "null") - \(model.minor1Stop ?? "null")"
                    self.minorstopLabel.text = "\(model.minor2Start ?? "null") - \(model.minor2Stop ?? "null")"
                    self.lineChart.rightAxis.enabled = false
                    self.lineChart.leftAxis.labelPosition = .outsideChart
                    self.lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
                    self.lineChart.leftAxis.setLabelCount(6, force: false)
                    self.lineChart.leftAxis.labelTextColor = .white
                    self.lineChart.leftAxis.axisLineColor = .systemBlue
                    self.lineChart.xAxis.enabled = true
                    self.lineChart.xAxis.labelPosition = .bottom
                    self.lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
                    self.lineChart.xAxis.setLabelCount(6, force: false)
                    self.lineChart.xAxis.labelTextColor = .white
                    self.lineChart.xAxis.axisLineColor = .systemBlue
                    for sort in sybolson {
                        entries.append(ChartDataEntry(x: Double(sybolson[sort]), y: Double(self.hourlyValues[sybolson[sort]])))
                    }
                    let set = LineChartDataSet(entries: entries, label: "Hourly Data")
                    set.label = ""
                    set.drawCirclesEnabled = false
                    set.mode = .cubicBezier
                    set.lineWidth = 2
                    //set.colors = ChartColorTemplates.material()
                    set.setColor(.black)
                    set.fill = Fill(color: .black)
                    set.fillAlpha = 0.8
                    set.drawFilledEnabled = true
                    self.lineChart.data?.clearValues()
                    self.lineChart.data?.notifyDataChanged()
                    self.lineChart.notifyDataSetChanged()
                    self.lineChart.clearValues()
                   // self.lineChart.BarLineScatterCandleBubbleRenderer.
                    let linedata = LineChartData(dataSet: set)
                    linedata.setDrawValues(false)
                    self.lineChart.data = linedata
                    self.lineChart.animate(xAxisDuration: 2.0)
                    self.fishGraphicView.isHidden = false
                    self.fishingTimeView.isHidden = false
                    //self.lineChart.backgroundColor = .none
                    }
            }
            catch {
                print("failed..")
            }
        }
        task.resume()
    }

}
