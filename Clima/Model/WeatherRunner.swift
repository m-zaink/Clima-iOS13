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
    
    func fetchWeather(for city: String) {
        let weatherForCityUrl = "\(baseUrl)&q=\(city)".sanitisedURL
        
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
                    delegate?.weatherRunnerDidFail(self)
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
        } else {
            delegate?.weatherRunnerDidFail(self)
        }
    }
}

extension String {
    /// Replace spaces in an URL string with "%20" to adhere to web formats
    var sanitisedURL: String {
        condensed.replacingOccurrences(
            of: " ",
            with: "%20"
        )
    }
    
    /// Returns a condensed string, with no extra whitespaces and no new lines.
    var condensed: String {
        replacingOccurrences(
            of: "[\\s\n]+",
            with: " ",
            options: .regularExpression,
            range: nil
        )
    }

    /// Returns a condensed string, with no whitespaces at all and no new lines.
    var extraCondensed: String {
        replacingOccurrences(
            of: "[\\s\n]+",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }

}
