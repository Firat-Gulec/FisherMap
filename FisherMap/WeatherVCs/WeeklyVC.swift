//
//  WeeklyVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

struct WeeklyData {
    var mainn: String
    var tempp:  String
    var temp_maxx: String
    var temp_minn: String
    var humidityy: String
    var descripp: String
    var date: String
}


class WeeklyVC: UIViewController {

    var data: [WeeklyData] = []
    var currentLocation = CLLocationCoordinate2D()
    
    var list: [List] = []
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
    
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(WeeklyCustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseRise, color: .white, padding: 0)
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
            //self.mainLabel.text = self.descrip[1] - degisikliks
            loading.stopAnimating()
            
            self.data = [
                WeeklyData(mainn: self.main[0], tempp: self.temp[0], temp_maxx: self.temp_max[0], temp_minn: self.temp_min[0], humidityy: self.humidity[0], descripp: self.descrip[0], date: self.dt_txt[0]),
                WeeklyData(mainn: self.main[1], tempp: self.temp[1], temp_maxx: self.temp_max[1], temp_minn: self.temp_min[1], humidityy: self.humidity[1], descripp: self.descrip[1], date: self.dt_txt[1]),
                WeeklyData(mainn: self.main[2], tempp: self.temp[2], temp_maxx: self.temp_max[2], temp_minn: self.temp_min[2], humidityy: self.humidity[2], descripp: self.descrip[2], date: self.dt_txt[2]),
                WeeklyData(mainn: self.main[3], tempp: self.temp[3], temp_maxx: self.temp_max[3], temp_minn: self.temp_min[3], humidityy: self.humidity[3], descripp: self.descrip[3], date: self.dt_txt[3]),
                WeeklyData(mainn: self.main[4], tempp: self.temp[4], temp_maxx: self.temp_max[4], temp_minn: self.temp_min[4], humidityy: self.humidity[4], descripp: self.descrip[4], date: self.dt_txt[4]),
                WeeklyData(mainn: self.main[5], tempp: self.temp[5], temp_maxx: self.temp_max[5], temp_minn: self.temp_min[5], humidityy: self.humidity[5], descripp: self.descrip[5], date: self.dt_txt[5]),
                WeeklyData(mainn: self.main[6], tempp: self.temp[6], temp_maxx: self.temp_max[6], temp_minn: self.temp_min[6], humidityy: self.humidity[6], descripp: self.descrip[6], date: self.dt_txt[6]),
                WeeklyData(mainn: self.main[7], tempp: self.temp[7], temp_maxx: self.temp_max[7], temp_minn: self.temp_min[7], humidityy: self.humidity[7], descripp: self.descrip[7], date: self.dt_txt[7]),
                WeeklyData(mainn: self.main[8], tempp: self.temp[8], temp_maxx: self.temp_max[8], temp_minn: self.temp_min[8], humidityy: self.humidity[8], descripp: self.descrip[8], date: self.dt_txt[8]),
                WeeklyData(mainn: self.main[9], tempp: self.temp[9], temp_maxx: self.temp_max[9], temp_minn: self.temp_min[9], humidityy: self.humidity[9], descripp: self.descrip[9], date: self.dt_txt[9]),
                WeeklyData(mainn: self.main[10], tempp: self.temp[10], temp_maxx: self.temp_max[10], temp_minn: self.temp_min[10], humidityy: self.humidity[10], descripp: self.descrip[10], date: self.dt_txt[10]),
                WeeklyData(mainn: self.main[11], tempp: self.temp[11], temp_maxx: self.temp_max[11], temp_minn: self.temp_min[11], humidityy: self.humidity[11], descripp: self.descrip[11], date: self.dt_txt[11]),
                WeeklyData(mainn: self.main[12], tempp: self.temp[12], temp_maxx: self.temp_max[12], temp_minn: self.temp_min[12], humidityy: self.humidity[12], descripp: self.descrip[12], date: self.dt_txt[12]),
                WeeklyData(mainn: self.main[13], tempp: self.temp[13], temp_maxx: self.temp_max[13], temp_minn: self.temp_min[13], humidityy: self.humidity[13], descripp: self.descrip[13], date: self.dt_txt[13]),
                WeeklyData(mainn: self.main[14], tempp: self.temp[14], temp_maxx: self.temp_max[14], temp_minn: self.temp_min[14], humidityy: self.humidity[14], descripp: self.descrip[14], date: self.dt_txt[14]),
                WeeklyData(mainn: self.main[15], tempp: self.temp[15], temp_maxx: self.temp_max[15], temp_minn: self.temp_min[15], humidityy: self.humidity[15], descripp: self.descrip[15], date: self.dt_txt[15]),
                WeeklyData(mainn: self.main[16], tempp: self.temp[16], temp_maxx: self.temp_max[16], temp_minn: self.temp_min[16], humidityy: self.humidity[16], descripp: self.descrip[16], date: self.dt_txt[16]),
                WeeklyData(mainn: self.main[17], tempp: self.temp[17], temp_maxx: self.temp_max[17], temp_minn: self.temp_min[17], humidityy: self.humidity[17], descripp: self.descrip[17], date: self.dt_txt[17]),
                WeeklyData(mainn: self.main[18], tempp: self.temp[18], temp_maxx: self.temp_max[18], temp_minn: self.temp_min[18], humidityy: self.humidity[18], descripp: self.descrip[18], date: self.dt_txt[18]),
                WeeklyData(mainn: self.main[19], tempp: self.temp[19], temp_maxx: self.temp_max[19], temp_minn: self.temp_min[19], humidityy: self.humidity[19], descripp: self.descrip[19], date: self.dt_txt[19]),
                WeeklyData(mainn: self.main[20], tempp: self.temp[20], temp_maxx: self.temp_max[20], temp_minn: self.temp_min[20], humidityy: self.humidity[20], descripp: self.descrip[20], date: self.dt_txt[20]),
                WeeklyData(mainn: self.main[21], tempp: self.temp[21], temp_maxx: self.temp_max[21], temp_minn: self.temp_min[21], humidityy: self.humidity[21], descripp: self.descrip[21], date: self.dt_txt[21]),
                WeeklyData(mainn: self.main[22], tempp: self.temp[22], temp_maxx: self.temp_max[22], temp_minn: self.temp_min[22], humidityy: self.humidity[22], descripp: self.descrip[22], date: self.dt_txt[22]),
                WeeklyData(mainn: self.main[23], tempp: self.temp[23], temp_maxx: self.temp_max[23], temp_minn: self.temp_min[23], humidityy: self.humidity[23], descripp: self.descrip[23], date: self.dt_txt[23]),
                WeeklyData(mainn: self.main[24], tempp: self.temp[24], temp_maxx: self.temp_max[24], temp_minn: self.temp_min[24], humidityy: self.humidity[24], descripp: self.descrip[24], date: self.dt_txt[24]),
                WeeklyData(mainn: self.main[25], tempp: self.temp[25], temp_maxx: self.temp_max[25], temp_minn: self.temp_min[25], humidityy: self.humidity[25], descripp: self.descrip[25], date: self.dt_txt[25]),
                WeeklyData(mainn: self.main[26], tempp: self.temp[26], temp_maxx: self.temp_max[26], temp_minn: self.temp_min[26], humidityy: self.humidity[26], descripp: self.descrip[26], date: self.dt_txt[26]),
                WeeklyData(mainn: self.main[27], tempp: self.temp[27], temp_maxx: self.temp_max[27], temp_minn: self.temp_min[27], humidityy: self.humidity[27], descripp: self.descrip[27], date: self.dt_txt[27]),
                WeeklyData(mainn: self.main[28], tempp: self.temp[28], temp_maxx: self.temp_max[28], temp_minn: self.temp_min[28], humidityy: self.humidity[28], descripp: self.descrip[28], date: self.dt_txt[28]),
                WeeklyData(mainn: self.main[29], tempp: self.temp[29], temp_maxx: self.temp_max[29], temp_minn: self.temp_min[29], humidityy: self.humidity[29], descripp: self.descrip[29], date: self.dt_txt[29]),
                WeeklyData(mainn: self.main[30], tempp: self.temp[30], temp_maxx: self.temp_max[30], temp_minn: self.temp_min[30], humidityy: self.humidity[30], descripp: self.descrip[30], date: self.dt_txt[30]),
                WeeklyData(mainn: self.main[31], tempp: self.temp[31], temp_maxx: self.temp_max[31], temp_minn: self.temp_min[31], humidityy: self.humidity[31], descripp: self.descrip[31], date: self.dt_txt[31]),
                WeeklyData(mainn: self.main[32], tempp: self.temp[32], temp_maxx: self.temp_max[32], temp_minn: self.temp_min[32], humidityy: self.humidity[32], descripp: self.descrip[32], date: self.dt_txt[32]),
                WeeklyData(mainn: self.main[33], tempp: self.temp[33], temp_maxx: self.temp_max[33], temp_minn: self.temp_min[33], humidityy: self.humidity[33], descripp: self.descrip[33], date: self.dt_txt[33]),
                WeeklyData(mainn: self.main[34], tempp: self.temp[34], temp_maxx: self.temp_max[34], temp_minn: self.temp_min[34], humidityy: self.humidity[34], descripp: self.descrip[34], date: self.dt_txt[34]),
                WeeklyData(mainn: self.main[35], tempp: self.temp[35], temp_maxx: self.temp_max[35], temp_minn: self.temp_min[35], humidityy: self.humidity[35], descripp: self.descrip[35], date: self.dt_txt[35]),
                WeeklyData(mainn: self.main[36], tempp: self.temp[36], temp_maxx: self.temp_max[36], temp_minn: self.temp_min[36], humidityy: self.humidity[36], descripp: self.descrip[36], date: self.dt_txt[36]),
                WeeklyData(mainn: self.main[37], tempp: self.temp[37], temp_maxx: self.temp_max[37], temp_minn: self.temp_min[37], humidityy: self.humidity[37], descripp: self.descrip[37], date: self.dt_txt[37]),
                WeeklyData(mainn: self.main[38], tempp: self.temp[38], temp_maxx: self.temp_max[38], temp_minn: self.temp_min[38], humidityy: self.humidity[38], descripp: self.descrip[38], date: self.dt_txt[38]),
                WeeklyData(mainn: self.main[39], tempp: self.temp[39], temp_maxx: self.temp_max[39], temp_minn: self.temp_min[39], humidityy: self.humidity[39], descripp: self.descrip[39], date: self.dt_txt[39]),
                
            ]
            
