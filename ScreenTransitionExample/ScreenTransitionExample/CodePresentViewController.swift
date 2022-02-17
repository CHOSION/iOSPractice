//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 조세연 on 2022/02/17.
//

import UIKit

// 이전화면으로 데이터전달_프로토콜 정의
protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    // delegate의 경우 강한순환참조로 인해 메모리 누수가 발생한다 -> weak 필수
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            nameLabel.sizeToFit()
        }
    }

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "ManCity")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
