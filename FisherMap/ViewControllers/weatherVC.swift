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
    
    //SubTitle Labels
    @IBOutlet weak var SNLabel: UILabel!
    @IBOutlet weak var NLabel: UILabel!
    @IBOutlet weak var MoonLabel: UILabel!
    @IBOutlet weak var MoonView: UIView!
    @IBOutlet weak var moonImageView: UIImageView!
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
    

    override func viewWillAppear(_ animated: Bool) {
        locationLabel.frame = CGRect(x: 25, y: 70, width: view.frame.size.width - 50, height: 35)
        mTypeImage.frame = CGRect(x: (view.frame.size.width / 2) - 35, y: 105, width: 70, height: 70)
        moonDescLabel.frame = CGRect(x: 25, y: 180, width: view.frame.size.width - 50, height: 35)
        moonPhaseLabel.frame = CGRect(x: 25, y: 210, width: view.frame.size.width - 50, height: 35)
        //MoonView
        MoonView.frame = CGRect(x: 10, y: 250, width: view.frame.size.width - 20, height: 370)
        MoonLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 35)
        moonImageView.frame = CGRect(x: 40, y: 40, width: MoonView.frame.size.width - 80, height: MoonView.frame.size.height - 80)
        SNLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 15)
        moonTransitLabel.frame = CGRect(x: 10, y: 18, width: MoonView.frame.size.width - 10, height: 15)
        DLabel.frame = CGRect(x: 10, y: 100, width: MoonView.frame.size.width - 10, height: 15)
        DayLabel.frame = CGRect(x: 10, y: 115, width: MoonView.frame.size.width - 10, height: 15)
        SRLabel.frame = CGRect(x: 10, y: 140, width: MoonView.frame.size.width - 10, height: 15)
        SSLabel.frame = CGRect(x: 0, y: 140, width: MoonView.frame.size.width - 10, height: 15)
        sunRiseLabel.frame = CGRect(x: 13, y: 153, width: MoonView.frame.size.width - 10, height: 15)
        sunSetLabel.frame = CGRect(x: 0, y: 153, width: MoonView.frame.size.width - 13, height: 15)
        TWLLabel.frame = CGRect(x: 80, y: (MoonView.frame.size.height / 2) - 10, width: MoonView.frame.size.width - 80, height: 15)
        TWRLabel.frame = CGRect(x: 80, y: (MoonView.frame.size.height / 2) - 10, width: moonImageView.frame.size.width - 80, height: 15)
        DWLabel.frame = CGRect(x: 10, y: (MoonView.frame.size.height / 2), width: MoonView.frame.size.width - 10, height: 15)
        DSLabel.frame = CGRect(x: 0, y: (MoonView.frame.size.height / 2), width: MoonView.frame.size.width - 10, height: 15)
        DawnLabel.frame = CGRect(x: 10, y: (MoonView.frame.size.height / 2) + 13, width: MoonView.frame.size.width - 10, height: 15)
        DuskLabel.frame = CGRect(x: 0, y: (MoonView.frame.size.height / 2) + 13, width: MoonView.frame.size.width - 10, height: 15)
        NLabel.frame = CGRect(x: 10, y:  (MoonView.frame.size.height / 2) + 30, width: MoonView.frame.size.width - 10, height: 15)
        NightLabel.frame = CGRect(x: 10, y:  (MoonView.frame.size.height / 2) + 43, width: MoonView.frame.size.width - 10, height: 15)
        MDLabel.frame = CGRect(x: 10, y:  MoonView.frame.size.height - 35, width: MoonView.frame.size.width - 10, height: 15)
        midnightLabel.frame = CGRect(x: 10, y:  MoonView.frame.size.height - 23, width: MoonView.frame.size.width - 10, height: 15)
        MoonView.layer.shadowRadius = 10
        MoonView.layer.shadowOpacity = 0.3
        MoonView.layer.cornerRadius = 10
        MoonView.layer.masksToBounds = true
        //SunView
        SunView.frame = CGRect(x: 10, y: MoonView.frame.size.height + 260, width: view.frame.size.width - 20, height: 200)
        SunLabel.frame = CGRect(x: 10, y: 5, width: MoonView.frame.size.width - 10, height: 35)
        sunImageView.frame = CGRect(x: 10, y: 40, width: SunView.frame.size.width - 20, height: SunView.frame.size.height - 80)
        SSRLabel.frame = CGRect(x: 80, y: (SunView.frame.size.height / 2) - 10, width: SunView.frame.size.width - 80, height: 15)
        SSSLabel.frame = CGRect(x: 0, y: (SunView.frame.size.height / 2) - 10, width: SunView.frame.size.width - 80, height: 15)
        ssunriseLabel.frame = CGRect(x: 83, y: (SunView.frame.size.height / 2) + 5, width: SunView.frame.size.width - 80, height: 15)
        ssunsetLabel.frame = CGRect(x: 0, y: (SunView.frame.size.height / 2) + 5, width: SunView.frame.size.width - 83, height: 15)
        TLabel.frame = CGRect(x: 10, y: (SunView.frame.size.height / 2) - 10, width: SunView.frame.size.width - 10, height: 15)
        suntransitLabel.frame = CGRect(x: 10, y: (SunView.frame.size.height / 2) + 5, width: SunView.frame.size.width - 10, height: 15)
        SunView.layer.shadowRadius = 10
        SunView.layer.shadowOpacity = 0.3
        SunView.layer.cornerRadius = 10
        SunView.layer.masksToBounds = true
        MoonView.isHidden = true
        SunView.isHidden = true
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentLocation)
        self.startAnimation()
        
    }
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .orbit, color: .black, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        //loading.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
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
    
    var degree = Double()
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
                    
                    
                    self.degree = Double(.pi * model.sunRiseDec / 180) * 1000
                    print("\(self.degree)")
                    self.mTypeImage.image = UIImage(named: model.moonPhase)
                    self.moonDescLabel.text = model.moonPhase.wlocalized()
                    self.moonPhaseLabel.text = "\(Int(model.moonIllumination * 100))%"
                    self.sunSetLabel.text = model.sunSet
                    let dtimeFormat = DateFormatter()
                    dtimeFormat.dateFormat = "HH:mm"
                    let dusk = dtimeFormat.date(from: model.sunSet)
                    let mdusk = dusk?.addingTimeInterval(TimeInterval(30.0 * 60.0))
                    self.DuskLabel.text = dtimeFormat.string(from: mdusk!)
                    let timeFormat = DateFormatter()
                    timeFormat.dateFormat = "hh:mm"
                    self.sunRiseLabel.text = model.sunRise
                    let dawn = timeFormat.date(from: model.sunRise)
                    let mdawn = dawn?.addingTimeInterval(TimeInterval(-30.0 * 60.0))
                    self.DawnLabel.text = timeFormat.string(from: mdawn!)
                    self.moonTransitLabel.text = model.sunTransit
                    self.midnightLabel.text = "00:00" //
                    self.ssunsetLabel.text = model.moonSet
                    
                    
                    let dayformatter = DateFormatter()
                        dayformatter.dateFormat = "HH:mm"
                    let daydate1 = dayformatter.date(from: model.sunRise)!
                    let daydate2 = dayformatter.date(from: model.sunSet)!
                        let dayelapsedTime = daydate2.timeIntervalSince(daydate1)
                        let dayhours = floor(dayelapsedTime / 60 / 60)
                        let dayminutes = floor((dayelapsedTime - (dayhours * 60 * 60)) / 60)
                    
                    self.ssunriseLabel.text = "efs"
                    self.suntransitLabel.text = model.moonTransit
                    self.DayLabel.text = "\(Int(dayhours)) hr and \(Int(dayminutes)) min"
                    self.NightLabel.text = "\(24 - Int(dayhours)) hr and \(60 - Int(dayminutes)) min"
                    self.MoonView.isHidden = false
                    self.SunView.isHidden = false
                    
                  /*  self.moonImageView.image = UIImage(named: model.moonPhase)
                    self.MoonphsLabel.text = model.moonPhase.wlocalized()
                    self.moonsetLabel.text = model.moonSet
                    self.moonriseLabel.text = model.moonRise
                    self.moontraLabel.text = model.moonTransit
                    self.moonunderLabel.text = model.moonUnder
                    self.moonrateLabel.text = "\(model.dayRating)"
                    self.moonilluLabel.text = "\(model.moonIllumination)"
              */  }
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
