//
//  weatherVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 17.01.2021.
//

import UIKit
import CoreLocation


class weatherVC: UIViewController,  CLLocationManagerDelegate {
    
    var currentLocation = CLLocationCoordinate2D()
  
    var langChar = String()
    var metricSys = String()
    var gmtChar = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentLocation)
       
        //tarih çek
        let now = Date()
        print("\(TimeZone.current.abbreviation()!)")
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd"
        //moontimeLabel.text = "\(formatter.string(from: now))"
        //regional kısaltması
        langChar = Locale.current.identifier
        let langIndex = langChar.index(langChar.startIndex, offsetBy: 2)
        langChar = String(langChar[..<langIndex])    // "My
        //Metrik bilgisi
        if (Locale.current.usesMetricSystem == true) {
            metricSys = "imperial"
        }else {
            metricSys = "metric"
        }
        //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
        gmtChar = "\(TimeZone.current.abbreviation()!)"
   
        fetchMoon(lat: "\(currentLocation.latitude)", lon: "\(currentLocation.longitude)", date: "\(formatter.string(from: now))", locTime: String(gmtChar.suffix(2)))
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
