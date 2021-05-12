//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Ujin Artuhovich on 5/7/21.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var nightTLabel: UILabel!
    @IBOutlet weak var dayTLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    var data: Datum? = nil {
        didSet {
            guard let data = data else {return}
            nightTLabel.text = String(Int(data.temperatureMin))
            dayTLabel.text = String(Int(data.temperatureMax))
            weatherImage.image = UIImage(systemName: WeatherIcon.shared.getIcon(type: data.icon.rawValue))
            humidityLabel.text = "\(Int(data.humidity*100))%"
            dayLabel.text = Formatter.shared.getDayForDate(Date(timeIntervalSince1970: Double(data.time)), format: "EEEE")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.myBlue
    }
    static let identifier = "DailyWeatherTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "DailyWeatherTableViewCell",
                     bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
}