            self.view.addSubview(self.collectionView)
            self.collectionView.backgroundColor = .white
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        }
    }

}



extension WeeklyVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 6)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeeklyCustomCell
        cell.backgroundColor = .blue
        cell.layer.cornerRadius = 12
        cell.data = self.data[indexPath.item]
        return cell
    }
}


class WeeklyCustomCell: UICollectionViewCell {
    
    var data: WeeklyData? {
        didSet {
            guard let data = data else {
                return
            }
            let hour = Array(data.date)
            dateLabel.text = String(hour[8..<10])
            hourLabel.text = String(hour[11..<16])
            mainImageView.image = UIImage(named: data.mainn)
            
            let tempy = Array(data.tempp)
            tempLabel.text = String(tempy[0..<2]) + "°C"
            descripLabel.text = data.mainn
            tmaxImageView.image = UIImage(named: "sunset")
            let tempymax = Array(data.temp_maxx)
            tmaxLabel.text = String(tempymax[0..<2])
            tminImageView.image = UIImage(named: "sunrise")
            let tempymin = Array(data.temp_minn)
            tminLabel.text = String(tempymin[0..<2])
            hmdImageView.image = UIImage(named: "humidity")
            let humid = Array(data.humidityy)
            humidityLabel.text = String(humid[0..<2])
            
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    let mainImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //iv.backgroundColor = .darkGray
            return iv
        }()
    
    let descripLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .darkGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let hmdImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //iv.backgroundColor = .darkGray
            return iv
        }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let tmaxImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //iv.backgroundColor = .darkGray
            return iv
        }()
    
    let tmaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    let tminImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //iv.backgroundColor = .darkGray
            return iv
        }()
    
    let tminLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .darkGray
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions

    func configureUI() {
        
        addSubview(dateLabel)
        dateLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 20, height: 25)
        
        
        addSubview(hourLabel)
        hourLabel.anchor(top: topAnchor, left: dateLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 40, height: 25)
        
        
        addSubview(mainImageView)
        mainImageView.anchor(top: topAnchor, left: hourLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        mainImageView.layer.cornerRadius = 20 / 2
        mainImageView.layer.shadowRadius = 10
        //profileImageView.layer.opacity = 0.3
       // profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
        addSubview(tempLabel)
        tempLabel.anchor(top: topAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 40, height: 25)
        
        addSubview(descripLabel)
        descripLabel.anchor(top: topAnchor, left: tempLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 75, height: 25)
        //
        
        addSubview(tmaxImageView)
        tmaxImageView.anchor(top: topAnchor, left: descripLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        tmaxImageView.layer.cornerRadius = 20 / 2
        tmaxImageView.layer.shadowRadius = 10
        //profileImageView.layer.opacity = 0.3
       // profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
        addSubview(tmaxLabel)
        tmaxLabel.anchor(top: topAnchor, left: tmaxImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 20, height: 25)
        
        addSubview(tminImageView)
        tminImageView.anchor(top: topAnchor, left: tmaxLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        tminImageView.layer.cornerRadius = 20 / 2
        tminImageView.layer.shadowRadius = 10
        //profileImageView.layer.opacity = 0.3
       // profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
        addSubview(tminLabel)
        tminLabel.anchor(top: topAnchor, left: tminImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 20, height: 25)
        
        addSubview(hmdImageView)
        hmdImageView.anchor(top: topAnchor, left: tminLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        hmdImageView.layer.cornerRadius = 20 / 2
        hmdImageView.layer.shadowRadius = 10
        //profileImageView.layer.opacity = 0.3
       // profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
        addSubview(humidityLabel)
        humidityLabel.anchor(top: topAnchor, left: hmdImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
   
    }
}





