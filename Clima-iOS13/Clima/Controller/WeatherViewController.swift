//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
 
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}
   
//MARK: - UITextField
  extension WeatherViewController: UITextFieldDelegate {
        
        @IBAction func searchPressed(_ sender: UIButton) {
            print(searchTextField.text!)
            searchTextField.endEditing(true)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print(searchTextField.text!)
            searchTextField.endEditing(true)
            return false
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != ""{
                return true
            } else{
                textField.placeholder = "Type city name"
                return false
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchTextField.text{
                weatherManager.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
        }
    }

//MARK: - WeatherManagerDelegate
extension WeatherViewController:  WeatherManagerDelegate  {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName 
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
 
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon) 
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//d8dee0945ab8fb2cdcf0c32f55a7d445
