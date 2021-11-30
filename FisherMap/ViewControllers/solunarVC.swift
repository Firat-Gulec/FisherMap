//
//  solunarVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import CoreLocation


class solunarVC: UIViewController{
    
    var currentLocation = CLLocationCoordinate2D()

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var hourlyCView: UIView!
    @IBOutlet weak var weeklyCView: UIView!
    @IBOutlet weak var cloudsCView: UIView!
    @IBOutlet weak var SunsetCView: UIView!
    @IBOutlet weak var windCView: UIView!
    @IBOutlet weak var sunriseCView: UIView!
    @IBOutlet weak var eyeshotCView: UIView!
    @IBOutlet weak var humidityCView: UIView!
    @IBOutlet weak var wfLocationLabel: UILabel!
    @IBOutlet weak var wfTempLabel: UILabel!
    @IBOutlet weak var wfImageView: UIImageView!
    @IBOutlet weak var wftempHLLabel: UILabel!
    @IBOutlet weak var wfDescLabel: UILabel!
    
    var langChar = String()
    var metricSys = String()
    var gmtChar = String()
    
    func sendDataVCs() {
        let cloudsVC = children[2] as? CloudsVC
        cloudsVC?.cloudsLabel.text = clouds
        let sunsetVC = children[3] as? SunsetVC
        sunsetVC?.sunsetLabel.text = sunset
        let windVC = children[4]  as? WindVC
        windVC?.windLabel.text = windspeed + winddeg
        let sunriseVC = children[5] as? SunriseVC
        sunriseVC?.sunriseLabel.text = sunrise
        let eyeshotVC = children[6] as? EyeshotVC
        eyeshotVC?.eyeshotLabel.text = visibility
        eyeshotVC?.visib = visib
        let humidtyVC = children[7]  as? HumidtyVC
        humidtyVC?.humidtyLabel.text = hmd
        humidtyVC?.humidity = humidity
    }
    
