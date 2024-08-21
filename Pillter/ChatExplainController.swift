import UIKit
import SwiftUI
import GoogleGenerativeAI

class ChatExplainController: UIViewController, UITextFieldDelegate {
    
    private var nextBtnAble = false
    
    //상단 설명이미지  다른곳에서 수정해야하면 let으로 변경해도됨 아래 변수 모두
    private lazy var explainImg: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Frame 43")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //상단 설명예시버튼 1
    private lazy var explain1Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("배 아플 때 무슨 약 먹어야 돼?", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //상단 설명예시버튼 2
    private lazy var explain2Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("타이레놀 부작용 알려줘!", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //상단 설명예시버튼 3
    private lazy var explain3Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("기침이 계속 나는데 무슨 약을 먹어야 돼?", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //어려운말 번역이미지
    private lazy var translateImg: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Frame 47")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //중단 번역예시버튼 1
    private lazy var translate1Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("경구 투여가 무슨 뜻이야?", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //중단 번역예시버튼 2
    private lazy var translate2Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("장기 연용은 무슨 뜻이야?", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //중단 번역예시버튼 3
    private lazy var translate3Btn: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("수진자와 수검자 뜻 알려줘!", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 하단 텍스트 입력 컨테이너 뷰
    private lazy var chatInputContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 하단 텍스트 입력 필드
    let chatInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Hello chaPill !"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.tintColor = .black
        textField.borderStyle = .none
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 5)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 하단 보내기 버튼
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // 네비게이션 바 커스텀 뷰 설정
        setupNavigationBar()
        // 커스텀 뒤로가기 버튼 설정
        setupCustomBackButton()
        //스택뷰 설정
        setupStackViews()
        setupKeyboardEvent()
        
        sendButton.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        explain1Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        explain2Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        explain3Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        translate1Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        translate2Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        translate3Btn.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        
        chatInputField.delegate = self
    }
    
    func setupNavigationBar()
    { //네비게이션바에 이미지들
        // 부모 뷰 생성
        let titleView = UIView()
        
        // 이미지 뷰 생성
        let imageView = UIImageView(image: UIImage(named: "blue-robot"))
        imageView.contentMode = .scaleAspectFit
        
        // 레이블 생성
        let titleLabel = UILabel()
        titleLabel.text = "ChatPill"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.systemBlue
        
        // 스택 뷰에 이미지와 레이블 추가
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        titleView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor), //, constant: -175
            stackView.topAnchor.constraint(equalTo: titleView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        // 네비게이션 아이템에 커스텀 뷰 설정
        self.navigationItem.titleView = titleView
    }
    
    func setupCustomBackButton()
    { //뒤로가기 버튼 변경
        // 커스텀 뒤로가기 버튼 생성
        let backButton = UIButton(type: .system)
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal) // <- 기호 이미지 설정
        backButton.setTitle("", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonTapped()
    {
        self.navigationController?.popViewController(animated: true)
        print("뒤로가기")
    }
    
    func setupStackViews() {
        // 상단 설명 스택뷰
        let upStackView = UIStackView(arrangedSubviews: [explainImg, explain1Btn, explain2Btn, explain3Btn])
        upStackView.axis = .vertical
        upStackView.spacing = 10
        upStackView.alignment = .center
        upStackView.distribution = .fillProportionally // 간격 동일하게 설정
        upStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(upStackView)
        
        // 중단 번역 스택뷰
        let downStackView = UIStackView(arrangedSubviews: [translateImg, translate1Btn, translate2Btn, translate3Btn])
        downStackView.axis = .vertical
        downStackView.spacing = 10
        downStackView.alignment = .center
        downStackView.distribution = .fillProportionally // 간격 동일하게 설정
        downStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downStackView)
        
        // chatInputContainer에 chatInputField와 sendButton 추가
        chatInputContainer.addSubview(chatInputField)
        chatInputContainer.addSubview(sendButton)
        
        // 전체 스택뷰
        let mainStackView = UIStackView(arrangedSubviews: [upStackView, downStackView, chatInputContainer])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        setupConstraints(upStackView: upStackView, downStackView: downStackView, chatInputContainer: chatInputContainer, mainStackView: mainStackView)
    }

    func setupConstraints(upStackView: UIStackView, downStackView: UIStackView, chatInputContainer: UIView, mainStackView: UIStackView) {
        let buttonHeight: CGFloat = 40 // 각 버튼의 높이를 동일하게 설정
        
        NSLayoutConstraint.activate([
            // 전체 스택뷰 제약 조건
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            // 상단 설명 스택뷰 제약 조건
            upStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            upStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            // 중단 번역 스택뷰 제약 조건
            downStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            downStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            // 하단 텍스트 입력 컨테이너 제약 조건
            chatInputContainer.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            chatInputContainer.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            chatInputContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // 버튼 높이 및 너비 제약 조건
            explain1Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            explain1Btn.leadingAnchor.constraint(equalTo: upStackView.leadingAnchor, constant: 20),
            explain1Btn.trailingAnchor.constraint(equalTo: upStackView.trailingAnchor, constant: -20),
            
            explain2Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            explain2Btn.leadingAnchor.constraint(equalTo: upStackView.leadingAnchor, constant: 20),
            explain2Btn.trailingAnchor.constraint(equalTo: upStackView.trailingAnchor, constant: -20),
            
            explain3Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            explain3Btn.leadingAnchor.constraint(equalTo: upStackView.leadingAnchor, constant: 20),
            explain3Btn.trailingAnchor.constraint(equalTo: upStackView.trailingAnchor, constant: -20),
            
            translate1Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            translate1Btn.leadingAnchor.constraint(equalTo: downStackView.leadingAnchor, constant: 20),
            translate1Btn.trailingAnchor.constraint(equalTo: downStackView.trailingAnchor, constant: -20),
            
            translate2Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            translate2Btn.leadingAnchor.constraint(equalTo: downStackView.leadingAnchor, constant: 20),
            translate2Btn.trailingAnchor.constraint(equalTo: downStackView.trailingAnchor, constant: -20),
            
            translate3Btn.heightAnchor.constraint(equalToConstant: buttonHeight),
            translate3Btn.leadingAnchor.constraint(equalTo: downStackView.leadingAnchor, constant: 20),
            translate3Btn.trailingAnchor.constraint(equalTo: downStackView.trailingAnchor, constant: -20),
            
            // 하단 텍스트 입력 필드 및 버튼 제약 조건
            chatInputField.leadingAnchor.constraint(equalTo: chatInputContainer.leadingAnchor, constant: 10),
            chatInputField.centerYAnchor.constraint(equalTo: chatInputContainer.centerYAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: chatInputContainer.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: chatInputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 20),
            sendButton.heightAnchor.constraint(equalToConstant: 20),
            
            chatInputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
        ])
    }



    @objc func nextBtn()
    {
        if chatInputField.hasText {
            guard let message = chatInputField.text else { return }
            let appView = UIHostingController(rootView: ChatView(externalMessage: message))
            navigationController?.pushViewController(appView, animated: true)
            print(message)
            chatInputField.text = ""
        }

    }
    
//    @objc func startEditing(sender: UITextField, stackView: UIStackView)
//    {
//        stackView.
//    }
    
    @objc func handleButtonTap(_ sender: UIButton) {
        guard let message = sender.title(for: .normal) else { return }
        let appView = UIHostingController(rootView: ChatView(externalMessage: message))
        navigationController?.pushViewController(appView, animated: true)
        print(message)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //키보드 열고닫기
    func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        // ⭐️ 이 조건을 넣어주지 않으면, 각각의 텍스트필드마다 keyboardWillShow 동작이 실행되므로 아래와 같은 현상이 발생
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}
