//
//  weatherVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 17.01.2021.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView


class weatherVC: UIViewController,  CLLocationManagerDelegate {
    
    var currentLocation = CLLocationCoordinate2D()
  
    var langChar = String()
    var metricSys = String()
    var gmtChar = String()
    var hourlySymbols:[String] = []
    var hourlyValues:[Int] = []
    var degree = Double()
    var tempDegree = String()
    
    //SubTitle Labels
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var SNLabel: UILabel!
    @IBOutlet weak var NLabel: UILabel!
    @IBOutlet weak var MoonLabel: UILabel!
    @IBOutlet weak var MoonView: UIView!
    @IBOutlet weak var moonImageView: UIImageView!
    
    
    
    
    @IBOutlet weak var moonDatePicker: UIDatePicker!
    @IBOutlet weak var MDLabel: UILabel!
    @IBOutlet weak var TWRLabel: UILabel!
    @IBOutlet weak var TWLLabel: UILabel!
    @IBOutlet weak var DSLabel: UILabel!
    @IBOutlet weak var DWLabel: UILabel!
    @IBOutlet weak var SRLabel: UILabel!
    @IBOutlet weak var SSLabel: UILabel!
    @IBOutlet weak var DLabel: UILabel!
    @IBOutlet weak var SunView: UIView!
    @IBOutlet weak var SunLabel: UILabel!
    @IBOutlet weak var TLabel: UILabel!
    @IBOutlet weak var SSRLabel: UILabel!
    @IBOutlet weak var SSSLabel: UILabel!
    @IBOutlet weak var sunImageView: UIImageView!
    
