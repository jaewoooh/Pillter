//챗봇

import UIKit

class ChatBotController: UIViewController {
    
    // 상단 파란색 챗필라벨
    let chatPillLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatPill"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 상단 설명라벨
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "진료는 의사에게\n 약은 챗필에게"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 중간 이미지
    let chatImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Frame 33")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 계속하기 버튼
      let continueBtn: UIButton = {
          let button = UIButton(type: .system)
          
          // "대화하기" 텍스트 설정
          let text = NSMutableAttributedString(string: " 대화하기 ", attributes: [
              .font: UIFont.systemFont(ofSize: 18, weight: .bold),
              .foregroundColor: UIColor.white
          ])
          
          // arrowshape.forward 이미지 설정
          let imageAttachment = NSTextAttachment()
          imageAttachment.image = UIImage(systemName: "arrowshape.turn.up.right.fill")?.withTintColor(.white)
          imageAttachment.bounds = CGRect(x: 40, y: -1, width: 16, height: 16)
          let imageString = NSAttributedString(attachment: imageAttachment)
          
          // 텍스트와 이미지를 결합
          text.append(imageString)
          
          // 버튼 타이틀로 설정
          button.setAttributedTitle(text, for: .normal)
          
          // 버튼 스타일 설정
          button.backgroundColor = .systemBlue
          button.layer.cornerRadius = 25
          button.clipsToBounds = true
          button.translatesAutoresizingMaskIntoConstraints = false
          
          return button
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 그라데이션 배경 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "E6EEFF").cgColor, UIColor(hex: "#FFFFFF").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundColor = .white

        
        // 스택뷰 생성 및 요소 추가
        let stackView = UIStackView(arrangedSubviews: [chatPillLabel, descriptionLabel, chatImage, continueBtn])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        continueBtn.addTarget(self, action: #selector(continueBtnTap), for: .touchUpInside)

        
        setupConstraints(stackView: stackView)

        // 애니메이션을 반복적으로 실행하는 2초 타이머 설정
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(animateButton), userInfo: nil, repeats: true)
        
    }
    
    //계속하기 버튼을 눌렀을때
    @objc func continueBtnTap()
    {
        let chatExplainVC = ChatExplainController()
        navigationController?.pushViewController(chatExplainVC, animated: true)
        print("눌렀음")
    }

    //버튼을 오른쪽으로 살짝 움직이게하는 애니메이션
    @objc func animateButton()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.continueBtn.transform = CGAffineTransform(translationX: 10, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.continueBtn.transform = CGAffineTransform.identity
            }
        }
    }
    
    func setupConstraints(stackView: UIStackView)
    {
        NSLayoutConstraint.activate([
            //스택뷰 설정
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            //버튼 설정
            continueBtn.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            continueBtn.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            continueBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
