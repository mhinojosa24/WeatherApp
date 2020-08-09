//
//  ViewController.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/6/20.
//

import UIKit
import CoreLocation

class WeatherForcastViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    checkLocationServices()
        
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            self.checkLocationAuthorization()
        } else {
//            self.delegate.locationError(error: .denied)
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .denied:
           // show alert instructing the how to turn on permissions
            print("error")
//            self.delegate.locationError(error: .denied)
        case .restricted:
            print("error")
//            self.delegate.locationError(error: .restricted)
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        @unknown default:
           fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        WeatherService.shared.fetchWeather(with: location.coordinate.latitude, long: location.coordinate.longitude) { (response) in
            print(response)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

