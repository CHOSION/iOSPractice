//
//  ViewController.swift
//  Calculator
//
//  Created by 조세연 on 2022/01/08.
//

import UIKit

// 열거형 선언
// 연산자가 열거형 값이 되도록 추가
enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown
}

class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    // 상태값을 가지는 프로퍼티s
    var displayNumber = "" // numberOutputLabel이 표시되는 프로퍼티 (숫자표시)
    var firstOperand = "" // 이전계산값을 저장하는 프로퍼티 (첫번째 피연산자)
    var secondOperand = "" // 새로 입력된 계산값을 저장하는 프로퍼티 (두번째 피연산자)
    var result = "" // 계산 결과값을 저장하는 프로퍼티
    var currentOperation: Operation = .unknown // 현재 계산기에 어떤 연산자가 입력되어있는지 알수 있도록 연산자의 값을 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // @IBAction func tapNumberButton(액션함수 설정)
    // 모든 숫자버튼들을 커넥트(드래그)
    @IBAction func tapNumberButton(_ sender: UIButton) {
        
        // 선택한 버튼의 타이틀 값(sender.title)을 가져오기 (숫자값으로 리턴됨)
        // 옵셔널 타입이라 guard문으로 옵셔널 바인딩
        guard let numberValue = sender.title(for: .normal) else { return }
        // 숫자는 9자리까지만 입력
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    // 초기화 버튼 -> 모든 프로퍼티를 초기값으로 초기화
    // 프로퍼티 부분 참고
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        // 숫자는 0으로 표시
        self.numberOutputLabel.text="0"
    }
    
    // 소수점 추가 버튼
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 9자리까지만 표시되는 조건
        // 1) 숫자가 8자리보다 작게 입력될 때 if문 실행
        // 2) 소수점의 중복은 없어야 하기 때문에 ![소수점포함] 조건 실행
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            // 1) self.displayNumber가 비어있는 경우(0인경우) -> 0.
            // 2) self.displayNumber가 비어있지 않은 경우 -> 뒤에 .
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            // 숫자(결과값) 표시
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        if(!self.displayNumber.isEmpty)
        {
            self.displayNumber.removeLast()
            self.numberOutputLabel.text = self.displayNumber
        }
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
    
    @IBAction func tapPercentButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation){
        if self.currentOperation != .unknown {
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            
            self.currentOperation = operation
        } else {
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
}

