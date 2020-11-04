//
//  WeatherRunner.swift
//  Clima
//
//  Created by Mohammed Sadiq on 04/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherRunnerDelegate {
    func weatherRunner(_ weatherRunner: WeatherRunner, didFetchWeather weather: Weather)
    
    func weatherRunnerDidFail(_ weatherRunner: WeatherRunner)
}

struct WeatherRunner {
    private let baseUrl =
        "https://api.openweathermap.org/data/2.5/weather"
        + "?appid=\(openWeatherApiKey)"
        + "&units=metric"
    
    var delegate: WeatherRunnerDelegate?
    
    func weather(for city: String) {
        let weatherForCityUrl = "\(baseUrl)&q=\(city)"
        
        if let url = URL(string: weatherForCityUrl) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                (
                    data,
                    urlResponse,
                    error
                ) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data {
                    do {
                        let weather = try JSONDecoder().decode(
                            WeatherCoder.self,
                            from: data
                        ).toWeather
                        
                        delegate?.weatherRunner(
                            self,
                            didFetchWeather: weather
                        )
                    } catch {
                        print(error)
                        delegate?.weatherRunnerDidFail(self)
                    }
                }
            }
            
            task.resume()
        }
    }
}
