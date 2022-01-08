//
//  RoundButton.swift
//  Calculator
//
//  Created by 조세연 on 2022/01/08.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height/3
            }
        }
    }

}
