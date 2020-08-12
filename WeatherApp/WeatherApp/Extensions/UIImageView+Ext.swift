//
//  UIImageView+Ext.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/10/20.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(iconString: String?) {
        guard
            let iconeType = iconString,
            let url = URL(string: "http://openweathermap.org/img/wn/\(iconeType)@2x.png")
            else { return }
        
        self.image = nil
        
        /// NOTE: Check if the image exist in the cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        /// NOTE: Fetch icon image
        WeatherService.shared.fetchImage(with: url) { (data) in
            guard let data = data else { return }
            let imageToCache = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = imageToCache
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
            }
        }
    }
}
