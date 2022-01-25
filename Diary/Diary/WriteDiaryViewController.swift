//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 조세연 on 2022/01/22.
//

import UIKit

// 열거형 정의
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

// Delegate 정의 -> Delegate를 통해 일기장 리스트 화면에 일기가 작성된 다이어리 객체 전달
// Protocol 정의
protocol WriteDiaryViewDelegate: AnyObject {
    // 메서드 정의_파라미터에 Diary 객체 전달
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    // dateTextField에 datePicker 기능 적용_1
    private let datePicker = UIDatePicker()
    // Date를 저장하는 property
    private var diaryDate: Date?
    // WriteDiaryViewDelegate property 정의
    weak var delegate: WriteDiaryViewDelegate?
    //
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Contents에 border 설정_2
        self.configureContentsTextView()
        // dateTextField에 datePicker 기능 적용_3
        self.configureDatePicker()
        // 일기 내용 작성시 등록버튼 활성화되는 메서드_2
        self.configureInputField()
        // 초기 일기작성 화면은 아무것도 작성되지 않은 공란 상태 (등록버튼비활성화)
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "Edit"
        
        default:
            break
        }
    }
    
    // date 타입을 전달받으면 문자열로 만들어주는 메서드 (dateFormatter)
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy - MM - dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // Contents에 border 설정_1
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        // 레이어 관련 색상 설정은 UIColor가 아닌 cgColor로 작업
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    // dateTextField에 datePicker 기능 적용_2_1
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        // addTarget
        // UIController 객체가 이벤트에 응답하는 방식 설정해주는 메서드
        // (타겟설정, 액션_호출될 메서드, 정의한 메서드를 언제 호출할 것인가)
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        // dateTextField를 선택할 때 datePicker 구현
        self.dateTextField.inputView = self.datePicker
    }
    
    // 일기 내용 작성시 등록버튼 활성화되는 메서드_1_1
    private func configureInputField() {
        // extension 설정 이전) UITextViewDelegate Protocol을 채택하라는 경고 발생
        // 일기 내용 작성시 등록버튼 활성화되는 메서드_1_4
        self.contentsTextView.delegate = self
        // 일기 내용 작성시 등록버튼 활성화되는 메서드_1_4 -> title, date, textField 역시 text가 입력될때마다 validateInputField() 호출해서 등록버튼 활성화여부 판단 -> selector 호출
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        // 일기 작성하고 나서 등록버튼을 눌렀을 때, Diary 객체 생성
        // delegate에 정의한 didSelectRegistar 메서드 호출
        // 메서드 파라미터에 생성된 다이어리 객체 전달
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(uuidString: UUID().uuidString, title: title, contents: contents, date: date, isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(indexPath, diary):
            let diary = Diary(uuidString: diary.uuidString, title: title, contents: contents, date: date, isStar: diary.isStar)
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
                    // [ "indexPath.row": indexPath.row ]
            )
        }
        
        // self.delegate?.didSelectRegister(diary: diary)
        // 화면을 일기장 화면으로 이동 (전 화면으로 이동)
        self.navigationController?.popViewController(animated: true)
    }
    
    // dateTextField에 datePicker 기능 적용_2_1 -> addTarget에 호출될 메서드
    // datePicker 개체가 전달받는다
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        // 날짜, 텍스트를 변화
        // 데이트 타입을 사람이 읽을수 있는 문자열로 변환
        // 날짜 형태의 문자열에서 데이트 타입으로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy - MM - dd(EEEEE)"
        // 데이트 포멧을 한국어로 표현
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
        // 일기 내용 작성시 등록버튼 활성화되는 메서드_3 ->
        // dateTextField -> 텍스트를 키보드로 입력받는 형태가 아님
        // datePicker로 날짜 변경해도 dateTextFieldDidChange() 호출 X
        // datePicker로 날짜 변경시,.editingChanged 액션을 발생함으로 dateTextFieldDidChange() 호출
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    //일기 내용 작성시 등록버튼 활성화되는 메서드_1_5
    // configureInputField() 기능 적용 -> addTarget에 호출될 메서드
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        // Contents 입력될때마다 활성화
        self.validateInputField()
    }
    
    //일기 내용 작성시 등록버튼 활성화되는 메서드_1_5
    // configureInputField() 기능 적용 -> addTarget에 호출될 메서드
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    // 빈 화면을 터치할 때, 키보드 기능 종료 구현
    // User가 화면 터치하면 호출되는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 일기 내용 작성시 등록버튼 활성화되는 메서드_1_3 -> 등록버튼 활성화 여부 판단 메서드
    private func validateInputField() {
        // 조건설정
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

// 일기 내용 작성시 등록버튼 활성화되는 메서드_1_2 -> UITextViewDelegate Protocol 채택
extension WriteDiaryViewController: UITextViewDelegate {
    // textView의 text 내용이 입력될때마다 호출되는 메서드
    // 입력될때마다 validateInputField() 메서드 호출 -> 등록버튼 활성화 여부 판단
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
