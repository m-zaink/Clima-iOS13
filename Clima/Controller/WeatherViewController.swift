//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchIconButton: UIButton!
    @IBOutlet weak var weatherDescription: UILabel!
    
    private var hapticGenerator: UINotificationFeedbackGenerator!
    
    private var weatherRunner: WeatherRunner = WeatherRunner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideActivityIndicatorAndShowSearchIconButton()
        searchTextField.delegate = self
        weatherRunner.delegate = self
        hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator.prepare()
    }
    
    @IBAction func onSearchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    private func showActivityIndicatorAndHideSearchIconButton() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        searchIconButton.isHidden = true
    }
    
    private func hideActivityIndicatorAndShowSearchIconButton() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        searchIconButton.isHidden = false
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Capture searchTextField.text to fetch the weather for that city
        if let enteredCityName = searchTextField.text {
            showActivityIndicatorAndHideSearchIconButton()
            clearSearchTextFieldAndResetPlaceHolder()
            weatherRunner.fetchWeather(for: enteredCityName)
        }
    }
    
    func clearSearchTextFieldAndResetPlaceHolder() {
        searchTextField.text = ""
        searchTextField.placeholder = "Search"
    }
}

extension WeatherViewController: WeatherRunnerDelegate {
    func weatherRunner(_ weatherRunner: WeatherRunner, didFetchWeather weather: Weather) {
        DispatchQueue.main.async {
            self.hapticGenerator.notificationOccurred(.success)
            
            self.hideActivityIndicatorAndShowSearchIconButton()
            self.conditionImageView.image = self.icon(basedOn: weather.type)
            self.temperatureLabel.text = String(format: "%.1f", weather.temperatureInCelsius)
            self.cityLabel.text = weather.city
            self.weatherDescription.text = weather.type.rawValue
        }
    }
    
    func weatherRunnerDidFail(_ weatherRunner: WeatherRunner) {
        DispatchQueue.main.async {
            self.hapticGenerator.notificationOccurred(.error)
            
            self.hideActivityIndicatorAndShowSearchIconButton()
            self.searchTextField.placeholder = "Please enter a valid city name"
        }
    }
    
    private func icon(basedOn weatherType: WeatherType) -> UIImage {
        switch weatherType {
        case .clear:
            return UIImage.init(systemName: "sun.max")!
        case .cloudy:
            return UIImage.init(systemName: "cloud")!
        case .drizzling:
            return UIImage.init(systemName: "cloud.drizzle")!
        case .rainy:
            return UIImage.init(systemName: "cloud.rain")!
        case .snowy:
            return UIImage.init(systemName: "sun.snow")!
        case .thunderstorm:
            return UIImage.init(systemName: "cloud.bolt")!
        case .foggy:
            return UIImage.init(systemName: "cloud.fog")!
        }
    }
}
