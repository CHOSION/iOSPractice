//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 조세연 on 2022/02/16.
//

import UIKit

class SeguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        // Segue로 Present된 환경에서 Back 누를시 이전화면으로 돌아간다
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
