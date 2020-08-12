//
//  LaunchScreenViewController.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/11/20.
//

import UIKit
import SwiftyGif

class LaunchScreenViewController: UIViewController {
    
    // MARK: - Class Properties
    @IBOutlet weak var logoGifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGif()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoGifImageView.startAnimatingGif()
    }
    
    // MARK: - Class Methods
    
    private func configureGif() {
        guard let image = try? UIImage(gifName: "weather.gif") else { return logoGifImageView.clear() }
        self.logoGifImageView.setGifImage(image, loopCount: 1)
        logoGifImageView.delegate = self
    }
}

// MARK: - SwiftyGif Delegate Methods
extension LaunchScreenViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoGifImageView.isHidden = true
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "weatherForecast") as! WeatherForecastViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
