//
//  ViewController.swift
//  Calculator
//
//  Created by 조세연 on 2022/01/08.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown
}

class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = "" // numberOutputLabel이 표시되는 프로퍼티
    var firstOperand = "" // 이전계산값을 저장하는 프로퍼티
    var secondOperand = "" // 새로 입력된 계산값을 저장하는 프로퍼티
    var result = "" // 계산 결과값을 저장하는 프로퍼티
    var currentOperation: Operation = .unknown // 현재 계산기에 어떤 연산자가 입력되어있는지 알수 있도록 연산자의 값을 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text="0"
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
    }
    
    @IBAction func tapChangeSignButton(_ sender: UIButton) {
    }
    
    @IBAction func tapPlusButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tapMinusButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tapMultipleButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tapPercentButton(_ sender: Any) {
    }
    
    @IBAction func tapEqualButton(_ sender: Any) {
    }
    
    func operation(_ operation: Operation){
        
    }
}

