import UIKit

class PillInfoViewController: UIViewController {
    
    let pillImageView = UIImageView()
    let pillInfoLabel = UILabel()
    
    var pillImage: UIImage? // 촬영된 이미지를 전달받기 위한 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        displayPillInfo() // 알약 정보 표시 로직을 추가
    }
    
    // UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        
        pillImageView.contentMode = .scaleAspectFit
        pillImageView.image = pillImage // 전달받은 이미지로 설정
        
        pillInfoLabel.text = "알약 정보가 여기에 표시됩니다."
        pillInfoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        pillInfoLabel.textColor = .black
        pillInfoLabel.numberOfLines = 0
        pillInfoLabel.textAlignment = .center
    }
    
    // UI 레이아웃 설정
    private func layoutUI() {
        pillImageView.translatesAutoresizingMaskIntoConstraints = false
        pillInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pillImageView)
        view.addSubview(pillInfoLabel)
        
        NSLayoutConstraint.activate([
            pillImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pillImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pillImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pillImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            pillInfoLabel.topAnchor.constraint(equalTo: pillImageView.bottomAnchor, constant: 20),
            pillInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pillInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func displayPillInfo() {
        // 알약 정보 표𓂻𓂭  로직을 여𓅿𓂭에 추가합니다.
        // 예: ⍤⃝𓂭미지 분석 후 결과를 표𓂻𓂭 하는 방법 등
    }
}
