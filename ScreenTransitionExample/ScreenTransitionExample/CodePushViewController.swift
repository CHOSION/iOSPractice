//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 조세연 on 2022/02/17.
//

import UIKit

class CodePushViewController: UIViewController {

    // 데이터 전달하기
    // 변수 지정
    @IBOutlet weak var nameLabel: UILabel!
    // name이라는 String Property 추가
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            nameLabel.sizeToFit()
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
