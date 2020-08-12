//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/9/20.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: WeatherHeaderView, section: Int)
}

class WeatherHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Class Properties
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    var section: Int = 0
    weak var delegate: HeaderViewDelegate?
    
    var iconType: String! {
        didSet {
            self.icon.loadImage(iconString: iconType)
        }
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
    
    // MARK: - Class Methods
    
    func configure(with section: Int, currentWeather: CurrentWeather, dailyWeather: [DailyWeather], _ isCurrentWeather: Bool ) {
        if isCurrentWeather {
            iconType = currentWeather.weather[0].icon
            dateLabel.text = currentWeather.dt.convertUnixToDate()
            tempLabel.text = "\(Int(currentWeather.temp))°"
        } else {
            iconType = dailyWeather[section].weather[0].icon
            dateLabel.text = dailyWeather[section].dt.convertUnixToDate()
            tempLabel.text = "\(Int(dailyWeather[section].temp.day))°"
        }
    }
}
