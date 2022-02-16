//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 조세연 on 2022/02/16.
//

import UIKit

class SeguePushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        // 버튼을 누르면 이전 화면으로 이동 (3->2, 2->1)
        self.navigationController?.popViewController(animated: true)
        // 네비게이션 스택에 여러 화면이 쌓여있는 경우, 버튼을 누를때 이전 화면이 아닌 네비게이션 스택의 첫번째 화면인 Root View Controller 로 이동하는 경우
        // self.navigationController?.popToRootViewController(animated: true)
    }
}
