//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 조세연 on 2022/01/18.
//

import UIKit

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
}
