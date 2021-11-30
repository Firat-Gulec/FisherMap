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
        startAnimation()
    }
    
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseRise, color: .darkGray, padding: 0)
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
            for i in 0...13 {
                self.data.append(HourlyData(mainn: self.main[i], tempp: self.temp[i], descripp: self.descrip[i], date: self.dt_txt[i]))
            }
            
            self.view.addSubview(self.collectionView)
            self.collectionView.backgroundColor = .clear
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




