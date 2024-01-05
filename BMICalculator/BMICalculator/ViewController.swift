//
//  ViewController.swift
//  BMICalculator
//
//  Created by 박희지 on 1/3/24.
//

import UIKit
import TextFieldEffects

class ViewController: UIViewController {
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var randomBMIButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    @IBOutlet var isWeightSecureButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var nicknameTextField: HoshiTextField!
    @IBOutlet var nicknameEditButton: UIButton!
    
    var nickname: String?
    var height: Double?
    var weight: Double?
    
    // 키, 몸무게 정상 범위
    let heightRange = 100.0...250.0
    let weightRange = 3.0...200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname = getLocalData(key: "nickname") as! String?
        height = getLocalData(key: "height") as! Double?
        weight = getLocalData(key: "weight") as! Double?
        
        setupUI()
    }
    
    // 닉네임 텍스트필드 클릭 시
    @IBAction func nicknameEditingStarted(_ sender: HoshiTextField) {
        activeButton()
    }
    
    // 닉네임 텍스트필드 return key 클릭 시
    @IBAction func nicknameTextFieldExit(_ sender: HoshiTextField) {
        editNickname(name: nicknameTextField.text)
    }
    // 닉네임 수정 버튼 클릭 시
    @IBAction func nicknameEditButtonClicked(_ sender: UIButton) {
        editNickname(name: nicknameTextField.text)
    }
    
    // 리셋 버튼 클릭 시
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        nickname = nil
        height = nil
        weight = nil
        resetLocalData()
        updateSubtitle()
        clearTextField()
    }
    
    // 키보드 내리기
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        deactiveButton()
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
        guard let height = heightTextField.text, !height.isEmpty else {
            presentAlert(alertType: .empty)
            return
        }
        
        guard let weight = weightTextField.text, !weight.isEmpty else {
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
        
        // 키, 몸무게 UserDefaults 저장
        setLocalData(data: height, key: "height")
        setLocalData(data: weight, key: "weight")
        
        // 계산 결과 알럿 띄우기
        presentAlert(alertType: .result(bmi: bmi, level: level))
    }
    
    // 닉네임 수정
    func editNickname(name: String?) {
        guard let name else { return }
        nickname = name
        setLocalData(data: name, key: "nickname")
        deactiveButton()
        updateSubtitle()
        view.endEditing(true)
    }
    
    // UserDefaults get
    func getLocalData(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    // UserDefaults set
    func setLocalData(data: Any?, key: String) {
        guard let data else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    // UserDefaults 데이터 리셋
    func resetLocalData() {
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
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
    
    func setupUI() {
        // 부제 레이블
        updateSubtitle()
        
        // 닉네임 수정 텍스트필드
        nicknameTextField.borderStyle = .line
        nicknameTextField.borderActiveColor = .customPurple
        nicknameTextField.font = .boldSystemFont(ofSize: 16)
        nicknameTextField.placeholder = "닉네임 수정하기"
        nicknameTextField.placeholderColor = .customPurple
        nicknameTextField.placeholderFontScale = 0.8
        
        // 닉네임 수정 버튼
        deactiveButton()
        nicknameEditButton.setTitle("확인", for: .normal)
        nicknameEditButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        nicknameEditButton.setTitleColor(.white, for: .normal)
        nicknameEditButton.setTitleColor(.clear, for: .disabled)
        nicknameEditButton.layer.cornerRadius = 8
        
        // 키, 몸무게 텍스트필드
        designTextField(heightTextField, userDefaultsKey: "height")
        designTextField(weightTextField, userDefaultsKey: "weight")
        
        // 몸무게 암호화 버튼
        isWeightSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        isWeightSecureButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        isWeightSecureButton.tintColor = .gray
        
        // 랜덤 버튼
        randomBMIButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomBMIButton.setTitleColor(.red, for: .normal)
        randomBMIButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        
        // 리셋 버튼
        resetButton.setTitle("리셋", for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 16)
        resetButton.setTitleColor(.customPurple, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.customPurple.cgColor
        
        // 결과 버튼
        resultButton.setTitle("결과 확인", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.font = .systemFont(ofSize: 20)
        resultButton.backgroundColor = .customPurple
        resultButton.layer.cornerRadius = 12
    }
    
    // 텍스트필드 디자인
    func designTextField(_ textField: UITextField, userDefaultsKey key: String) {
        let value = UserDefaults.standard.double(forKey: key)
        textField.text = value == 0 ? "": String(Int(value))
        textField.keyboardType = .numberPad
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: view.frame.height))
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    // 닉네임 수정 버튼 활성화
    func activeButton() {
        nicknameEditButton.isEnabled = true
        nicknameEditButton.backgroundColor = .customPurple
    }
    
    // 닉네임 수정 버튼 비활성화
    func deactiveButton() {
        nicknameEditButton.isEnabled = false
        nicknameEditButton.backgroundColor = .clear
        nicknameTextField.text = nil
    }
    
    // 부제 레이블 닉네임 업데이트
    func updateSubtitle() {
        subtitleLabel.text = "\(nickname ?? "당신")의 BMI 지수를\n 알려드릴게요"
    }
    
    // 텍스트필드 값 비우기
    func clearTextField() {
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    // 알럿 띄우기
    func presentAlert(alertType: Alert, bmi: Double? = nil) {
        let alert = UIAlertController(title: nil, message: alertType.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
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
