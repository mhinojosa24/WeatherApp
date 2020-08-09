//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Maximo Hinojosa on 8/7/20.
//

import Foundation

struct Weather: Codable {
    var description: String
    var icon: String
}

struct Temperature: Codable {
    var day: Double
}

struct DailyWeather: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var temp: Temperature
    var windSpeed: Double
    var weather: [Weather]
}

class CurrentWeather: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var temp: Double
    var windSpeed: Double
    var weather: [Weather]
}

// NOTE: main weather response model
struct WeatherResponse: Codable {
    var current: CurrentWeather
    var daily: [DailyWeather]
}
