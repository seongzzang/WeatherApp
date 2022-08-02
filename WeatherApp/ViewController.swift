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
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=e23c3cb4689ada9cddc4dfd4df0db717") else {return}
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ data, respoonse, error in
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
            let weatherInformaiton = try? decoder.decode(WeatherInformation.self, from: data)
            debugPrint(weatherInformaiton)
        }.resume()
    }
}

