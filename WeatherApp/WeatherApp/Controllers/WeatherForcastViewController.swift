//
//  ViewController.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/6/20.
//

import UIKit
import CRRefresh


class WeatherForecastViewController: UIViewController, LocationUpdateDelegate {

    // MARK: - Class Properties
    @IBOutlet weak var tableView: UITableView?
    let viewModel = WeatherForecastViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewModel.delegate = self
        viewModel.checkLocationServices()
        configureTableView()
        reloadSections()
        refreshWeatherData()
        
    }


    // MARK: - Class Methods

    func configureTableView() {
        tableView?.register(WeatherHeaderView.nib, forHeaderFooterViewReuseIdentifier: WeatherHeaderView.identifier)
        tableView?.register(WeatherTimeCell.nib, forCellReuseIdentifier: WeatherTimeCell.identifier)
        tableView?.register(WeatherDescriptionCell.nib, forCellReuseIdentifier: WeatherDescriptionCell.identifier)
        
        tableView?.delegate = viewModel
        tableView?.dataSource = viewModel
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = false
    }
    
    func reloadSections() {
        self.viewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
    }
    
    func refreshWeatherData() {
        tableView?.cr.addHeadRefresh(animator: NormalFooterAnimator(), handler: { [weak self] in
            self?.viewModel.startUpdatingLocation()
            guard let locaiton = self?.viewModel.userLocation else { return }
            self?.viewModel.fetchWeather(location: locaiton, completion: {
                print("** Refreshed **")
                self?.tableView?.reloadData()
                self?.tableView?.cr.endHeaderRefresh()
            })
        })
    }
    
    func locationError(error: LocationError) {
       print("ERROR: \(error)")
    }
    
    func currentCityDidUpdate(city: String) {
        DispatchQueue.main.async {
            self.title = city
        }
    }
    
    func weatherDidUpdate(isUpdated: Bool) {
        if isUpdated {
            DispatchQueue.main.async {
                self.viewModel.isWeatherDataLoaded = true
                self.tableView?.reloadData()
            }
        }
    }
}
