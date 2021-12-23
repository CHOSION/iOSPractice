//
//  ViewController.swift
//  oNoFF
//
//  Created by 조세연 on 2021/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    var imgOn: UIImage!
    var imgOff: UIImage!

    @IBOutlet var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imgOn = UIImage(named: "on.jpg")
        imgOff = UIImage(named: "off.jpg")
        
        imgView.image = imgOn
    }

    @IBAction func switchImageOnOff(_ sender: UISwitch) {
        if sender.isOn{
            imgView.image = imgOn
        }
        else{
            imgView.image = imgOff
        }
    }
    
}

