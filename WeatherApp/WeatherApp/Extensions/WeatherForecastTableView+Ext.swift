//
//  WeatherForecastTableView+Ext.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/12/20.
//

import UIKit

// MARK: - Helper Methods
extension WeatherForecastViewModel {
    func configureHeaderSection(with tableView: UITableView, section: Int) -> UIView {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherHeaderView.identifier) as! WeatherHeaderView
        guard isWeatherDataLoaded else { return headerView }
        
        headerView.delegate = self
        if section == 0 {
            headerView.section = section
            headerView.configure(with: section, currentWeather: currentWeather, dailyWeather: dailyWeather, true)
            return headerView
        } else {
            headerView.section = section
            headerView.configure(with: section, currentWeather: currentWeather, dailyWeather: dailyWeather, false)
            return headerView
        }
    }
    
    func configureSectionCells(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard isWeatherDataLoaded else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            let weatherTimeCell = tableView.dequeueReusableCell(withIdentifier: WeatherTimeCell.identifier, for: indexPath) as! WeatherTimeCell
            weatherTimeCell.configure(with: indexPath.section, currentWeather: currentWeather, dailyWeather: dailyWeather, indexPath.section == 0 ? true : false)
            return weatherTimeCell
        case 1:
            let weatherDescriptionCell = tableView.dequeueReusableCell(withIdentifier: WeatherDescriptionCell.identifier, for: indexPath) as! WeatherDescriptionCell
            weatherDescriptionCell.configure(with: indexPath.section, currentWeather: currentWeather, dailyWeather: dailyWeather, indexPath.section == 0 ? true : false)
            return weatherDescriptionCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
}
