//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by 조세연 on 2022/01/20.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정될 시간을 '초' 단위로 저장하는 property
    var duration = 60
    // 타이머의 상태를 가지고 있는 property (시작된 상태일 때 start)
    var timerStatus:TimerStatus = .end
    // 타이머 기능
    var timer: DispatchSourceTimer?
    // 현재 카운트되고 있는 시간을 초로 저장
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 메서드를 viewDidLoad()에서 호출
        self.configureToggleButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // 버튼의 상태에 따라 title이 변경되게 한다.
    func configureToggleButton() {
        // 버튼 초기상태(normal) -> title이 Start로 변경
        self.toggleButton.setTitle("Start", for: .normal)
        // 버튼 다른상태(selected) -> title이 Pause로 변경
        self.toggleButton.setTitle("Pause", for: .selected)
    }
    
    func startTimer() {
        if self.timer == nil {
            //
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            // 어떤 주기로 타이머를 실행할 것인가(deadline: .now() _즉시 실행, n초후 실행시 +n / repeating: n _ n초마다 반복)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            // 타이머와 함께 연동되는 이벤트핸들러 할당 / closer 함수 구현 및 호출
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds/3600
                let minutes = (self.currentSeconds%3600)/60
                let seconds = ((self.currentSeconds%3600)%60)
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                // countdown 될때마다 progressViewr가 감소
                self.progressView.progress = Float(self.currentSeconds)/Float(self.duration)
                
                if self.currentSeconds ?? 0 <= 0 {
                    // 타이머가 종료
                    self.stopTimer()
                    // iphonedev.wiki에서 확인가능
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        // 취소버튼 비활성화
        self.cancelButton.isEnabled = false
        // timerLabel과 progressView를 숨긴다.
        self.setTimerInfoViewVisible(isHidden: true)
        // datePicker는 표시한다.
        self.datePicker.isHidden = false
        // toggleButton의 상태는 selected 상태 X (normal) -> Start
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        // 메모리에서 해제 -> nil로 해제하지 않을 시, 화면을 벗어나도 타이머가 동작한다.
        self.timer = nil
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        // countDownDuration - datePicker에서 선택한 timer 시간이 몇 초인지 알려준다.
        self.duration = Int(self.datePicker.countDownDuration)
        // 시작버튼에서 timerStatus 값을 변경해준다.
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            // timerLabel과 progressView가 표시되게 한다.
            self.setTimerInfoViewVisible(isHidden: false)
            // datePicker는 사라지게 한다.
            self.datePicker.isHidden = true
            // toggleButton의 상태는 selected 상태 -> Pause
            self.toggleButton.isSelected = true
            // 취소버튼 활성화
            self.cancelButton.isEnabled = true
            // 타이머 시작
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            // toggleButton의 상태는 selected 상태 X (normal) -> Start
            self.toggleButton.isSelected = false
            // 타이머 일시중지
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            // toggleButton의 상태는 selected 상태 -> Pause
            self.toggleButton.isSelected = true
            // 타이머 재개
            self.timer?.resume()
        }
    }
    
}

