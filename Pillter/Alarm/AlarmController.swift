import UIKit
import UserNotifications

class AlarmController: UIViewController {

    // 상단에 현재 날짜를 표시하는 레이블
    let todayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#00459C")  // 텍스트 색상
        label.font = UIFont(name: "Inter", size: 20)
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)  // 텍스트 크기 및 굵기 설정
        label.textAlignment = .left  // 왼쪽 정렬
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // "오늘의 약" 레이블
    let todayMedLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 약"
        label.textColor = UIColor(hex: "#00459C")
        label.font = UIFont(name: "Inter", size: 29)
        label.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 날짜를 스크롤할 수 있는 컬렉션 뷰
    let dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8  // 셀 간의 간격 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCell")
        return collectionView
    }()
    
    // 네모 모양의 UIView
    let dateContainerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        // 그림자 추가
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1  // 그림자 투명도
        view.layer.shadowOffset = CGSize(width: 0, height: 2)  // 그림자의 위치 조정
        view.layer.shadowRadius = 8  // 그림자 반경
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // "오늘의 약" 레이블과 medCircleView를 포함하는 네모 모양의 UIView
    let medContainerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        // 그림자 추가
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1  // 그림자 투명도
        view.layer.shadowOffset = CGSize(width: 0, height: 2)  // 그림자의 위치 조정
        view.layer.shadowRadius = 8  // 그림자 반경

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 약 복용 현황을 보여주는 원형 뷰
    let medCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F9FD")
        view.layer.cornerRadius = 120
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 약 이미지를 보여주는 이미지 뷰
    let pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pill")  // 약 이미지 설정
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 복용량을 보여주는 레이블
    let medCountLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36)])
        attributedText.append(NSAttributedString(string: "/0", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#00459C"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 요일을 보여주는 레이블
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "화요일"  // 요일 텍스트 설정
        label.textColor = UIColor(hex: "#B8B8B8")
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 약 추가 버튼
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(hex: "#00459C")
        button.layer.cornerRadius = 10  // 둥근 모서리 크기를 줄임
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#EAECF0").cgColor
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // 저장된 알람들을 보여주는 스택 뷰
    let alarmStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 날짜 데이터 배열
    var dates: [Date] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 그라데이션 배경 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "E6EEFF").cgColor, UIColor(hex: "#FFFFFF").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        // 네비게이션 바 타이틀 설정
        self.title = "알림"
        
        // 현재 날짜를 "YYYY년 M월" 형식으로 설정
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
        todayLabel.text = dateFormatter.string(from: Date())
        
        // 컬렉션 뷰 델리게이트와 데이터 소스 설정
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        
        // 오늘 날짜의 요일 설정
        dateFormatter.dateFormat = "EEEE"  // 요일을 나타내는 포맷
        dayLabel.text = dateFormatter.string(from: Date())
        
        // 뷰 설정 및 제약 조건 추가
        setupViews()
        setupConstraints()
        setupDates()
        
        // 오늘 날짜의 인덱스 설정
        let todayIndex = dates.firstIndex { Calendar.current.isDateInToday($0) }
        if let todayIndex = todayIndex {
            selectedIndexPath = IndexPath(item: todayIndex, section: 0)
            dateCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한 허용")
            } else {
                print("알림 권한 거부")
            }
        }
        
        // 네비게이션바 타이틀 애니메이션 효과 추가
        setupNavigationBarTitleView()
    }
    
    //네비게이션바 타이틀 애니메이션 효과 기능 함수
    private func setupNavigationBarTitleView() {
        // "알림" 텍스트 설정
        let titleLabel = UILabel()
        titleLabel.text = "My Pill"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor.black // 텍스트 색상 설정
        
        // GIF 이미지 설정
        let animatedImageView = UIImageView()
        if let gifImage = UIImage.gif(name: "Alarm_anicon") {
            animatedImageView.image = gifImage
            animatedImageView.contentMode = .scaleAspectFit
            
            // 이미지의 크기 설정
            animatedImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            animatedImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        // 스택 뷰 설정 (Label과 ImageView를 수평으로 배치)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, animatedImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8 // 텍스트와 이미지 간의 간격 설정
        stackView.alignment = .center
        
        // 스택 뷰를 네비게이션 바의 타이틀 뷰로 설정
        self.navigationItem.titleView = stackView
    }


    
    // 뷰를 서브뷰로 추가
    func setupViews() {
        view.addSubview(dateContainerView)
        dateContainerView.addSubview(todayLabel)
        dateContainerView.addSubview(dateCollectionView)
        
        view.addSubview(medContainerView)
        medContainerView.addSubview(todayMedLabel)
        medContainerView.addSubview(medCircleView)
        medCircleView.addSubview(pillImageView)
        medCircleView.addSubview(medCountLabel)
        medCircleView.addSubview(dayLabel)
        
        view.addSubview(addButton)
        view.addSubview(alarmStackView)
    }
    
    // 제약 조건 설정
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // dateContainerView 설정
            dateContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            dateContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            dateContainerView.heightAnchor.constraint(equalToConstant: 160),
            
            todayLabel.topAnchor.constraint(equalTo: dateContainerView.topAnchor, constant: 16),
            todayLabel.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor, constant: 16),
            
            dateCollectionView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 20),
            dateCollectionView.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor, constant: 16),
            dateCollectionView.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor, constant: -16),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 85),
            
            // medContainerView 설정
            medContainerView.topAnchor.constraint(equalTo: dateContainerView.bottomAnchor, constant: 40),
            medContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            medContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            medContainerView.heightAnchor.constraint(equalToConstant: 360),  // 높이를 적절히 조정
            
            todayMedLabel.topAnchor.constraint(equalTo: medContainerView.topAnchor, constant: 16),
            todayMedLabel.centerXAnchor.constraint(equalTo: medContainerView.centerXAnchor),
            
            medCircleView.topAnchor.constraint(equalTo: todayMedLabel.bottomAnchor, constant: 20),
            medCircleView.centerXAnchor.constraint(equalTo: medContainerView.centerXAnchor),
            medCircleView.widthAnchor.constraint(equalToConstant: 240),
            medCircleView.heightAnchor.constraint(equalToConstant: 240),
            
            pillImageView.topAnchor.constraint(equalTo: medCircleView.topAnchor, constant: 30),
            pillImageView.centerXAnchor.constraint(equalTo: medCircleView.centerXAnchor),
            pillImageView.widthAnchor.constraint(equalToConstant: 52),  // 이미지 크기를 크게 설정
            pillImageView.heightAnchor.constraint(equalToConstant: 52),  // 이미지 크기를 크게 설정
            
            medCountLabel.topAnchor.constraint(equalTo: pillImageView.bottomAnchor, constant: 20),
            medCountLabel.centerXAnchor.constraint(equalTo: medCircleView.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: medCountLabel.bottomAnchor, constant: 10),
            dayLabel.centerXAnchor.constraint(equalTo: medCircleView.centerXAnchor),
            
            // addButton 설정
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),  // 오른쪽으로 이동
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),  // 약간 위로 올림
            
            // alarmStackView 설정
            alarmStackView.topAnchor.constraint(equalTo: medContainerView.bottomAnchor, constant: 20),
            alarmStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            alarmStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            alarmStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20)
        ])
    }
    
    // 날짜 데이터 설정 (오늘 날짜부터 앞으로 7일 및 지난 2일)
    func setupDates() {
        for i in -2...7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: Date()) {
                dates.append(date)
            }
        }
        dateCollectionView.reloadData()
    }
    
    // 약 추가 버튼이 눌렸을 때 호출되는 함수
    @objc func addButtonTapped() {
        let addMedVC = AddMedViewController()
        addMedVC.delegate = self
        navigationController?.pushViewController(addMedVC, animated: true)
    }
}

