//
//  WeatherTableViewCell.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 2.02.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let identifier = "WeatherTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }

    func configure(with model: DailyWeatherEntry) {
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(model.temperatureLow))°"
        self.highTempLabel.text = "\(Int(model.temperatureHigh))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
        self.iconImageView.contentMode = .scaleAspectFit

        let icon = model.icon.lowercased()
        if icon.contains("clear") {
            self.iconImageView.image = UIImage(named: "clear")
        }
        else if icon.contains("rain") {
            self.iconImageView.image = UIImage(named: "rain")
        }
        else {
            // cloud icon
            self.iconImageView.image = UIImage(named: "clear")
        }

    }

    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
    
}
