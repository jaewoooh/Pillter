import UIKit
import FirebaseFirestore
import UserNotifications

protocol AddMedViewControllerDelegate: AnyObject {
    func didSaveAlarm(name: String, dosage: String, date: String, time: String)
}

class AddMedViewController: UIViewController {
    
    weak var delegate: AddMedViewControllerDelegate?

    let db = Firestore.firestore()

    // UI 컴포넌트 선언
    let setAlarmLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설정하기"
        label.textColor = UIColor(hex: "#196EB0")
        label.font = UIFont(name: "Inter", size: 20)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addAlarmLabel: UILabel = {
        let label = UILabel()
        label.text = "복약 알림 추가하기"
        label.textColor = UIColor(hex: "#196EB0")
        label.font = UIFont(name: "Inter", size: 25)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "필요한 내용을 입력하고 저장 버튼을 눌러주세요!"
        label.textColor = UIColor(hex: "#313131")
        label.font = UIFont(name: "Poppins", size: 15)
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "약 이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "타이레놀"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#9D9D9D").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dosageLabel: UILabel = {
        let label = UILabel()
        label.text = "복용량"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dosageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "2알"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#9D9D9D").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 날짜"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM월 DD일"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#DDD").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(dateTextFieldTapped), for: .editingDidBegin)
        return textField
    }()
    
