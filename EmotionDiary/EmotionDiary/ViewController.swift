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
    var tapCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0]

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
        
        updateLabel(idx: idx, num: result)
    }
    
    // 랜덤 숫자 반환
    func getRandomNumber() -> Int {
        return Int.random(in: 1...100)
    }
    
    // 클릭 횟수 반환
    func addCountingNumber(idx: Int) -> Int {
        tapCounts[idx] += 1
        return tapCounts[idx]
    }
    
    // 레이블 텍스트 변경
    func updateLabel(idx: Int, num: Int) {
        labels[idx].text = emotionList[idx] + " " + "\(num)"
    }
    
    // 버튼 셋팅
    func setButtons(_ button: UIButton) {
        let image = UIImage(named: "slime" + "\(button.tag + 1)")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
    }
    
    // 레이블 셋팅
    func setLabels(_ label: UILabel) {
        let idx = label.tag
        updateLabel(idx: idx, num: 0)
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
    }
}
