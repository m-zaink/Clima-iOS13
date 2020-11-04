//
//  WeatherRunner.swift
//  Clima
//
//  Created by Mohammed Sadiq on 04/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherRunner {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(openWeatherApiKey)"
    
    func weather(for city: String) {
        let weatherForCityUrl = "\(baseUrl)&q=\(city)"
        
        if let url = URL(string: weatherForCityUrl) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data, let stringifiedData = String(data: data, encoding: .utf8) {
                    print(stringifiedData)
                }
            }
            
            task.resume()
        }
    }
}
