//
//  ViewController.swift
//  WeatherApp
//
//  Created by 양성혜 on 2022/08/02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weatherStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configureView(weatherInformation: WeatherInformation){
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
            self.setImageView(weatherInfo: weather.description)
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저 : \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고 : \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=e23c3cb4689ada9cddc4dfd4df0db717") else {return}
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                guard let weatherInformaiton = try? decoder.decode(WeatherInformation.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformaiton)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
           
        }.resume()
    }
    
    func setImageView(weatherInfo: String){
        if weatherInfo.contains("cloud"){
            self.imageView.image = #imageLiteral(resourceName: "cloud")
        } else if weatherInfo.contains("sun"){
            self.imageView.image = #imageLiteral(resourceName: "sunny")
        }else if weatherInfo.contains("rain"){
            self.imageView.image = #imageLiteral(resourceName: "rainy")
        }else if weatherInfo.contains("snow"){
            self.imageView.image = #imageLiteral(resourceName: "snow")
        } else {
            self.imageView.image = #imageLiteral(resourceName: "rainbow")
        }
    }
}

