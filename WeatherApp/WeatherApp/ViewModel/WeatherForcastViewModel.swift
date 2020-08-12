//
//  WeatherForcastViewModel.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/8/20.
//

import UIKit
import CoreLocation


enum LocationError {
    case denied
    case restricted
}

protocol LocationUpdateDelegate: class {
    func locationError(error: LocationError)
    func weatherDidUpdate(isUpdated: Bool)
    func currentCityDidUpdate(city: String)
}

protocol ViewModelItem {
    var rowCount: Int { get }
    var isCollapsable: Bool { get }
    var isCollapsed: Bool { get }
}

class WeatherForecastViewModel: NSObject {
    
    // MARK: - Class Properties
    private var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    weak var delegate: LocationUpdateDelegate?
    var currentWeather: CurrentWeather!
    var dailyWeather: [DailyWeather] = []
    var reloadSections: ((_ section: Int) -> Void)?
    var isWeatherDataLoaded: Bool = false
    
    /// NOTE: creating a default array of WeatherViewModelItems
    var headerItems: [WeatherViewModelItem] = [
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                WeatherViewModelItem(),
                                                ]
    
    // MARK: - Class Methods

    func startUpdatingLocation() {
        return locationManager.startUpdatingLocation()
    }
    
    
    /// NOTE:  This function fetches the weather forcast from OpenWeatherMap.orgt
    func fetchWeather(location: CLLocation, completion: @escaping () -> Void) {
        getCityName(location: userLocation)
        WeatherService.shared.fetchWeather(with: location.coordinate.latitude, long: location.coordinate.longitude) { (response) in
            print(response.current)
            self.currentWeather = response.current
            self.dailyWeather = response.daily
            self.locationManager.stopUpdatingLocation()
            self.delegate?.weatherDidUpdate(isUpdated: true)
            completion()
        }
    }
    
    /**
     NOTE: Method detects when location services is enabled
     */
    func checkLocationServices() {
        print("checking location service")
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            self.checkLocationAuthorization()
        } else {
            delegate?.locationError(error: .denied)
        }
    }
    
    /**
     NOTE: Method evaluates the authorization status for user location
    */
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("location authorized")
            self.locationManager.startUpdatingLocation()
        case .denied:
            delegate?.locationError(error: .denied)
        case .restricted:
            delegate?.locationError(error: .restricted)
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        @unknown default:
           fatalError()
        }
    }
    
    /**
     NOTE: This function returns a string representation of the user's current city
    **Parameters:**
        - location: CLLocation
     */
    private func getCityName(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
             
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            guard let city = placemarks?.first?.locality else { return }
            self.delegate?.currentCityDidUpdate(city: city)
        })
    }
}

// MARK: - CoreLocation Delegate Methods
extension WeatherForecastViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations.last! as CLLocation
        
        getCityName(location: userLocation)
        WeatherService.shared.fetchWeather(with: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude) { (response) in
            self.currentWeather = response.current
            self.dailyWeather = response.daily
            self.locationManager.stopUpdatingLocation()
            self.delegate?.weatherDidUpdate(isUpdated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

// MARK: - TableView Delegate Methods
extension WeatherForecastViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = headerItems[section]
        guard item.isCollapsable else {
            return item.rowCount
        }

        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureSectionCells(with: tableView, indexPath: indexPath)
    }
}

extension WeatherForecastViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureHeaderSection(with: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if headerItems[indexPath.section].isCollapsed { return 0 }
        return 55
    }
}

// MARK: - Header View Delegate Method
extension WeatherForecastViewModel: HeaderViewDelegate {
    func toggleSection(header: WeatherHeaderView, section: Int) {
        let item = headerItems[section]
        if item.isCollapsable {
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            
            //Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}


// MARK: - Header View Model Item
/**
 NOTE: This class handles header cell data
*/
class WeatherViewModelItem: ViewModelItem {
    var rowCount: Int {
        return 2
    }
    
    var isCollapsable: Bool {
        return true
    }
    
    var isCollapsed: Bool = true
}

