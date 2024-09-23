import UIKit

class ZoomController: UIViewController {

    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    var currentZoomLevel: Double = 1000 // 기본 줌 레벨
    
    var onZoomChange: ((Double) -> Void)? // 줌 값이 변경될 때 호출될 클로저

    override func viewDidLoad() {
        super.viewDidLoad()

        // 줌 인/아웃 버튼 추가
        setupZoomButtons()
    }

    // 줌 인/아웃 버튼 추가
    func setupZoomButtons() {
        // 줌 인 버튼 생성
        zoomInButton = UIButton(type: .system)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        zoomInButton.setTitleColor(.black, for: .normal)
        zoomInButton.backgroundColor = UIColor(white: 0.95, alpha: 1) // 연한 배경색
        zoomInButton.layer.cornerRadius = 10 // 둥근 모서리
        zoomInButton.layer.borderColor = UIColor.lightGray.cgColor
        zoomInButton.layer.borderWidth = 0.5
        zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)

        // 줌 아웃 버튼 생성
        zoomOutButton = UIButton(type: .system)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        zoomOutButton.setTitleColor(.black, for: .normal)
        zoomOutButton.backgroundColor = UIColor(white: 0.95, alpha: 1) // 연한 배경색
        zoomOutButton.layer.cornerRadius = 10 // 둥근 모서리
        zoomOutButton.layer.borderColor = UIColor.lightGray.cgColor
        zoomOutButton.layer.borderWidth = 0.5
        zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)

        // 버튼들을 스택 뷰로 수직 배치
        let stackView = UIStackView(arrangedSubviews: [zoomInButton, zoomOutButton])
        stackView.axis = .vertical
        stackView.spacing = 16 // 버튼 사이 여백
        stackView.distribution = .fillEqually

        // 스택 뷰를 화면에 추가
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            stackView.widthAnchor.constraint(equalToConstant: 50),
            stackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    // 줌 인 기능
    @objc func zoomIn() {
        currentZoomLevel = max(currentZoomLevel / 2, 500) // 최소 줌 레벨 500
        onZoomChange?(currentZoomLevel)
    }

    // 줌 아웃 기능
    @objc func zoomOut() {
        currentZoomLevel = min(currentZoomLevel * 2, 10000) // 최대 줌 레벨 10000
        onZoomChange?(currentZoomLevel)
    }
}
