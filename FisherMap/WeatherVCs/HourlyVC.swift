//
//  HourlyVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 16.10.2021.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

struct HourlyData {
    var mainn: String
    var tempp:  String
    var descripp: String
    var date: String
}

class HourlyVC: UIViewController{

    var data: [HourlyData] = []
   
    
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
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    var currentLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
    
        temp.removeAll()
        temp_max.removeAll()
        temp_min.removeAll()
        feels_like.removeAll()
        humidity.removeAll()
        dt_txt.removeAll()
        visib.removeAll()
        main.removeAll()
        descrip.removeAll()
        first.removeAll()
        data.removeAll()
        startAnimation()
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
            loading.stopAnimating()
            self.data = [
                HourlyData(mainn: self.main[0], tempp: self.temp[0], descripp: self.descrip[0], date: self.dt_txt[0]),
                HourlyData(mainn: self.main[1], tempp: self.temp[1], descripp: self.descrip[1], date: self.dt_txt[1]),
                HourlyData(mainn: self.main[2], tempp: self.temp[2], descripp: self.descrip[2], date: self.dt_txt[2]),
                HourlyData(mainn: self.main[3], tempp: self.temp[3], descripp: self.descrip[3], date: self.dt_txt[3]),
                HourlyData(mainn: self.main[4], tempp: self.temp[4], descripp: self.descrip[4], date: self.dt_txt[4]),
                HourlyData(mainn: self.main[5], tempp: self.temp[5], descripp: self.descrip[5], date: self.dt_txt[5]),
                HourlyData(mainn: self.main[6], tempp: self.temp[6], descripp: self.descrip[6], date: self.dt_txt[6]),
                HourlyData(mainn: self.main[7], tempp: self.temp[7], descripp: self.descrip[7], date: self.dt_txt[7]),
                HourlyData(mainn: self.main[8], tempp: self.temp[8], descripp: self.descrip[8], date: self.dt_txt[8]),
                HourlyData(mainn: self.main[9], tempp: self.temp[9], descripp: self.descrip[9], date: self.dt_txt[9]),
                HourlyData(mainn: self.main[10], tempp: self.temp[10], descripp: self.descrip[10], date: self.dt_txt[10]),
               /* HourlyData(mainn: self.main[11], tempp: self.temp[11], descripp: self.descrip[11], date: self.dt_txt[11]),
                HourlyData(mainn: self.main[12], tempp: self.temp[12], descripp: self.descrip[12], date: self.dt_txt[12]),
                HourlyData(mainn: self.main[13], tempp: self.temp[13], descripp: self.descrip[13], date: self.dt_txt[13]),
                HourlyData(mainn: self.main[14], tempp: self.temp[14], descripp: self.descrip[14], date: self.dt_txt[14]),
                HourlyData(mainn: self.main[15], tempp: self.temp[15], descripp: self.descrip[15], date: self.dt_txt[15]),
                HourlyData(mainn: self.main[16], tempp: self.temp[16], descripp: self.descrip[16], date: self.dt_txt[16]),
                HourlyData(mainn: self.main[17], tempp: self.temp[17], descripp: self.descrip[17], date: self.dt_txt[17]),
                HourlyData(mainn: self.main[18], tempp: self.temp[18], descripp: self.descrip[18], date: self.dt_txt[18]),
                HourlyData(mainn: self.main[19], tempp: self.temp[19], descripp: self.descrip[19], date: self.dt_txt[19]),
                HourlyData(mainn: self.main[20], tempp: self.temp[20], descripp: self.descrip[20], date: self.dt_txt[20]),
                HourlyData(mainn: self.main[21], tempp: self.temp[21], descripp: self.descrip[21], date: self.dt_txt[21]),
                HourlyData(mainn: self.main[22], tempp: self.temp[22], descripp: self.descrip[22], date: self.dt_txt[22]),
                HourlyData(mainn: self.main[23], tempp: self.temp[23], descripp: self.descrip[23], date: self.dt_txt[23]),
                HourlyData(mainn: self.main[24], tempp: self.temp[24], descripp: self.descrip[24], date: self.dt_txt[24]), */
                  ]
            self.view.addSubview(self.collectionView)
            self.collectionView.backgroundColor = .white
            self.collectionView.delegate = self
            self.collectionView.dataSource = self

            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            
        }
    }
    
    
}




extension HourlyVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .blue
        cell.layer.cornerRadius = 12
        cell.data = self.data[indexPath.item]
        return cell
    }
}


class CustomCell: UICollectionViewCell {
    
    var data: HourlyData? {
        didSet {
            guard let data = data else {
                return
            }
            mainImageView.image = UIImage(named: data.mainn)
            descripLabel.text = data.descripp
            let hour = Array(data.date)
            hourLabel.text = String(hour[11..<16])
            tempLabel.text = data.tempp + "°C"
        }
    }
    
    let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //iv.backgroundColor = .darkGray
        return iv
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let descripLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
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
        
        addSubview(mainImageView)
        mainImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        mainImageView.layer.cornerRadius = 20 / 2
        mainImageView.layer.shadowRadius = 10
        //profileImageView.layer.opacity = 0.3
       // profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
     
        addSubview(descripLabel)
        descripLabel.anchor(top: mainImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 0)
        
        addSubview(tempLabel)
        tempLabel.anchor(top: mainImageView.topAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(hourLabel)
        hourLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 0)
        
        
   
    }
}




