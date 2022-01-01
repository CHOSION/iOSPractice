//
//  ViewController.swift
//  Alert
//
//  Created by 조세연 on 2022/01/01.
//

import UIKit

class ViewController: UIViewController {
    
    let imgOn = UIImage(named: "lamp-on.png")
    let imgOff = UIImage(named: "lamp-off.png")
    let imgRemove = UIImage(named: "lamp-remove.png")
    
    var isLampOn = true

    @IBOutlet var lampImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lampImg.image = imgOn
    }

    @IBAction func btnLampOn(_ sender: UIButton) {
        if(isLampOn==true) {
            let lampOnAlert = UIAlertController(title: "Warning", message: "Lamp is On.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            lampOnAlert.addAction(onAction)
            present(lampOnAlert, animated: true, completion: nil)
        }
        else {
            lampImg.image = imgOn
            isLampOn = true
        }
    }
    
    @IBAction func btnLampOff(_ sender: UIButton) {
    }
    
    @IBAction func btnLampRemove(_ sender: UIButton) {
    }
    
}

