//
//  ViewController.swift
//  weatherApp
//
//  Created by 조세연 on 2022/02/17.
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
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            // CurrentAPI 호출
            self.getCurrentWeather(cityName: cityName)
            // 버튼이 눌리면 키보드가 사라진다.
            self.view.endEditing(true)
        }
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=8515bd1f6c4b16e5ed47250ce2e60fd0") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in // 클로져 매개변수_data, response, error
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            // 서버에서 응답받은 JSON 데이터를 weatherInformation 객체로 변환
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data)
            debugPrint(weatherInformation)
        }.resume() // 작업 실행
    }
}

