//
//  WeatherInformation.swift
//  weatherApp
//
//  Created by 조세연 on 2022/02/17.
//

import Foundation

// Codable
// 자신을 변환하거나 외부 표현으로 변환할 수 있는 타입
// Codable을 채택한 객체는 JSON으로 변환하거나 JSON 데이터를 객체로 반환할 수 있다.

struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

