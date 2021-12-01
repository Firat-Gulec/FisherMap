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
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: .darkGray, padding: 0)
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
            for i in 0...39 {
                self.data.append(WeeklyData(mainn: self.main[i], tempp: self.temp[i], temp_maxx: self.temp_max[i], temp_minn: self.temp_min[i], humidityy: self.humidity[i], descripp: self.descrip[i], date: self.dt_txt[i]))
                
            }
            
            self.view.addSubview(self.collectionView)
            self.collectionView.backgroundColor = .clear
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





