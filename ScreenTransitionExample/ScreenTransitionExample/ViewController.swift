//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by 조세연 on 2022/02/16.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 버튼을 눌렀을 때, 새로운 화면이 Push된다.
    @IBAction func tapCodePushButton(_ sender: UIButton) {
        // 옵셔널로 반환하기 때문에 guard 문으로 반환 (옵셔널 바인딩)
        // storyboardID = CodePushViewController
        // 각 타입에 받는 뷰컨트롤러로 다운캐스팅 시에 (as? CodePushViewController) CodePushViewController에 정의한 name property에 접근가능하다.
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else { return }
        // 다른 화면으로 push, present되기 전에 name property의 값을 넘겨주면 전환된 화면으로 데이터를 전달해준다.
        viewController.name = "ManCity"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.name = "ManCity"
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    // SegueWay로 구현된 화면 전환방법에서 전환되는 화면의 값을 전달하기 위한 제일 좋은 위치는 전처리(prepare Method)이다.
    // prepare Method를 override시키면 SegueWay 실행직전에 시스템에 의해서 override된 prepare Method가 자동으로 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 전환하려는 viewController의 인스턴스를 가져오기
        if let viewController = segue.destination as? SeguePushViewController {
            // 전달하려는 값
            viewController.name = "ManCity"
        }
    }
    
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
    
}

