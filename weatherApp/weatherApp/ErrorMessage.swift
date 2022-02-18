//
//  ErrorMessage.swift
//  weatherApp
//
//  Created by 조세연 on 2022/02/18.
// 에러 데이터 JSON 데이터를 매핑할 수 있는 구조체

import Foundation

struct ErrorMessage: Codable {
    let message: String
}
