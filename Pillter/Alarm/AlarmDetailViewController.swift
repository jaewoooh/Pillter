import UIKit
import FirebaseFirestore

class AlarmDetailViewController: UIViewController {

    var medicationName: String
    var dosage: String
    var date: String
    var time: String
    var alarmDocumentID: String  // 삭제할 알람의 Document ID

    // Firestore 데이터베이스 인스턴스
    let db = Firestore.firestore()

    // 약 복용 여부를 묻는 카드 뷰
    let cardView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(hex: "#EFFAFF").cgColor
        view.layer.cornerRadius = 41.96
        view.layer.borderWidth = 1.75
        view.layer.borderColor = UIColor(red: 0.847, green: 0.851, blue: 0.878, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // "복용하셨나요?" 타이틀 레이블 위에 선을 추가
    let titleTopUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.847, green: 0.851, blue: 0.878, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // "복용하셨나요?" 타이틀 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "복용하셨나요?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(hex: "#196EB0")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 약 이미지를 보여주는 이미지 뷰
    let medicationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CoinInHand")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // 약 이름 레이블
    let medicationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "타이레놀"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = UIColor(hex: "#196EB0")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 복용 시간과 날짜 레이블
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "09:41 PM, 수요일"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#196EB0")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 복용량 레이블
    let dosageLabel: UILabel = {
        let label = UILabel()
        label.text = "1알"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: "#196EB0")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 캘린더 아이콘 이미지 뷰
    let calendarIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar") // 미리 저장한 캘린더 아이콘 사용
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 문서 아이콘 이미지 뷰
    let documentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "document") // 미리 저장한 문서 아이콘 사용
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 날짜 및 시간과 캘린더 아이콘을 위한 스택 뷰
    let dateTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 복용량과 문서 아이콘을 위한 스택 뷰
    let dosageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // "네" 버튼
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("네", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(hex: "#196EB0")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 쓰레기통 아이콘 (삭제 버튼)
    let trashIconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 46).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.layer.backgroundColor = UIColor(red: 0.937, green: 0.98, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.918, green: 0.925, blue: 0.941, alpha: 1).cgColor
        
        let trashIconImageView = UIImageView(image: UIImage(systemName: "trash.fill"))
        trashIconImageView.tintColor = UIColor.darkGray
        trashIconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trashIconImageView)
        
        NSLayoutConstraint.activate([
            trashIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trashIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trashIconImageView.widthAnchor.constraint(equalToConstant: 25),
            trashIconImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return view
    }()
    
    // 초기화 메서드
    init(medicationName: String, dosage: String, date: String, time: String, alarmDocumentID: String) {
        self.medicationName = medicationName
        self.dosage = dosage
        self.date = date
        self.time = time
        self.alarmDocumentID = alarmDocumentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 전달받은 데이터를 UI에 반영
        medicationNameLabel.text = medicationName
        dateTimeLabel.text = "\(date), \(time)"
        dosageLabel.text = dosage

        // 뷰 배경 색상 설정
        view.backgroundColor = UIColor.white

        // 카드 뷰를 메인 뷰에 추가
        view.addSubview(cardView)

        // 카드 뷰 안에 컴포넌트 추가
        cardView.addSubview(titleLabel)
        cardView.addSubview(titleTopUnderline)
        cardView.addSubview(medicationImageView)
        cardView.addSubview(medicationNameLabel)
        cardView.addSubview(confirmButton)

        // 스택 뷰에 아이콘과 레이블 추가
        dateTimeStackView.addArrangedSubview(calendarIconImageView)
        dateTimeStackView.addArrangedSubview(dateTimeLabel)
        cardView.addSubview(dateTimeStackView)

        dosageStackView.addArrangedSubview(documentIconImageView)
        dosageStackView.addArrangedSubview(dosageLabel)
        cardView.addSubview(dosageStackView)

        // 쓰레기통 아이콘 추가
        cardView.addSubview(trashIconView)

        // 쓰레기통 아이콘에 탭 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(trashIconTapped))
        trashIconView.addGestureRecognizer(tapGestureRecognizer)

        // 제약 조건 설정
        setupConstraints()
    }

    // 쓰레기통 아이콘이 눌렸을 때 호출되는 함수
    @objc func trashIconTapped() {
        // 경고창을 생성
        let alertController = UIAlertController(title: "삭제 경고", message: "삭제시에는 복구가 불가능합니다. 삭제하시겠습니까?", preferredStyle: .alert)
        
        // "예" 버튼 추가
        let deleteAction = UIAlertAction(title: "예", style: .destructive) { _ in
            // Firestore에서 데이터를 삭제하는 코드
            self.db.collection("alarms").document(self.alarmDocumentID).delete { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                } else {
                    print("Document successfully deleted")
                    // 이전 화면으로 돌아가기
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        // "아니오" 버튼 추가
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            // AlarmDetailViewController로 이동
            let detailVC = AlarmDetailViewController(medicationName: self.medicationName, dosage: self.dosage, date: self.date, time: self.time, alarmDocumentID: self.alarmDocumentID)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // 경고창을 화면에 표시
        present(alertController, animated: true, completion: nil)
    }
    
    // 제약 조건 설정
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // 카드 뷰의 제약 조건 설정
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 317.52),
            cardView.heightAnchor.constraint(equalToConstant: 533),
            
            // 타이틀 레이블 위 선 제약 조건 설정
            titleTopUnderline.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10), // 적절한 간격 조정
            titleTopUnderline.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            titleTopUnderline.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, constant: 120),
            titleTopUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            // 타이틀 레이블 제약 조건 설정
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 110),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            // 약 이미지 뷰 제약 조건 설정
            medicationImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            medicationImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            medicationImageView.widthAnchor.constraint(equalToConstant: 166),
            medicationImageView.heightAnchor.constraint(equalToConstant: 165),
            
            // 약 이름 레이블 제약 조건 설정
            medicationNameLabel.topAnchor.constraint(equalTo: medicationImageView.bottomAnchor, constant: 10),
            medicationNameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            // 날짜 및 시간 스택 뷰 제약 조건 설정
            dateTimeStackView.topAnchor.constraint(equalTo: medicationNameLabel.bottomAnchor, constant: 20),
            dateTimeStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            // 캘린더 아이콘 크기 설정
            calendarIconImageView.widthAnchor.constraint(equalToConstant: 20),  // 원하는 너비
            calendarIconImageView.heightAnchor.constraint(equalToConstant: 20), // 원하는 높이
            
            // 복용량 스택 뷰 제약 조건 설정
            dosageStackView.topAnchor.constraint(equalTo: dateTimeStackView.bottomAnchor, constant: 10),
            dosageStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20), // 왼쪽 정렬
            
            // 문서 아이콘 크기 설정
            documentIconImageView.widthAnchor.constraint(equalToConstant: 20),  // 원하는 너비
            documentIconImageView.heightAnchor.constraint(equalToConstant: 20),// 원하는 높이
            
            // 확인 버튼 제약 조건 설정
            confirmButton.topAnchor.constraint(equalTo: dosageStackView.bottomAnchor, constant: 25),
            confirmButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 쓰레기통 아이콘 제약 조건 설정
            trashIconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            trashIconView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -25)
        ])
    }
}
