//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/7/20.
//

import Foundation
import Alamofire


class WeatherService {
    
    // - MARK:  Class Properties
    static let shared = WeatherService()
    
    
    // - MARK: Class Functions
    
    /**
     This function fetches the weather forcast from OpenWeatherMap.org
     
    **Parameters:**
        - lat: latitude
        - long: longitude
     */
    func fetchWeather(with lat: Double, long: Double, completion: @escaping (WeatherResponse) -> Void) {
        
        guard let url = getURL(with: lat, long: long) else { return }
        
        AF.request(url).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
            } else {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let weatherData = try decoder.decode(WeatherResponse.self, from: response.data!)
                
                    completion(weatherData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    /**
     This funciton returns a url string.
     
    **Parameters:**
        - lat: latitude
        - long: longitude
     */
    private func getURL(with lat: Double, long: Double) -> String? {
        let apiKey: String = getApiKey()
    
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,hourly&appid=\(apiKey)") else { return nil }
        
        return url.absoluteString
    }
    
    
    /**
     This funciton returns clients api key
     */
    private func getApiKey() -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: "API_CLIENT_ID") as! String
        return value
    }
}

