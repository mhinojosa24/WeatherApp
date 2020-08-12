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
    fileprivate let viewModel = WeatherForecastViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewModel.delegate = self
        viewModel.checkLocationServices()
        configureTableView()
    }


    // MARK: - Class Methods

    func configureTableView() {
        self.viewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        tableView?.cr.addHeadRefresh(animator: NormalFooterAnimator(), handler: { [weak self] in
            self?.viewModel.startUpdatingLocation()
            self?.viewModel.fetchWeather(completion: {
                self?.tableView?.cr.endHeaderRefresh()
            })
        })
        tableView?.register(WeatherHeaderView.nib, forHeaderFooterViewReuseIdentifier: WeatherHeaderView.identifier)
        tableView?.register(WeatherTimeCell.nib, forCellReuseIdentifier: WeatherTimeCell.identifier)
        tableView?.register(WeatherDescriptionCell.nib, forCellReuseIdentifier: WeatherDescriptionCell.identifier)
        
        tableView?.delegate = viewModel
        tableView?.dataSource = viewModel
        tableView?.separatorStyle = .none
        tableView?.allowsSelection = false
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
