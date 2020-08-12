//
//  WeatherDescriptionCell.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/11/20.
//

import UIKit

class WeatherDescriptionCell: UITableViewCell {
    
    // MARK: - Class Properties
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var windSpeedTitle: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSelected = false
        descriptionTitle.text = ""
        windSpeedTitle.text = ""
    }
    
    // MARK: - Class Methods
    func configure(with indexPath: Int, currentWeather: CurrentWeather, dailyWeather: [DailyWeather], _ isCurrentWeather: Bool) {
        if !isCurrentWeather {
            descriptionTitle.text = "\(dailyWeather[indexPath].weather[0].description)"
            windSpeedTitle.text = "\(Int(dailyWeather[indexPath].windSpeed)) mph"
        }
    }
}
