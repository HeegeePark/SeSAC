//
//  ViewController.swift
//  BMICalculator
//
//  Created by 박희지 on 1/3/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var randomBMIButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var isWeightSecureButton: UIButton!
    // 키, 몸무게 정상 범위
    let heightRange = 100.0...250.0
    let weightRange = 3.0...200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // 키보드 내리기
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    // 텍스트필드 실시간 감지
    @IBAction func textFieldChanged(_ sender: UITextField) {
        // 띄어쓰기 제거
        sender.text = sender.text?.replacingOccurrences(of: " ", with: "")
    }
    
    // 랜덤 BMI 계산 버튼 클릭 시
    @IBAction func randomBMIButtonClicked(_ sender: UIButton) {
        let randomHeight = Int(Double.random(in: heightRange))
        let randomWeight = Int(Double.random(in: weightRange))
        
        heightTextField.text = String(randomHeight)
        weightTextField.text = String(randomWeight)
    }
    
    // 몸무게 암호화 버튼 클릭 시
    @IBAction func isWeightSecureButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        weightTextField.isSecureTextEntry = sender.isSelected
    }
    
    // 결과 확인 버튼 클릭 시
    @IBAction func resultButtonClicked(_ sender: UIButton) {
        // 비어있는지
        guard let height = heightTextField.text, height != "" else {
            presentAlert(alertType: .empty)
            return
        }
        
        guard let weight = weightTextField.text, weight != "" else {
            presentAlert(alertType: .empty)
            return
        }
        
        // 숫자가 맞는지
        guard let height = Double(height), let weight = Double(weight) else {
            presentAlert(alertType: .invalid)
            return
        }
        
        // 올바른 범위인지
        guard heightRange.contains(height), weightRange.contains(weight) else {
            presentAlert(alertType: .outRange)
            return
        }
        
        // BMI 계산
        let (bmi, level) = calculateBMI(height: height, weight: weight)
        
        // 계산 결과 알럿 띄우기
        presentAlert(alertType: .result(bmi: bmi, level: level))
    }
    
    func setupUI() {
        // 키, 몸무게 텍스트필드
        designTextField(heightTextField)
        designTextField(weightTextField)
        
        // 몸무게 암호화 버튼
        isWeightSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        isWeightSecureButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        isWeightSecureButton.tintColor = .gray
        
        // 랜덤 버튼
        randomBMIButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomBMIButton.setTitleColor(.red, for: .normal)
        randomBMIButton.titleLabel?.font = .systemFont(ofSize: 12)
        
        // 결과 버튼
        resultButton.setTitle("결과 확인", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.font = .systemFont(ofSize: 20)
        resultButton.backgroundColor = .customPurple
        resultButton.layer.cornerRadius = 12
    }
    
    // 텍스트필드 디자인
    func designTextField(_ textField: UITextField) {
        textField.keyboardType = .numberPad
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    // 알럿 띄우기
    func presentAlert(alertType: Alert, bmi: Double? = nil) {
        let alert = UIAlertController(title: nil, message: alertType.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // BMI 계산
    func calculateBMI(height: Double, weight: Double) -> (Double, String) {
        let heightToM = height / 100
        let bmi = round(weight / (heightToM * heightToM))
        var level: String {
            switch bmi {
            case 0..<18.5:
                return "저체중"
            case 18.5..<25.0:
                return "표준"
            case 25.0..<30:
                return "과체중"
            case 30..<35.0:
                return "비만"
            default:
                return "고도비만"
            }
        }
        return (bmi, level)
    }
}

enum Alert {
    case empty
    case invalid
    case outRange
    case result(bmi: Double, level: String)
    
    // 알럿 메시지
    var message: String {
        switch self {
        case .empty:
            return "입력하지 않은 항목이 있습니다.\n 모두 채워주세요."
        case .invalid:
            return "유효하지 않은 형식입니다.\n 숫자를 올바르게 기입해주세요."
        case .outRange:
            return "뻥치지 마세요.\n 정확한 키와 몸무게를 입력해주세요."
        case .result(let bmi, let level):
            return "당신은 \(level)입니다.\n 당신의 bmi는 \(bmi)입니다. "
        }
    }
}

