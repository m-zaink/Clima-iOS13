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
    
    var weatherRunner: WeatherRunner = WeatherRunner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTextField.delegate = self
    }

    @IBAction func onSearchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
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
            print("Entered City Name : \(enteredCityName)")
            weatherRunner.weather(for: enteredCityName)
            searchTextField.text = ""
            searchTextField.placeholder = "Search"
        }
    }
}