    let timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "HH:MM"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#DDD").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(timeTextFieldTapped), for: .editingDidBegin)
        return textField
    }()
    
    let switchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F3F4F6")
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let switchLabel: UILabel = {
        let label = UILabel()
        label.text = "알람 켜기"
        label.textColor = UIColor(hex: "#000")
        label.font = UIFont(name: "Open Sans", size: 12)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch()
        alarmSwitch.onTintColor = UIColor(hex: "#196EB0")
        alarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        return alarmSwitch
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#196EB0")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let datePickerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let checkBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkBoxLabel: UILabel = {
        let label = UILabel()
        label.text = "매주 같은 요일 및 같은 시간으로 하기"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소하기", for: .normal)
        button.setTitleColor(UIColor(hex: "#EA4335"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter", size: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#4E4E4E").cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let saveDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#196EB0")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveDateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var dates: [String] = []
    var hours: [String] = []
    var minutes: [String] = []
    
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 그라데이션 배경 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "E6EEFF").cgColor, UIColor(hex: "#FFFFFF").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.backgroundColor = .white
        
        setupDateData()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
        setupViews()
        setupConstraints()
        
        // 화면을 터치했을 때 키보드를 숨기기 위한 탭 제스처 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupDateData() {
        let calendar = Calendar.current
        let today = Date()
        
        for day in 0..<10 {
            if let date = calendar.date(byAdding: .day, value: day, to: today) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM월 dd일"
                dates.append(formatter.string(from: date))
            }
        }
        
        hours = (0..<24).map { String(format: "%02d", $0) }
        minutes = (0..<60).map { String(format: "%02d", $0) }
    }

    
    func setupViews() {
        view.addSubview(addAlarmLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(dosageLabel)
        view.addSubview(dosageTextField)
        view.addSubview(dateLabel)
        view.addSubview(dateTextField)
        view.addSubview(timeLabel)
        view.addSubview(timeTextField)
        view.addSubview(switchContainerView)
        switchContainerView.addSubview(switchLabel)
        switchContainerView.addSubview(alarmSwitch)
        view.addSubview(saveButton)
        
        view.addSubview(datePickerContainerView)
        datePickerContainerView.addSubview(setAlarmLabel)
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.addSubview(cancelButton)
        datePickerContainerView.addSubview(saveDateButton)
        datePickerContainerView.addSubview(checkBox)
        datePickerContainerView.addSubview(checkBoxLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addAlarmLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addAlarmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: addAlarmLabel.bottomAnchor, constant: 8),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 52),
            
            dosageLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            dosageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dosageTextField.topAnchor.constraint(equalTo: dosageLabel.bottomAnchor, constant: 10),
            dosageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dosageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dosageTextField.heightAnchor.constraint(equalToConstant: 52),
            
            dateLabel.topAnchor.constraint(equalTo: dosageTextField.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateTextField.heightAnchor.constraint(equalToConstant: 52),
            
            timeLabel.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeTextField.heightAnchor.constraint(equalToConstant: 52),
            
            switchContainerView.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 20),
            switchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            switchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            switchContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            switchLabel.centerYAnchor.constraint(equalTo: switchContainerView.centerYAnchor),
            switchLabel.leadingAnchor.constraint(equalTo: switchContainerView.leadingAnchor, constant: 12),
            
            alarmSwitch.centerYAnchor.constraint(equalTo: switchContainerView.centerYAnchor),
            alarmSwitch.trailingAnchor.constraint(equalTo: switchContainerView.trailingAnchor, constant: -12),
            
            saveButton.topAnchor.constraint(equalTo: switchContainerView.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 130),
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            
            datePickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePickerContainerView.widthAnchor.constraint(equalToConstant: 343),
            datePickerContainerView.heightAnchor.constraint(equalToConstant: 400),
            
            setAlarmLabel.topAnchor.constraint(equalTo: datePickerContainerView.topAnchor, constant: 20),
            setAlarmLabel.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 20),
            
            datePicker.topAnchor.constraint(equalTo: setAlarmLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor),
            
            checkBox.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            checkBox.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 20),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            checkBoxLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor),
            checkBoxLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            checkBoxLabel.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -20),
            
            cancelButton.leadingAnchor.constraint(equalTo: datePickerContainerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: 125),
            cancelButton.heightAnchor.constraint(equalToConstant: 45),
            
            saveDateButton.trailingAnchor.constraint(equalTo: datePickerContainerView.trailingAnchor, constant: -20),
            saveDateButton.bottomAnchor.constraint(equalTo: datePickerContainerView.bottomAnchor, constant: -20),
            saveDateButton.widthAnchor.constraint(equalToConstant: 125),
            saveDateButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    
    @objc func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }

    @objc func dateTextFieldTapped() {
        activeTextField = dateTextField
        view.endEditing(true)
        datePicker.reloadAllComponents()
        datePickerContainerView.isHidden = false
    }

    @objc func timeTextFieldTapped() {
        activeTextField = timeTextField
        view.endEditing(true)
        datePicker.reloadAllComponents()
        datePickerContainerView.isHidden = false
    }
    
    @objc func cancelButtonTapped() {
        datePickerContainerView.isHidden = true
    }
    
    @objc func saveDateButtonTapped() {
        
        if activeTextField == dateTextField {
            let selectedDate = dates[datePicker.selectedRow(inComponent: 0)]
            dateTextField.text = selectedDate
        } else if activeTextField == timeTextField {
            let selectedHour = hours[datePicker.selectedRow(inComponent: 0)]
            let selectedMinute = minutes[datePicker.selectedRow(inComponent: 1)]
            timeTextField.text = "\(selectedHour):\(selectedMinute)"
        }
        
        datePickerContainerView.isHidden = true
    }

    
    @objc func saveButtonTapped() {
        
        // 필수 항목들이 입력되었는지 확인
            guard let name = nameTextField.text, !name.isEmpty else {
                showAlert(message: "약 이름을 작성해주세요!")
                return
            }
            
            guard let dosage = dosageTextField.text, !dosage.isEmpty else {
                showAlert(message: "복용량을 작성해주세요!")
                return
            }
            
            guard let date = dateTextField.text, !date.isEmpty else {
                showAlert(message: "알림 날짜를 선택해주세요!")
                return
            }
            
            guard let time = timeTextField.text, !time.isEmpty else {
                showAlert(message: "알림 시간을 선택해주세요!")
                return
        }
        
        let alarmData: [String: Any] = [
            "name": name,
            "dosage": dosage,
            "date": date,
            "time": time,
            "timestamp": Timestamp()
        ]

        db.collection("alarms").addDocument(data: alarmData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
        
        delegate?.didSaveAlarm(name: name, dosage: dosage, date: date, time: time)
        navigationController?.popViewController(animated: true)
    }
}

extension AddMedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return activeTextField == dateTextField ? 1 : 2 // 날짜는 1개의 컴포넌트, 시간은 2개의 컴포넌트 (시, 분)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return activeTextField == dateTextField ? dates.count : hours.count
        case 1: return minutes.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == dateTextField {
            return dates[row]
        } else {
            return component == 0 ? hours[row] : minutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return component == 0 ? (activeTextField == dateTextField ? 250 : 50) : 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        
        if activeTextField == dateTextField {
            label.text = dates[row]
        } else {
            label.text = component == 0 ? "\(hours[row])시" : "\(minutes[row])분"
        }
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }
    
    // 경고창을 띄우는 함수
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "경고", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: 키보드
    @objc func dismissKeyboard() {
        view.endEditing(true) // 키보드 내리기
    }
}
