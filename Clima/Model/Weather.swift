//
//  Weather.swift
//  Clima
//
//  Created by Mohammed Sadiq on 04/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct Weather {
    let name: String
    let status: String
    let description: String
    let temperatureInCelsius: Double
    
    
    var temperatureInFahrenheit: Double {
        return ((temperatureInCelsius * 9.0) / 5.0) + 32.0
    }
}

struct WeatherCoder: Decodable {
    let name: String
    let weather: [WeatherDetailsCoder]
    let main: MainCoder
    
    
    var toWeather: Weather {
        return Weather(
            name: name,
            status: weather[0].main,
            description: weather.description,
            temperatureInCelsius: main.temp
        )
    }
}

struct WeatherDetailsCoder: Decodable {
    let id: Double
    let main: String
    let description: String
}

struct MainCoder: Decodable {
    let temp: Double
}
