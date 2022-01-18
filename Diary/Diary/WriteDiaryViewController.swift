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
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy - MM - dd(EEEEE)"
        formmater.locale = Locale(identifier: "ko-KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
    }
}