extension AlarmController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 컬렉션 뷰 아이템 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    // 컬렉션 뷰 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        let date = dates[indexPath.item]
        
        // 날짜와 요일 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ko_KR")
        dayFormatter.dateFormat = "EEEE"  // 요일 전체 이름
        cell.dayLabel.text = dayFormatter.string(from: date)
        
        // 오늘 날짜 셀을 기본적으로 선택 상태로 설정
        if Calendar.current.isDateInToday(date) {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        return cell
    }
    
    // 컬렉션 뷰 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 85)  // 셀의 크기를 설정
    }
    
    // 셀 선택 시 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: previousIndexPath, animated: false)  // 이전에 선택된 셀을 선택 해제
        }
        selectedIndexPath = indexPath  // 현재 선택된 셀의 인덱스 경로를 저장
    }
}

extension AlarmController: AddMedViewControllerDelegate {
    func didSaveAlarm(name: String, dosage: String, date: String, time: String) {
        let alarmView = createAlarmView(name: name, dosage: dosage, date: date, time: time)
        alarmStackView.addArrangedSubview(alarmView)  // 새로운 알람 뷰를 스택 뷰에 추가
        scheduleNotification(name: name, time: time)  // 알림 스케줄 설정
        
        // 알람 스택 뷰에 새로운 알람이 추가될 때마다 "/N" 부분을 업데이트
        updateMedCountLabel()
    }

