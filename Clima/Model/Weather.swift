//
//  Weather.swift
//  Clima
//
//  Created by Mohammed Sadiq on 04/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

enum WeatherType: String {
    case thunderstorm
    case drizzling
    case rainy
    case snowy
    case foggy
    case clear
    case cloudy
    
    var rawValue: String {
        switch self {
        case .thunderstorm:
            return "Thunderstorm"
        case .drizzling:
            return "Drizzling"
        case .rainy:
            return "Rainy"
        case .snowy:
            return "Snowy"
        case .foggy:
            return "Foggy"
        case .clear:
            return "Clear"
        case .cloudy:
            return "Cloudy"
        }
    }
}

struct Weather {
    let city: String
    let status: String
    let temperatureInCelsius: Double
    let type: WeatherType
    
    var temperatureInFahrenheit: Double {
        ((temperatureInCelsius * 9.0) / 5.0) + 32.0
    }
}

struct WeatherCoder: Decodable {
    let name: String
    let weather: [WeatherDetailsCoder]
    let main: MainCoder
    
    
    var toWeather: Weather {
        Weather(
            city: name,
            status: weather[0].main,
            temperatureInCelsius: main.temp,
            type: weather[0].weatherType
        )
    }
}

struct WeatherDetailsCoder: Decodable {
    let id: Double
    let main: String
    
    var weatherType: WeatherType {
        switch id {
        case 200 ..< 300:
            return WeatherType.thunderstorm
        case 300 ..< 400:
            return WeatherType.drizzling
        case 500 ..< 600:
            return WeatherType.rainy
        case 600 ..< 700:
            return WeatherType.snowy
        case 700 ..< 800:
            return WeatherType.foggy
        case 800:
            return WeatherType.clear
        default:
            return WeatherType.cloudy
        }
    }
}

struct MainCoder: Decodable {
    let temp: Double
}
