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
        if isWeatherDataLoaded {
            headerView.delegate = self
            if section == 0 {
                headerView.section = section
                headerView.configure(with: section,
                                     currentWeather: currentWeather,
                                     dailyWeather: dailyWeather,
                                     true)
                return headerView
            } else {
                headerView.section = section
                headerView.configure(with: section,
                                     currentWeather: currentWeather,
                                     dailyWeather: dailyWeather,
                                     false)
                
                return headerView
            }
        }
        return headerView
    }
    
    func configureSectionCells(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if isWeatherDataLoaded {
            
            if indexPath.section == 0  {
                switch indexPath.row {
                case 0:
                    let weatherTimeCell = tableView.dequeueReusableCell(withIdentifier: WeatherTimeCell.identifier,
                                                                        for: indexPath) as! WeatherTimeCell
                    weatherTimeCell.configure(with: currentWeather, dailyWeather: dailyWeather, true)
                    return weatherTimeCell
                case 1:
                    let weatherDescriptionCell = tableView.dequeueReusableCell(withIdentifier: WeatherDescriptionCell.identifier,
                                                                               for: indexPath) as! WeatherDescriptionCell
                    weatherDescriptionCell.configure(with: indexPath.section, currentWeather: currentWeather, dailyWeather: dailyWeather, true)
                    return weatherDescriptionCell
                default:
                    return UITableViewCell()
                }
                
            } else {
                switch indexPath.row {
                case 0:
                    let weatherTimeCell = tableView.dequeueReusableCell(withIdentifier: WeatherTimeCell.identifier, for: indexPath) as! WeatherTimeCell
                    weatherTimeCell.configure(with: currentWeather, dailyWeather: dailyWeather, false)
                    return weatherTimeCell
                case 1:
                    let weatherDescriptionCell = tableView.dequeueReusableCell(withIdentifier: WeatherDescriptionCell.identifier, for: indexPath) as! WeatherDescriptionCell
                    weatherDescriptionCell.configure(with: indexPath.section, currentWeather: currentWeather, dailyWeather: dailyWeather, false)
                    return weatherDescriptionCell
                default:
                    return UITableViewCell()
                }
            }
        }
        
        return UITableViewCell()
    }
}