    func updateMedCountLabel() {
        let currentCount = alarmStackView.arrangedSubviews.count
        let attributedText = NSMutableAttributedString(string: "0", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36)
        ])
        attributedText.append(NSAttributedString(string: "/\(currentCount)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#00459C"),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
        ]))
        medCountLabel.attributedText = attributedText
    }

    // 알림이 울릴 때 호출되는 함수에서 count를 1로 업데이트
    func notificationTriggered() {
        let currentCount = alarmStackView.arrangedSubviews.count
        let updatedMedCount = "1"
        let attributedText = NSMutableAttributedString(string: updatedMedCount, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#9D9D9D"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36)
        ])
        attributedText.append(NSAttributedString(string: "/\(currentCount)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#00459C"),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
        ]))
        medCountLabel.attributedText = attributedText
    }
}

// 알람 뷰를 생성하는 함수
func createAlarmView(name: String, dosage: String, date: String, time: String) -> UIView {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
    containerView.layer.cornerRadius = 12
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor(hex: "#EAECF0").cgColor
    containerView.backgroundColor = UIColor.white  // 표준 흰색 배경색 사용
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    let infoIcon = UIImageView(image: UIImage(systemName: "info.circle.fill"))
    infoIcon.tintColor = UIColor(hex: "#FBBC05")
    infoIcon.translatesAutoresizingMaskIntoConstraints = false
    infoIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
    infoIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    let labelsStackView = UIStackView()
    labelsStackView.axis = .vertical
    labelsStackView.spacing = 4
    labelsStackView.alignment = .leading
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let nameLabel = UILabel()
    nameLabel.text = name
    nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    nameLabel.textColor = UIColor(hex: "#000")
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let dosageLabel = UILabel()
    dosageLabel.text = dosage
    dosageLabel.font = UIFont.systemFont(ofSize: 8, weight: .semibold)
    dosageLabel.textColor = UIColor(hex: "#A1A1A1")
    dosageLabel.translatesAutoresizingMaskIntoConstraints = false
    
    labelsStackView.addArrangedSubview(nameLabel)
    labelsStackView.addArrangedSubview(dosageLabel)
    
    let timeLabel = UILabel()
    timeLabel.text = time
    timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    timeLabel.textColor = .white
    timeLabel.textAlignment = .center
    timeLabel.backgroundColor = UIColor(hex: "#00459C")
    timeLabel.layer.cornerRadius = 4
    timeLabel.layer.masksToBounds = true
    timeLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
    timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(infoIcon)
    stackView.addArrangedSubview(labelsStackView)
    stackView.addArrangedSubview(timeLabel)
    
    containerView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
    ])
    
    return containerView
}

// 알림을 스케줄링하는 함수
func scheduleNotification(name: String, time: String) {
    let content = UNMutableNotificationContent()
    content.title = "Pillter"
    content.body = "약 먹을 시간이예요!"
    content.sound = UNNotificationSound.default
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    if let date = dateFormatter.date(from: time) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error.localizedDescription)")
            } else {
                print("알림이 성공적으로 스케줄링되었습니다.")
            }
        }
    }
}
