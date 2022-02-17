//
//  ViewController.swift
//  LEDBoard
//
//  Created by 조세연 on 2022/02/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentsLabel.textColor = .yellow
    }

}
