//
//  RoundButton.swift
//  Calculator
//
//  Created by 조세연 on 2022/01/08.
//
// 버튼에 적용할 Custom Class
// 사용자가 원하는 속성들을 추가할 수 있다.

import UIKit

// @IBDesignable: 변경된 설정값을 스토리보드상에 실시간으로 확인
@IBDesignable
class RoundButton: UIButton {
    // isRound 프로퍼티 선언 (Bool 초기값은 false)
    // @IBInspectable: 스토리보드에서도 isRound 프로퍼티 설정값 변경 가능
    @IBInspectable var isRound: Bool = false {
        // 연산 프로퍼티
        didSet {
            // isRound가 true일 셩우
            if isRound {
                self.layer.cornerRadius = self.frame.height/3
            }
        }
    }

}
