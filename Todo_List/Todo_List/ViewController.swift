//
//  ViewController.swift
//  Todo_List
//
//  Created by 조세연 on 2022/01/17.
//

import UIKit

class ViewController: UIViewController {
    
    // Table View @IBOutlet weak var 등록
    @IBOutlet weak var tableView: UITableView!
    
    // Edit Button @IBOutlet weak var 등록
    // 재사용을 위한 strong 변수 고정
    @IBOutlet var editButton: UIBarButtonItem!
    
    // 옵셔널
    var doneButton: UIBarButtonItem?

    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        // UITableView 채택(extension)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    // objective-c 와의 호환성
    // swift에서 정의한 메서드를 objective-c에서도 사용가능하도록 설정
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    // Edit Button @IBAction Func
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        // 테이블뷰가 비어있으면 편집모드 필요 X
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    // Add Button @IBAction Func
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        
        // alert 표시 _ 앱 또는 기기 상태의 중요한 상태를 주로 알림
        // 제목, 메세지, 하나 이상의 버튼 및 입력을 수집하기 위한 text field로 구성
        let alert = UIAlertController(title: "To do ...", message: nil, preferredStyle: .alert)
        
        // alert의 register button 추가
        // 핸들러에 클로져 정의 _ 파라미터에 정의된 클로져 함수 호출
        // 버튼 눌렀을 때 실행할 행동들을 정의
        let registerButton = UIAlertAction(title: "submit", style: .default, handler: { [weak self] _ in
            
            // 클로져 선언부에 캡쳐목록 정의(클로져는 참조타입 -> self의 경우 강한 순환참조(_두개의 객체가 상호참조하는 경우 발생) 발생)
            // 강한 순환잠조의 경우, 연관된 객체들은 레퍼런스가 0에 도달X, 메모리 누수 발생
            // 클로져 선언부 대괄호 안에 weak self 선언 작성 -> 캡쳐목록 정의로 강한 순환참조 방지 (unknown으로 선언하는 방식도 존재)
            
            // 텍스트필드에 등록된 값 가져오기
            guard let title = alert.textFields?[0].text else { return }
            
            // 테이블뷰에 등록된 할 일 표기
            // Task.swift 정의
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        
        // 취소 버튼 추가
        // 취소버튼은 별다른 행동이 발생 X -> 핸들러에 nil
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        // 파라미터에 UIAlert 버튼 추가 (1)
        alert.addAction(cancelButton)
        // 파라미터에 UIAlert 버튼 추가 (2)
        alert.addAction(registerButton)
        
        // Alert에 텍스트필드 추가 -> 할 일 입력할 수 있게 한다.
        // configurationHandler -> Alert을 표시하기 전에 텍스트필드를 구상하기 위한 클로져
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Write your Work."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // 할 일 저장 (딕셔너리 형태로 저장)
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        // UserDefaults에 접근
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        // 저장된 data load하기
        // guard 문으로 옵셔널 바인딩
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else {return nil }
            return Task(title: title, done: done)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    // UITableViewDataSource 구현 시, 필수로 입력해야 하는 메소드 (1) (옵셔널 x)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // UITableViewDataSource 구현 시, 필수로 입력해야 하는 메소드 (2) (옵셔널 x)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 메모리 낭비 방지 -> 셀 재사용(dequeueReusableCell)
        // "Cell" String 식별자를 통해 재사용할 셀 객체 가져오기
        // indexPath 위치에서 필요에 의해 재사용을 계속 한다
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        }   else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 삭제기능 구현
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
