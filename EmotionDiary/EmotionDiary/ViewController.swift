//
//  ViewController.swift
//  EmotionDiary
//
//  Created by 박희지 on 1/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    
    let emotionList = ["행복해", "사랑해", "좋아해", "당황해", "속상해", "우울해", "심심해", "행복해", "행복해"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (button, label) in zip(buttons, labels) {
            setButtons(button)
            setLabels(label)
        }
    }
    
    @IBAction func emotionButtonClicked(_ sender: UIButton) {
        let idx = sender.tag
        
        // 랜덤 숫자
//        let result = getRandomNumber()
        
        // 클릭 수 카운팅
         let result = addCountingNumber(idx: idx)
        
        setLocalCount(idx: idx, count: result)
        updateLabel(idx: idx, count: result)
    }
    
    // 랜덤 숫자 반환
    func getRandomNumber() -> Int {
        return Int.random(in: 1...100)
    }
    
    // 클릭 횟수 반환
    func addCountingNumber(idx: Int) -> Int {
        let newCount = getLocalCount(idx) + 1
        return newCount
    }
    
    // UserDefaults 값 가져오기
    func getLocalCount(_ idx: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "count\(idx)")
    }
    
    // UserDefaults 값 셋팅
    func setLocalCount(idx: Int, count: Int) {
        UserDefaults.standard.set(count, forKey: "count\(idx)")
    }
    
    // 레이블 텍스트 변경
    func updateLabel(idx: Int, count: Int) {
        labels[idx].text = emotionList[idx] + " " + "\(count)"
    }
    
    // 버튼 셋팅
    func setButtons(_ button: UIButton) {
        let image = UIImage(named: "slime" + "\(button.tag + 1)")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
    }
    
    // 레이블 셋팅
    func setLabels(_ label: UILabel) {
        let idx = label.tag
        let count = getLocalCount(idx)
        updateLabel(idx: idx, count: count)
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
    }
}
