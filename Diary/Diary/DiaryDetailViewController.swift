//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 조세연 on 2022/01/22.
//

import UIKit

// 일기 삭제
// delegate를 통해 일기장 상세화면에서 삭제가 일어날 때, 메서드를 통해 일기장 리스트 화면에 IndexPath를 전달
// 이후 diaryList 배열과 collectionView에 일기가 삭제되도록 구현
// ( 나중에 즐겨찾기 탭을 구현할때 delegate 삭제하고 notificationCenter 이용해서 일기 삭제되었다는 이벤트 보낼 예정 )
protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelegate(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datelabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    // 일기장 목록에서 일기 선택시 일기 상세화면으로 이동하기_1
    // 일기장 리스트 화면에서 전달받을 프로퍼티 선언
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 일기장 리스트 화면에서 일기 선택시 일기 상세화면으로 이동하기_3
        // 일기장 리스트 화면에서 일기장을 선택했을 때, 다이어리 프로퍼티에 다이어리 객체 넘겨주고 일기장 상세화면에 일기장 제목과 내용 날짜가 표시된다.
        self.configureView()
    }
    
    // 일기장 목록에서 일기 선택시 일기 상세화면으로 이동하기_2
    // 프로퍼티를 통해 전달받은 다이어리 객체를 뷰에 초기화
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.datelabel.text = self.dateToString(date: diary.date)
    }
    
    // date 타입을 전달받으면 문자열로 만들어주는 메서드 (dateFormatter)
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy - MM - dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
     }
    
    // 수정버튼 누를 때, WriteDiaryViewController 화면이 push되도록 구현
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // 삭제버튼 누를 때,tapDeleteButton 함수 구현
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelegate(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