    //Tittle Labels
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mTypeImage: UIImageView!
    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var moonPhaseLabel: UILabel!
    @IBOutlet weak var moonDescLabel: UILabel!
    @IBOutlet weak var moonTransitLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var DawnLabel: UILabel!
    @IBOutlet weak var DuskLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var NightLabel: UILabel!
    @IBOutlet weak var midnightLabel: UILabel!
    @IBOutlet weak var ssunriseLabel: UILabel!
    @IBOutlet weak var suntransitLabel: UILabel!
    @IBOutlet weak var ssunsetLabel: UILabel!
    
    
    @IBAction func moonDatePicker(_ sender: Any) {
        //regional kısaltması
        langChar = Locale.current.identifier
        let langIndex = langChar.index(langChar.startIndex, offsetBy: 2)
        langChar = String(langChar[..<langIndex])    // "My
        //Metrik bilgisi
        if (Locale.current.usesMetricSystem == false) {
            self.metricSys = "imperial"
            self.tempDegree = "F"
        }else {
            self.metricSys = "metric"
            self.tempDegree = "C"
        }
        //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
        gmtChar = "\(TimeZone.current.abbreviation()!)"
        //tarih çek
        let now = moonDatePicker.date
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd"
        fetchMoon(lat: "\(currentLocation.latitude)", lon: "\(currentLocation.longitude)", date: "\(formatter.string(from: now))", locTime: String(gmtChar.suffix(2)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backImageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        mainScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 5, height: view.frame.size.height - 5)
        mainScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + 100)
        locationLabel.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        mTypeImage.frame = CGRect(x: (view.frame.size.width / 2) - 35, y: 45, width: 70, height: 70)
        moonDescLabel.frame = CGRect(x: 25, y: 120, width: view.frame.size.width - 50, height: 35)
        moonPhaseLabel.frame = CGRect(x: 25, y: 150, width: view.frame.size.width - 50, height: 35)
        moonDatePicker.frame = CGRect(x: 25, y: 0, width: view.frame.size.width - 50, height: 35)
        moonDatePicker.tintColor = .white
        //MoonView
        MoonView.frame = CGRect(x: 10, y: 190, width: view.frame.size.width - 20, height: 370)
        MoonLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 35)
        moonImageView.frame = CGRect(x: 30, y: 30, width: MoonView.frame.size.width - 65, height: MoonView.frame.size.height - 65)
        SNLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 15)
        moonTransitLabel.frame = CGRect(x: 10, y: 18, width: MoonView.frame.size.width - 10, height: 15)
        DLabel.frame = CGRect(x: 5, y: 100, width: MoonView.frame.size.width - 5, height: 15)
        DayLabel.frame = CGRect(x: 5, y: 115, width: MoonView.frame.size.width - 5, height: 15)
        SRLabel.frame = CGRect(x: 10, y: 140, width: MoonView.frame.size.width - 10, height: 15)
        SSLabel.frame = CGRect(x: 0, y: 140, width: MoonView.frame.size.width - 10, height: 15)
        sunRiseLabel.frame = CGRect(x: 13, y: 153, width: MoonView.frame.size.width - 10, height: 15)
        sunSetLabel.frame = CGRect(x: 0, y: 153, width: MoonView.frame.size.width - 13, height: 15)
        TWLLabel.frame = CGRect(x: 70, y: (MoonView.frame.size.height / 2) - 15, width: MoonView.frame.size.width - 80, height: 15)
        TWRLabel.frame = CGRect(x: 70, y: (MoonView.frame.size.height / 2) - 15, width: moonImageView.frame.size.width - 80, height: 15)
        DWLabel.frame = CGRect(x: 10, y: (MoonView.frame.size.height / 2), width: MoonView.frame.size.width - 10, height: 15)
        DSLabel.frame = CGRect(x: 0, y: (MoonView.frame.size.height / 2), width: MoonView.frame.size.width - 10, height: 15)
        DawnLabel.frame = CGRect(x: 10, y: (MoonView.frame.size.height / 2) + 13, width: MoonView.frame.size.width - 10, height: 15)
        DuskLabel.frame = CGRect(x: 0, y: (MoonView.frame.size.height / 2) + 13, width: MoonView.frame.size.width - 10, height: 15)
        NLabel.frame = CGRect(x: 5, y:  (MoonView.frame.size.height / 2) + 30, width: MoonView.frame.size.width - 10, height: 15)
        NightLabel.frame = CGRect(x: 5, y:  (MoonView.frame.size.height / 2) + 43, width: MoonView.frame.size.width - 10, height: 15)
        MDLabel.frame = CGRect(x: 10, y:  MoonView.frame.size.height - 43, width: MoonView.frame.size.width - 10, height: 15)
        midnightLabel.frame = CGRect(x: 10, y:  MoonView.frame.size.height - 30, width: MoonView.frame.size.width - 10, height: 15)
        MoonView.layer.shadowRadius = 10
        MoonView.layer.shadowOpacity = 0.3
        MoonView.layer.cornerRadius = 10
        MoonView.layer.masksToBounds = true
        //SunView
        SunView.frame = CGRect(x: 10, y: MoonView.frame.size.height + 200, width: view.frame.size.width - 20, height: 130)
        SunLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 35)
        sunImageView.frame = CGRect(x: 10, y: 30, width: SunView.frame.size.width - 20, height: SunView.frame.size.height - 10)
        SSRLabel.frame = CGRect(x: 80, y: (SunView.frame.size.height / 2) + 20, width: SunView.frame.size.width - 80, height: 15)
        SSSLabel.frame = CGRect(x: 0, y: (SunView.frame.size.height / 2) + 20, width: SunView.frame.size.width - 80, height: 15)
        ssunriseLabel.frame = CGRect(x: 83, y: (SunView.frame.size.height / 2) + 33, width: SunView.frame.size.width - 80, height: 15)
        ssunsetLabel.frame = CGRect(x: 0, y: (SunView.frame.size.height / 2) + 33, width: SunView.frame.size.width - 83, height: 15)
        TLabel.frame = CGRect(x: 10, y: (SunView.frame.size.height / 2) + 30 , width: SunView.frame.size.width - 10, height: 15)
        suntransitLabel.frame = CGRect(x: 10, y: (SunView.frame.size.height / 2) + 43, width: SunView.frame.size.width - 10, height: 15)
        SunView.layer.shadowRadius = 10
        SunView.layer.shadowOpacity = 0.3
        SunView.layer.cornerRadius = 10
        SunView.layer.masksToBounds = true
        MoonView.isHidden = true
        SunView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAnimation()
        
    }
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: .gray, padding: 0)
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
                self.tempDegree = "F"
            }else {
                self.metricSys = "metric"
                self.tempDegree = "C"
            }
            
            //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
            self.gmtChar = "\(TimeZone.current.abbreviation()!)"
            self.fetchMoon(lat: "\(self.currentLocation.latitude)", lon: "\(self.currentLocation.longitude)", date: "\(formatter.string(from: now))", locTime: String(self.gmtChar.suffix(2)))
        }
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
                    self.degree = Double(.pi * (model.sunRiseDec ?? 1.99968) / 180) * 1000
                    self.mTypeImage.image = UIImage(named: model.moonPhase ?? "00:00")
                    self.moonDescLabel.text = model.moonPhase?.wlocalized()
                    self.moonPhaseLabel.text = "\(Int(model.moonIllumination ?? 0.0 * 100))%"
                    self.sunSetLabel.text = model.sunSet
                    let dtimeFormat = DateFormatter()
                    dtimeFormat.dateFormat = "HH:mm"
                    let dusk = dtimeFormat.date(from: model.sunSet ?? "00:00")
                    let mdusk = dusk?.addingTimeInterval(TimeInterval(30.0 * 60.0))
                    self.DuskLabel.text = dtimeFormat.string(from: mdusk!)
                    let timeFormat = DateFormatter()
                    timeFormat.dateFormat = "hh:mm"
                    self.sunRiseLabel.text = model.sunRise
                    let dawn = timeFormat.date(from: model.sunRise ?? "00:40")
                    let mdawn = dawn?.addingTimeInterval(TimeInterval(-30.0 * 60.0))
                    if mdawn == nil {
                        self.DawnLabel.text = "error"
                    } else {
                    self.DawnLabel.text = timeFormat.string(from: mdawn!)
                    }
                    self.moonTransitLabel.text = model.sunTransit
                    self.midnightLabel.text = "00:00" //
                    self.ssunsetLabel.text = model.moonSet

                    let dayformatter = DateFormatter()
                        dayformatter.dateFormat = "HH:mm"
                    let daydate1 = dayformatter.date(from: model.sunRise ?? "00:00")!
                    let daydate2 = dayformatter.date(from: model.sunSet ?? "00:00")!
                    let dayelapsedTime = daydate2.timeIntervalSince(daydate1)
                    let dayhours = floor(dayelapsedTime / 60 / 60)
                    let dayminutes = floor((dayelapsedTime - (dayhours * 60 * 60)) / 60)
                    
                    for (key, value) in model.hourlyRating {
                        self.hourlySymbols.append(key)
                        self.hourlyValues.append(value)
                               }
                    
                    self.ssunriseLabel.text = model.moonRise
                    self.suntransitLabel.text = model.moonTransit
                    self.DayLabel.text = "\(Int(dayhours)) hr and \(Int(dayminutes)) min"
                    self.NightLabel.text = "\(24 - Int(dayhours)) hr and \(60 - Int(dayminutes)) min"
                    self.MoonView.isHidden = false
                    self.SunView.isHidden = false
                    }
            }
            catch {
                print("failed..")
            }
        }
        task.resume()
    }
}

//String Dil Localizasyonu
extension String {
    func wlocalized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
