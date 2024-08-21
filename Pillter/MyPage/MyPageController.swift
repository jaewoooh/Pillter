
//  MyPageController.swift
//  pillter
//
//  Created by 오재우 on 7/23/24.
//

import UIKit

class MyPageController: UIViewController {

    // UI Components
    let titleLabel = UILabel()
    let emptyStateImageView = UIImageView()
    let emptyStateMessageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        
        //네비게이션바 애니메이션효과 추가
        setupNavigationBarTitleView()
    }

    //네비게이션바 애니메이션 효과 기능 함수
    private func setupNavigationBarTitleView() {
        // "Pill List" 텍스트 설정
        let titleLabel = UILabel()
        titleLabel.text = "Pill List"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor.black // 텍스트 색상 설정
        
        // GIF 이미지 설정
        let animatedImageView = UIImageView()
        if let gifImage = UIImage.gif(name: "Pill_anicon") {
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

    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Title Label Configuration
        titleLabel.text = "나의 약통"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left // Change to left alignment
        
        // Empty State Image View Configuration
        emptyStateImageView.image = UIImage(named: "mypage")
        emptyStateImageView.contentMode = .scaleAspectFit
        
        // Empty State Message Label Configuration
        emptyStateMessageLabel.text = """
        이 프로젝트에는 아직 작업이 없습니다.
        작업을 추가해 주세요.
        """
        emptyStateMessageLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateMessageLabel.textColor = .black
        emptyStateMessageLabel.textAlignment = .center
        emptyStateMessageLabel.numberOfLines = 0
    }

    private func layoutUI() {
        view.addSubview(titleLabel)
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateMessageLabel)
        
        // Title Label Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Empty State Image View Constraints
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 150),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Empty State Message Label Constraints
        emptyStateMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateMessageLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

