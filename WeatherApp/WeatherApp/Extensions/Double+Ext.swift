//
//  Double+Ext.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/9/20.
//

import Foundation

extension Double {
    func convertUnixToDate() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEEE d, MMM"

        return dateFormatter.string(from: date)
    }
    
    func convertUnixToTime() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "h:mma"

        return dateFormatter.string(from: date)
    }
}
