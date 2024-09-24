import UIKit

class NavigationBarController {
    
    // 네비게이션 바의 타이틀 뷰를 설정하는 메서드
    func setupNavigationBarTitleView(for navigationItem: UINavigationItem) {
        // "Pharmacy" 텍스트 설정
        let titleLabel = UILabel()
        titleLabel.text = "My Pharmacy"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = UIColor.black // 텍스트 색상 설정
        
        // 3D 아이콘 설정 (GIF 이미지)
        let animatedImageView = UIImageView()
        if let gifImage = UIImage.gif(name: "Pharmacy_anicon") {
            animatedImageView.image = gifImage
            animatedImageView.contentMode = .scaleAspectFit
            
            // 이미지 크기 설정
            animatedImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            animatedImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        // 스택 뷰 설정 (Label과 ImageView를 수평으로 배치)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, animatedImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8 // 텍스트와 이미지 간의 간격 설정
        stackView.alignment = .center
        
        // 스택 뷰를 네비게이션 바의 타이틀 뷰로 설정
        navigationItem.titleView = stackView
    }
    
    // 네비게이션 바의 배경 및 텍스트 색상을 설정하는 메서드
    func setupNavigationBarAppearance(for navigationController: UINavigationController?) {
        // 배경 색상 설정
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.isTranslucent = false  // 투명 효과 제거
            
        // 네비게이션 바 텍스트 및 버튼 색상 설정
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.tintColor = .black // 버튼 색상도 검은색으로 설정
    }
}
