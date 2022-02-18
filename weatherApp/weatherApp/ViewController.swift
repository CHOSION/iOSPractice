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
    
    @IBOutlet weak var weatherStackView: UIStackView!
    
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
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    // 경고 팝업
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=8515bd1f6c4b16e5ed47250ce2e60fd0") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in // 클로져 매개변수_data, response, error, [weak self] -> 순환참조 해결
            // Success Status Code Range
            let successRange = (200..<300)
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            // statusCode가 SuccessRange 범위 안인 경우
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // 서버에서 응답받은 JSON 데이터를 weatherInformation 객체로 변환
                // (JSON 데이터가 Decoding 되는 라인에) guard 문 설정으로 옵셔널 바인딩
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                
                // 네트워크 작업은 별도의 실드에서 진행하며, 응답이 온다해도 자동으로 메인 스레드로 돌아오지 않는다
                // 컴플리젼핸들러 클로져에서 유아이 작업을 한다면 메인 스레드에서 작업
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                // 에러 상황
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                // 서버에서 응답받은 에러메세지가 Alert에 표시되도록 구현
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume() // 작업 실행
    }
}

// 에러 데이터 제이슨 데이터를 매핑할 수 있는 구조체