    var hmd = String()
    var windspeed = String()
    var winddeg = String()
    var eyeshot = String()
    var sunrise = String()
    var sunset = String()
    var clouds = String()
    var visibility = String()
    //var list: [List] = []
    var temp: [String] = []
    var temp_max: [String] = []
    var temp_min = [String]()
    var feels_like = [String]()
    var humidity = [String]()
    var dt_txt: [String] = []
    var visib = [String]()
    var main: [String] = []
    var descrip: [String] = []
    var first = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentLocation)
       // list.removeAll()
         temp.removeAll()
         temp_max.removeAll()
         temp_min.removeAll()
         feels_like.removeAll()
         humidity.removeAll()
         dt_txt.removeAll()
         visib.removeAll()
         main.removeAll()
         descrip.removeAll()
         first = ["John", "Paul"]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "humidity" {
            let humidtyVC = segue.destination as? HumidtyVC
            humidtyVC?.humidtyLabel.text = hmd
        }
    }
    
    //Hava Durumu çek kardeş
    func fetchWeather(lat: String, lon: String, units: String, lang: String, apikey: String) {
        self.fetchWeatherForecast(lat: "\(currentLocation.latitude)", lon: "\(currentLocation.longitude)", units: metricSys, lang: langChar, apikey: "")
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(units)&lang=\(lang)&appid=9e934037e50bdf637b1d64f942b8e944")
      // Rize yağmur için..
      // guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=41.025753&lon=40.524624&units=\(units)&lang=\(lang)&appid=9e934037e50bdf637b1d64f942b8e944")
        else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
              return
            }
            do {
                let model = try JSONDecoder().decode(WeatherModel.self,
                                                     from: data)
                DispatchQueue.main.async {
                    self.wfLocationLabel.text = model.name
                    self.wfDescLabel.text = model.weather.first?.description ?? "TEST"
                    self.wfTempLabel.text = "\(Int(model.main.temp))°"
                    self.wftempHLLabel.text = "\(Int(model.main.temp))°   \(Int(model.main.feels_like))°"
                    if model.weather.first?.main == "Clear" {
                        self.backImageView.image = UIImage(named: "CLEAR-1")
                    } else if model.weather.first?.main == "Clouds" {
                        self.backImageView.image = UIImage(named: "CLOUDY")
                    } else if model.weather.first?.main == "Rain" {
                        self.backImageView.image = UIImage(named: "RAIN2")
                    } else if model.weather.first?.main == "Clouds" {
                        self.backImageView.image = UIImage(named: "CLOUDY")
                    } else if model.weather.first?.main == "Snow" {
                        self.backImageView.image = UIImage(named: "SNOW3")
                    }
                    self.wfImageView.image = UIImage(named: "\(model.weather.first?.main ?? "TEST").png")
                    self.hmd = "%\(model.main.humidity)"
                    self.windspeed = "\(model.wind.speed)km/sa"
                    self.winddeg = "\(model.wind.deg)°"
                    var calendar = Calendar.current
                    if let timeZone = TimeZone(identifier: self.langChar) {
                       calendar.timeZone = timeZone
                    }
                    let hour = calendar.component(.hour, from: model.sys.sunrise)
                    let minute = calendar.component(.minute, from: model.sys.sunrise)
                    self.sunrise = "\(hour):\(minute)"
                    let hourset = calendar.component(.hour, from: model.sys.sunset)
                    let minuteset = calendar.component(.minute, from: model.sys.sunset)
                    self.sunset = "\(hourset):\(minuteset)"
                    self.clouds = "%\(model.clouds.all)"
                    self.visibility = "%\(model.visibility)"
                    //Send to ConteinerViews Data
                    self.sendDataVCs()
                }
            }
            catch {
                print("failed..")
            }
        }
        task.resume()
    }

    //Hava Durumu çek kardeş
    func fetchWeatherForecast(lat: String, lon: String, units: String, lang: String, apikey: String) {
        guard let url = URL(string:  "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=\(units)&lang=\(lang)&appid=9e934037e50bdf637b1d64f942b8e944") else {
                   
        print("Invalid URL")
                   return
               }
        let task = URLSession.shared.dataTask(with: url) { fdata, response, error in
            guard let fdata = fdata, error == nil else {
              return
            }
            do {
                let decodedResponse = try? JSONDecoder().decode(WeatherForecast.self, from: fdata)
                           DispatchQueue.main.async {
                               for i in decodedResponse!.list {
                                        self.temp.append(String(i.main.temp))
                                        self.temp_max.append("\(i.main.temp_max)")
                                        self.temp_min.append("\(i.main.temp_min)")
                                        self.feels_like.append("\(i.main.feels_like)")
                                        self.humidity.append("\(i.main.humidity)")
                                        self.dt_txt.append("\(i.dt_txt)")
                                        self.visib.append("\(i.visibility)")
                                        print("Temp : \(i.main.temp)")
                                        print("Temp Max : \(i.main.temp_max)")
                                        print("Temp Min : \(i.main.temp_min)")
                                        print("Feels Like : \(i.main.feels_like)")
                                        print("Humidity : \(i.main.humidity)")
                                        print("Date : \(i.dt_txt)")
                                        print("Date : \(i.visibility)")
                                   for j in i.weather {
                                       self.main.append(j.main)
                                       self.descrip.append("\(j.description)")
                                           print("Main : \(j.main)")
                                           print("Description : \(j.description)")
                                           print("Icon : \(j.icon)")
                                       }
                                          /*  for j in i.clouds {
                                                print("Clouds : \(j.all)")
                                            }*/
                                                 /* for j in i.wind {
                                                    print("Wind_Speed : \(j.speed)")
                                                    print("Wind_Deg : \(j.deg)")
                                                  }*/
                                   }
                               let hourlyVC = self.children[0] as? HourlyVC
                               hourlyVC?.currentLocation = self.currentLocation
                               hourlyVC?.temp = self.temp
                               //hourlyVC?.temp_max = temp_max
                               //hourlyVC?.temp_min = temp_min
                               hourlyVC?.feels_like = self.feels_like
                               //hourlyVC?.humidity = humidity
                               hourlyVC?.dt_txt = self.dt_txt
                               //hourlyVC?.visib = visib
                               hourlyVC?.main = self.main
                               hourlyVC?.descrip = self.descrip
                               
                               let weeklyVC = self.children[1] as? WeeklyVC
                               weeklyVC?.currentLocation = self.currentLocation
                               weeklyVC?.temp = self.temp
                               weeklyVC?.feels_like = self.feels_like
                               weeklyVC?.dt_txt = self.dt_txt
                               weeklyVC?.main = self.main
                               weeklyVC?.descrip = self.descrip
                               weeklyVC?.humidity = self.humidity
                               weeklyVC?.temp_max = self.temp_max
                               weeklyVC?.temp_min = self.temp_min
                               
                           }
                       }
                       catch {
                           print("failed..")
                       }
                   }
                   task.resume()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        backImageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        backImageView.image = UIImage(named: "CLEAR-1")
        mainScrollView.frame = CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: view.frame.size.height - 20)
        mainScrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        wfLocationLabel.frame = CGRect(x: 20, y: 0, width: view.frame.size.width - 50, height: 35)
        wfImageView.frame = CGRect(x: 20, y: 35, width: view.frame.size.width - 60, height: 60)
        wfTempLabel.frame = CGRect(x: 20, y: 90, width: view.frame.size.width - 50, height: 60)
        wfDescLabel.frame = CGRect(x: 20, y: 130, width: view.frame.size.width - 50, height: 35)
        wftempHLLabel.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 50, height: 35)
        hourlyCView.frame = CGRect(x: 10, y: 200, width: view.frame.size.width - 30, height: 100)
        weeklyCView.frame = CGRect(x: 10, y: 315, width: view.frame.size.width - 30, height: 200)
        cloudsCView.frame = CGRect(x: 10, y: 530, width: (view.frame.size.width / 2) - 20, height: 120)
        SunsetCView.frame = CGRect(x: (view.frame.size.width / 2), y: 530, width: (view.frame.size.width / 2) - 20, height: 120)
        windCView.frame = CGRect(x: 10, y: 665, width: (view.frame.size.width / 2) - 20, height: 120)
        sunriseCView.frame = CGRect(x: (view.frame.size.width / 2), y: 665, width: (view.frame.size.width / 2) - 20, height: 120)
        eyeshotCView.frame = CGRect(x: 10, y: 800, width: (view.frame.size.width / 2) - 20, height: 120)
        humidityCView.frame = CGRect(x: (view.frame.size.width / 2), y: 800, width: (view.frame.size.width / 2) - 20, height: 120)
        hourlyCView.layer.shadowRadius = 10
        hourlyCView.layer.shadowOpacity = 0.3
        hourlyCView.layer.cornerRadius = 10
        hourlyCView.layer.masksToBounds = true
        weeklyCView.layer.shadowRadius = 10
        weeklyCView.layer.shadowOpacity = 0.3
        weeklyCView.layer.cornerRadius = 10
        weeklyCView.layer.masksToBounds = true
        cloudsCView.layer.shadowRadius = 10
        cloudsCView.layer.shadowOpacity = 0.3
        cloudsCView.layer.cornerRadius = 10
        cloudsCView.layer.masksToBounds = true
        SunsetCView.layer.shadowRadius = 10
        SunsetCView.layer.shadowOpacity = 0.3
        SunsetCView.layer.cornerRadius = 10
        SunsetCView.layer.masksToBounds = true
        windCView.layer.shadowRadius = 10
        windCView.layer.shadowOpacity = 0.3
        windCView.layer.cornerRadius = 10
        windCView.layer.masksToBounds = true
        sunriseCView.layer.shadowRadius = 10
        sunriseCView.layer.shadowOpacity = 0.3
        sunriseCView.layer.cornerRadius = 10
        sunriseCView.layer.masksToBounds = true
        eyeshotCView.layer.shadowRadius = 10
        eyeshotCView.layer.shadowOpacity = 0.3
        eyeshotCView.layer.cornerRadius = 10
        eyeshotCView.layer.masksToBounds = true
        humidityCView.layer.shadowRadius = 10
        humidityCView.layer.shadowOpacity = 0.3
        humidityCView.layer.cornerRadius = 10
        humidityCView.layer.masksToBounds = true
        
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
         if (Locale.current.usesMetricSystem == false) {
             metricSys = "imperial"
         }else {
             metricSys = "metric"
         }
         //burada çalışmak gerek son 2 yerine ilk 3 sonrası almak için! +11 sidney patlak
         gmtChar = "\(TimeZone.current.abbreviation()!)"
         
         //Data cek
         fetchWeather(lat: "\(currentLocation.latitude)", lon: "\(currentLocation.longitude)", units: metricSys, lang: langChar, apikey: "")
    }


}
