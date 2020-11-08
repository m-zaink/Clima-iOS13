//
//  WeatherRunner.swift
//  Clima
//
//  Created by Mohammed Sadiq on 04/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherRunnerDelegate {
    func weatherRunner(_ weatherRunner: WeatherRunner, didFetchWeather weather: Weather)
    
    func weatherRunner(_ weatherRunner: WeatherRunner, didFailWithError error: Error)
}


struct WeatherError: LocalizedError {
    let title: String
    let message: String?
}

struct LocationCoordinates {
    let latitude: Double
    let longitude: Double
}

struct WeatherRunner {
    private let baseUrl =
        "https://api.openweathermap.org/data/2.5/weather"
        + "?appid=\(openWeatherApiKey)"
        + "&units=metric"
    
    var delegate: WeatherRunnerDelegate?
    
    func fetchWeather(for city: String) {
        let weatherForCityUrl = "\(baseUrl)&q=\(city)".sanitisedURL
        
        fetchWeather(fromURL: weatherForCityUrl)
    }
    
    func fetchWeather(for coordinates: LocationCoordinates) {
        let weatherForLocationCoordinates = "\(baseUrl)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)".sanitisedURL
        
        fetchWeather(fromURL: weatherForLocationCoordinates)
    }
    
    func fetchWeather(fromURL url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                (
                    data,
                    urlResponse,
                    error
                ) in
                
                if let error = error {
                    print(error)
                    
                    delegate?.weatherRunner(
                        self,
                        didFailWithError: WeatherError(
                            title: "Something went wrong with our servers!",
                            message: "Please try again in sometime"
                        )
                    )
                    
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
                        
                        delegate?.weatherRunner(
                            self,
                            didFailWithError: WeatherError(
                                title: "There was an issue in fetching the data",
                                message: "Please come back after sometime"
                            )
                        )
                    }
                }
            }
            
            task.resume()
        } else {
            delegate?.weatherRunner(
                self,
                didFailWithError: WeatherError(
                    title: "Something went wrong from our side!",
                    message: "Please try again after sometime"
                )
            )
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
