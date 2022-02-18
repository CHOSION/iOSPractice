//
//  ErrorMessage.swift
//  weatherApp
//
//  Created by 조세연 on 2022/02/18.
// 에러 데이터 JSON 데이터를 매핑할 수 있는 구조체

import Foundation

// Codable
// 자신을 변환하거나 외부 표현으로 변환할 수 있는 타입
// Codable을 채택한 객체는 JSON으로 변환하거나 JSON 데이터를 객체로 반환할 수 있다.
struct ErrorMessage: Codable {
    let message: String
}
