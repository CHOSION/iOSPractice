//
//  ViewController.swift
//  Diary
//
//  Created by 조세연 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // [Diary]() -> Diary 타입 배열로 초기화
    // 프로퍼티 옵저버
    // 다이어리 리스트에 일기가 추가되거나 변경될때 userDefaults에 저장
    private var diaryList = [Diary]() {
        didSet{
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
    }
    
    // self.diaryList에 추가된 일기를 보여주기
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // UICollectionView.delegate 와 UICollectionView.dataSource 프로토콜을 채택하라는 에러 발생
        //
        // extension ViewController: UICollectionViewDataSource
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    // writeDiaryViewController > tapConfirmButton의 delegate를 통해 작성된 diary가 전달될 준비가 되었을 때, viewController로 이동해 받을 준비를 한다.
    // 일기작성 화면이동은 segue way를 통해 이동하기 때문에 prepare 메서드를 override한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController{
            // extension 이전) writeDiaryViewDelegate를 채택받아야 한다.
            // -> extension ViewController: WriteDiaryViewDelegate
            writeDiaryViewController.delegate = self
        }
    }
    
    //
    private func saveDiaryList() {
        // 일기들을 userDefaults의 user dictionary 배열 형태로 저장
        let date = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        // (일기가 저장되어 있는 date, 다이어리 리스트)
        userDefaults.set(date, forKey: "diaryList")
    }
    
    // userDefaults에 저장된 값 불러오기
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        // 딕셔너리 배열 형태로 타입캐스팅
        // 타입캐스팅 실패시 nil이 될수 있으니 guard 문으로 옵셔널 바인딩
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        // 불러온 데이터를 diaryList에 넣어주기
        // Diary 타입이 되도록 매핑
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil}
            guard let date = $0["date"] as? Date else { return nil}
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        // 일기를 최신 날짜순으로 불러오기
        self.diaryList = self.diaryList.sorted(by: {
            // compare 메서드를 통헤 $0.date와 $1.date 비교(orderedDescending -> 내림차순정렬)
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    // date 타입을 전달받으면 문자열로 만들어주는 메서드
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy - MM - dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

// CollectionView에서 DataSource는 CollectionView로 보여주는 콘텐츠를 관리
extension ViewController: UICollectionViewDataSource {
    // 지정된 섹션에 표시할 셀의 개수를 묻는 메서드 -> 다이어리 갯수만큼 표시
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    // 필수메서드인 cellForItemAt 구현 -> CollectionView에 지정된 위치에 표시할 셀을 요청하는 메서드
    // cellForItemAt 메서드에서 collectionView에 일기장 목록 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // dequeueReusableCell이라는 메서드를 통해 스토리보드에서 구상한 customCell 가져오기
        // withReuseIdentifier에 customCell의 identifier값인 "DiaryCell"를 넣어주고, for 파라미터엔 indexPath
        // as? DiaryCell  -> DiaryCell 로 다운캐스팅 -> 실패시 빈 UICollectionViewCell() 반환
        // 테이블 뷰와 마찬가지로 dequeueReusableCell을 이용한 경우 withReuseIdentifier로 전달받은 재사용 식별자를 통해 재사용이 가능한 collectionView를 찾고 이를 반환
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        // 재사용할 셀 위에 일기 제목과 날짜가 나타나게 구현
        // 다이어리 상수 -> 일기들이 저장되어 있는 배열에 indexPath.row 값으로 저장된 일기 가져오기
        let diary = self.diaryList[indexPath.row]
        // 일기 제목
        cell.titleLabel.text = diary.title
        // 날짜 표시 -> 다이어리 인스턴스에 있는 데이트 프로퍼티는 데이트 형식 -> 문자열 형식으로 변환 필수
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// collectionView의 Layout 구현
extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20, height: 200)
    }
}

// 일기장 리스트 화면에서 일기 선택시 일기 상세화면으로 이동하기_4 (이전에 storyboard에 id)
extension ViewController: UICollectionViewDelegate {
    // didSelectItemAt: 특정 셀이 선택되었음을 알리는 메서드 -> DiaryDetailViewController가 push되도록 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // storyboard에 있는 ViewController를 인스턴스화, DiaryDetailViewController 로 타입캐스팅
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        // 선택한 일기가 무엇인지 다이어리 상수에 대입
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    // 일기가 작성이 될 때, didSelectRegister 메서드 파라미터를 통해 작성된 일기의 내용이 담긴 다이어리 객체가 전달
    func didSelectRegister(diary: Diary) {
        // 다이어리 객체를 self.diaryList에 추가
        // 다이어리 리스트에 추가된 일기를 collectionView에서 보여줘야 한다
        // -> private func configureCollectionView()
        self.diaryList.append(diary)
        // 일기를 최신 날짜순으로 불러오기
        self.diaryList = self.diaryList.sorted(by: {
            // compare 메서드를 통헤 $0.date와 $1.date 비교(orderedDescending -> 내림차순정렬)
            $0.date.compare($1.date) == .orderedDescending
        })
        // 일기를 추가할 때마다 collectionView에 일기 목록이 표시된다.
        self.collectionView.reloadData()
    }
}

// 일기장 삭제기능 delegate 확장
extension ViewController: DiaryDetailViewDelegate {
    func didSelectDelegate(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
}
