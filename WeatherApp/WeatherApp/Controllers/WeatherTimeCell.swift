//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/11/20.
//

import UIKit

class WeatherTimeCell: UITableViewCell {
    
    // MARK: - Class Properties
    @IBOutlet weak var sunriseTimeTitle: UILabel!
    @IBOutlet weak var sunsetTimeTitle: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSelected = false
        sunriseTimeTitle.text = ""
        sunsetTimeTitle.text = ""
    }
    
    // MARK: - Class Methods
    func configure(with indexPath: Int, currentWeather: CurrentWeather, dailyWeather: [DailyWeather], _ isCurrentWeather: Bool ) {
        if isCurrentWeather {
            sunriseTimeTitle.text = currentWeather.sunrise.convertUnixToTime()
            sunsetTimeTitle.text = currentWeather.sunset.convertUnixToTime()
        } else {
            sunriseTimeTitle.text = dailyWeather[indexPath].sunrise.convertUnixToTime()
            sunsetTimeTitle.text = dailyWeather[indexPath].sunset.convertUnixToTime()
        }
    }
}
