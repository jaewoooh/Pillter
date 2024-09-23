import UIKit

class HomeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let pillInfoView = PillInfoViewController()
    
    var pillDataWrapper: PillDataWrapper? //약관련
    var frontText: String? //식별정보 앞내용
    var backText: String? //식별정보 뒤내용
    var shapeType: String? //모양

    
    var pillActionBtn = false // 알약 타입을 눌러야만 다음으로 넘어가짐
    var infoFlag = false //식별정보 생략,저장
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let pillImageView = UIImageView()
    let shapeSelectionView = UIStackView()
    let whiteContainerView = UIView()
    let mainStackView = UIStackView()
    
    // 제약 조건을 조정하기 위한 변수 선언
    var titleTopConstraint: NSLayoutConstraint?
    var titleLeadingConstraint: NSLayoutConstraint?
    var descriptionTopConstraint: NSLayoutConstraint?
    var descriptionLeadingConstraint: NSLayoutConstraint?

    let step1NumberLabel = UILabel()
    let step1Label = UILabel()
    let step1StackView = UIStackView()
    let step1LineView = UIView()

    let step2NumberLabel = UILabel()
    let step2Label = UILabel()
    let step2StackView = UIStackView()
    let step2LineViewBottom = UIView()
    let infoLabel = UILabel()

    let accordionButton = UIButton(type: .system)
    let accordionView = UIStackView()
    let frontLabel = UILabel()
    let frontTextField = UITextField() //식별정보 앞
    let backLabel = UILabel()
    let backTextField = UITextField() //식별정보 뒤
    
    // 생략 및 저장 버튼 추가
    let skipButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    
    let step3NumberLabel = UILabel()
    let step3Label = UILabel()
    let step3StackView = UIStackView()
    let step3CircleView = UIView()
    let step3LineViewBottom = UIView()
    
    let shootButton = UIButton(type: .system)

    var selectedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        loadPillJson()
        
        // 네비게이션 바 타이틀 설정
        setupNavigationBarTitleView()
        // 화면을 터치했을 때 키보드를 숨기기 위한 탭 제스처 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // 네비게이션 바 아이콘 3D작업
    private func setupNavigationBarTitleView() {
            // "Home" 텍스트 설정
            let titleLabel = UILabel()
            titleLabel.text = "Home"
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            titleLabel.textColor = UIColor.black // 텍스트 색상 설정
        
            // GIF 이미지 설정
            let animatedImageView = UIImageView()
            if let gifImage = UIImage.gif(name: "Home_anicon") {
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


    // UI 설정
    private func setupUI() {
        view.backgroundColor = UIColor(hexCode: "#DEDEEB")

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 제목 레이블 설정
        titleLabel.text = " Pillter"
        titleLabel.font = UIFont(name: "ConcertOne-Regular", size: 50)
//        음영효과 코드
//        titleLabel.layer.shadowColor = UIColor.black.cgColor
//        titleLabel.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        titleLabel.layer.shadowOpacity = 0.3
//        titleLabel.layer.shadowRadius = 1

        titleLabel.textColor = UIColor(hexCode: "#22212E")
        titleLabel.textAlignment = .justified

        // 설명 레이블 설정
        descriptionLabel.text = """
        
           ①  알약 타입은 반드시 선택해주세요.
        
           ②  식별 정보 = 정확도 향상!
        
           ③  촬영 버튼 클릭!

        """
        descriptionLabel.font = UIFont(name: "SOYO Maple Bold", size: 10)
        descriptionLabel.textColor = UIColor(hexCode: "#22212E")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
        //        음영효과 코드
//        descriptionLabel.layer.shadowColor = UIColor.black.cgColor
//        descriptionLabel.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        descriptionLabel.layer.shadowOpacity = 0.3
//        descriptionLabel.layer.shadowRadius = 1


        // 알약 이미지 설정
        pillImageView.image = UIImage(named: "pill")
        pillImageView.contentMode = .scaleAspectFit

        // whiteContainerView 설정
        whiteContainerView.backgroundColor = .white
        whiteContainerView.layer.cornerRadius = 32
        whiteContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        whiteContainerView.clipsToBounds = true

        // Step 1 설정
        step1NumberLabel.text = "1"
        step1NumberLabel.textColor = .white
        step1NumberLabel.textAlignment = .center
        step1NumberLabel.backgroundColor = UIColor(hexCode: "#00459C")
        step1NumberLabel.layer.cornerRadius = 14
        step1NumberLabel.clipsToBounds = true
        step1NumberLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true
        step1NumberLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true

        step1Label.text = "알약 타입을 선택해주세요."
        step1Label.textColor = UIColor(hexCode: "#00459C")
        step1Label.font = UIFont(name: "SOYO Maple Bold", size: 15)
        step1Label.textAlignment = .left

        step1StackView.axis = .horizontal
        step1StackView.spacing = 10
        step1StackView.alignment = .leading
        step1StackView.addArrangedSubview(step1NumberLabel)
        step1StackView.addArrangedSubview(step1Label)

        step1LineView.backgroundColor = UIColor(hexCode: "#0067C5")
        step1LineView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        step1LineView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        // Step1 StackView와 Step1 LineView를 별도의 StackView로 구성
        let step1ContainerStackView = UIStackView()
        step1ContainerStackView.axis = .vertical
        step1ContainerStackView.spacing = 4
        step1ContainerStackView.alignment = .leading

        let step1LineContainerView = UIView()
        step1LineContainerView.addSubview(step1LineView)

        step1LineView.translatesAutoresizingMaskIntoConstraints = false
        step1ContainerStackView.addArrangedSubview(step1StackView)
        step1ContainerStackView.addArrangedSubview(step1LineContainerView)

        NSLayoutConstraint.activate([
            step1LineView.centerXAnchor.constraint(equalTo: step1NumberLabel.centerXAnchor),
            step1LineView.topAnchor.constraint(equalTo: step1LineContainerView.topAnchor)
        ])

        // Step 2 설정
        step2NumberLabel.text = "2"
        step2NumberLabel.textColor = UIColor(red: 0, green: 0.404, blue: 0.773, alpha: 1)
        step2NumberLabel.textAlignment = .center
        step2NumberLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 18)

        let step2CircleView = UIView()
        step2CircleView.backgroundColor = .clear
        step2CircleView.layer.cornerRadius = 28 / 2
        step2CircleView.layer.borderWidth = 2
        step2CircleView.layer.borderColor = UIColor(red: 0, green: 0.404, blue: 0.773, alpha: 1).cgColor
        step2CircleView.translatesAutoresizingMaskIntoConstraints = false
        step2CircleView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        step2CircleView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        step2CircleView.addSubview(step2NumberLabel)
        step2NumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            step2NumberLabel.centerXAnchor.constraint(equalTo: step2CircleView.centerXAnchor),
            step2NumberLabel.centerYAnchor.constraint(equalTo: step2CircleView.centerYAnchor)
        ])

        step2Label.text = "식별 정보를 입력해주세요."
        step2Label.textColor = UIColor(hexCode: "#00459C")
        step2Label.font = UIFont(name: "SOYO Maple Bold", size: 15)
        step2Label.textAlignment = .left

        step2StackView.axis = .horizontal
        step2StackView.spacing = 10
        step2StackView.alignment = .leading
        step2StackView.addArrangedSubview(step2CircleView)
        step2StackView.addArrangedSubview(step2Label)

        step2LineViewBottom.backgroundColor = UIColor(hexCode: "#0067C5")
        step2LineViewBottom.widthAnchor.constraint(equalToConstant: 2).isActive = true
        step2LineViewBottom.heightAnchor.constraint(equalToConstant: 18).isActive = true

        // infoLabel 설정
//        infoLabel.text = "식별 정보를 입력해주시면 정확도가 향상됩니다. \n영어, 숫자만 입력해주시고 모든글자를 붙여서 입력해주세요."
        infoLabel.text = "영어, 숫자만 입력해주시고 모든글자를 붙여서 입력해주세요."
        infoLabel.font = UIFont(name: "SOYO Maple Bold", size: 12)
        infoLabel.textColor = UIColor(hexCode: "#777777")
        infoLabel.numberOfLines = 1
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        // Step 3 설정
        step3NumberLabel.text = "3"
        step3NumberLabel.textColor = UIColor(red: 0, green: 0.404, blue: 0.773, alpha: 1)
        step3NumberLabel.textAlignment = .center
        step3NumberLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 18)
        step3NumberLabel.translatesAutoresizingMaskIntoConstraints = false
        step3NumberLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true
        step3NumberLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true

        step3CircleView.backgroundColor = .clear
        step3CircleView.layer.cornerRadius = 28 / 2
        step3CircleView.layer.borderWidth = 2
        step3CircleView.layer.borderColor = UIColor(red: 0, green: 0.404, blue: 0.773, alpha: 1).cgColor
        step3CircleView.translatesAutoresizingMaskIntoConstraints = false
        step3CircleView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        step3CircleView.heightAnchor.constraint(equalToConstant: 28).isActive = true

        step3CircleView.addSubview(step3NumberLabel)
        step3NumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            step3NumberLabel.centerXAnchor.constraint(equalTo: step3CircleView.centerXAnchor),
            step3NumberLabel.centerYAnchor.constraint(equalTo: step3CircleView.centerYAnchor)
        ])

        step3Label.text = "촬영하기"
        step3Label.textColor = UIColor(hexCode: "#00459C")
        step3Label.font = UIFont(name: "SOYO Maple Bold", size: 15)
        step3Label.textAlignment = .left

        step3StackView.axis = .horizontal
        step3StackView.spacing = 10
        step3StackView.alignment = .leading
        step3StackView.addArrangedSubview(step3CircleView)
        step3StackView.addArrangedSubview(step3Label)

        step3LineViewBottom.backgroundColor = UIColor(hexCode: "#0067C5")
        step3LineViewBottom.widthAnchor.constraint(equalToConstant: 2).isActive = true
        step3LineViewBottom.heightAnchor.constraint(equalToConstant: 18).isActive = true

        shootButton.setTitle("촬영하기", for: .normal)
        shootButton.setTitleColor(.white, for: .normal)
        shootButton.backgroundColor = UIColor(hexCode: "#00459C")
        shootButton.layer.cornerRadius = 8
        shootButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        shootButton.translatesAutoresizingMaskIntoConstraints = false
        shootButton.addTarget(self, action: #selector(shootButtonTapped), for: .touchUpInside)

        // 아코디언 버튼 설정
        let chevronDownImage = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal)
        accordionButton.setImage(chevronDownImage, for: .normal)
        accordionButton.semanticContentAttribute = .forceLeftToRight
        accordionButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: -5, bottom: 4, right: 0)
        accordionButton.setTitle("식별 정보(없는 경우 x를 입력해주세요)", for: .normal)
        accordionButton.setTitleColor(.black, for: .normal)
        accordionButton.contentHorizontalAlignment = .left
        accordionButton.titleLabel?.font = UIFont(name: "SOYO Maple Bold", size: 15)
        accordionButton.addTarget(self, action: #selector(toggleAccordion), for: .touchUpInside)
        
        frontLabel.text = "식별 정보 앞"
        frontLabel.font = UIFont.systemFont(ofSize: 14)
        frontLabel.textColor = .black

        frontTextField.borderStyle = .roundedRect
        frontTextField.font = UIFont.systemFont(ofSize: 14)
        frontTextField.placeholder = "User Text"

        backLabel.text = "식별 정보 뒤"
        backLabel.font = UIFont.systemFont(ofSize: 14)
        backLabel.textColor = .black

        backTextField.borderStyle = .roundedRect
        backTextField.font = UIFont.systemFont(ofSize: 14)
        backTextField.placeholder = "User Text"

        // 생략 버튼 설정 수정
        skipButton.setTitle("생략", for: .normal)
        skipButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipButton.layer.cornerRadius = 5
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor(hexCode: "#00459C").cgColor
        skipButton.backgroundColor = .white
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)

        // 저장 버튼 설정
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor(hexCode: "#00459C").cgColor
        saveButton.backgroundColor = .white
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let buttonStackView = UIStackView(arrangedSubviews: [skipButton, saveButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        // 아코디언 뷰 설정
        accordionView.axis = .vertical
        accordionView.spacing = 10
        accordionView.isHidden = true
        accordionView.addArrangedSubview(frontLabel)
        accordionView.addArrangedSubview(frontTextField)
        accordionView.addArrangedSubview(backLabel)
        accordionView.addArrangedSubview(backTextField)
        accordionView.addArrangedSubview(buttonStackView)
        
        // 아코디언 뷰 위아래 선 추가
        let accordionTopLine = UIView()
        accordionTopLine.backgroundColor = UIColor(hexCode: "#CAD0D6")
        accordionTopLine.translatesAutoresizingMaskIntoConstraints = false

        let accordionBottomLine = UIView()
        accordionBottomLine.backgroundColor = UIColor(hexCode: "#CAD0D6")
        accordionBottomLine.translatesAutoresizingMaskIntoConstraints = false

        // Step2 StackView와 Step2 LineView를 별도의 StackView로 구성
        let step2ContainerStackView = UIStackView()
        step2ContainerStackView.axis = .vertical
        step2ContainerStackView.spacing = 6
        step2ContainerStackView.alignment = .leading

        let step2LineContainerViewTop = UIView()

        let step2LineContainerViewBottom = UIView()
        step2LineContainerViewBottom.addSubview(step2LineViewBottom)
        
        // infoLabel 추가
        let infoLabelContainerView = UIView()
        infoLabelContainerView.addSubview(infoLabel)
        infoLabelContainerView.translatesAutoresizingMaskIntoConstraints = false

        step2LineViewBottom.translatesAutoresizingMaskIntoConstraints = false
        step3LineViewBottom.translatesAutoresizingMaskIntoConstraints = false

        step2ContainerStackView.addArrangedSubview(step2LineContainerViewTop)
        step2ContainerStackView.addArrangedSubview(step2StackView)
        step2ContainerStackView.addArrangedSubview(step2LineContainerViewBottom)
        step2ContainerStackView.addArrangedSubview(infoLabelContainerView)
        step2ContainerStackView.addArrangedSubview(accordionTopLine)
        step2ContainerStackView.addArrangedSubview(accordionButton)
        step2ContainerStackView.addArrangedSubview(accordionView)
        step2ContainerStackView.addArrangedSubview(accordionBottomLine)
        
        // Step3 StackView와 Step3 LineView를 별도의 StackView로 구성
        let step3ContainerStackView = UIStackView()
        step3ContainerStackView.axis = .vertical
        step3ContainerStackView.spacing = 6
        step3ContainerStackView.alignment = .leading

        let step3LineContainerViewTop = UIView()

        let step3LineContainerViewBottom = UIView()
        step3LineContainerViewBottom.addSubview(step3LineViewBottom)

        step3ContainerStackView.addArrangedSubview(step3LineContainerViewTop)
        step3ContainerStackView.addArrangedSubview(step3StackView)
        step3ContainerStackView.addArrangedSubview(step3LineContainerViewBottom)

        NSLayoutConstraint.activate([
            step2LineViewBottom.centerXAnchor.constraint(equalTo: step2CircleView.centerXAnchor),
            step2LineViewBottom.topAnchor.constraint(equalTo: step2CircleView.bottomAnchor, constant: 10),
            step3LineViewBottom.centerXAnchor.constraint(equalTo: step3CircleView.centerXAnchor),
            step3LineViewBottom.topAnchor.constraint(equalTo: step3CircleView.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: infoLabelContainerView.leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: infoLabelContainerView.trailingAnchor, constant: -10),
            infoLabel.topAnchor.constraint(equalTo: infoLabelContainerView.topAnchor, constant: 30), // infoLabel의 위 여백 추가
            infoLabel.bottomAnchor.constraint(equalTo: infoLabelContainerView.bottomAnchor, constant: -10), // infoLabel의 아래 여백 추가
            accordionTopLine.heightAnchor.constraint(equalToConstant: 1),
            accordionTopLine.leadingAnchor.constraint(equalTo: step2ContainerStackView.leadingAnchor),
            accordionTopLine.trailingAnchor.constraint(equalTo: step2ContainerStackView.trailingAnchor),
            accordionButton.leadingAnchor.constraint(equalTo: step2ContainerStackView.leadingAnchor, constant: 10),
            accordionButton.trailingAnchor.constraint(equalTo: step2ContainerStackView.trailingAnchor, constant: -10),
            accordionButton.heightAnchor.constraint(equalToConstant: 40),
            accordionView.leadingAnchor.constraint(equalTo: step2ContainerStackView.leadingAnchor, constant: 10),
            accordionView.trailingAnchor.constraint(equalTo: step2ContainerStackView.trailingAnchor, constant: -10),
            accordionBottomLine.heightAnchor.constraint(equalToConstant: 1),
            accordionBottomLine.leadingAnchor.constraint(equalTo: step2ContainerStackView.leadingAnchor),
            accordionBottomLine.trailingAnchor.constraint(equalTo: step2ContainerStackView.trailingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 60),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            buttonStackView.trailingAnchor.constraint(equalTo: step2ContainerStackView.trailingAnchor, constant: -10),
            
        ])

        shapeSelectionView.axis = .vertical
        shapeSelectionView.distribution = .fillEqually
        shapeSelectionView.spacing = 15

        setupShapeButtons()

        // mainStackView 설정
        mainStackView.axis = .vertical
        mainStackView.spacing = 30
        mainStackView.alignment = .fill

        mainStackView.addArrangedSubview(step1ContainerStackView)
        mainStackView.addArrangedSubview(shapeSelectionView)
        mainStackView.setCustomSpacing(60, after: shapeSelectionView)
        mainStackView.addArrangedSubview(step2ContainerStackView)
        mainStackView.addArrangedSubview(step3ContainerStackView)
        mainStackView.addArrangedSubview(shootButton)

        whiteContainerView.addSubview(mainStackView)
        contentView.addSubview(whiteContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(pillImageView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        whiteContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        pillImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    // 아코디언 버튼 클릭 이벤트 처리
    @objc private func toggleAccordion() {
        accordionView.isHidden.toggle()
        let imageName = accordionView.isHidden ? "chevron.down" : "chevron.up"
        accordionButton.setImage(UIImage(systemName: imageName), for: .normal)
        accordionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }

    // 생략 버튼 클릭 이벤트 처리
    @objc private func skipButtonTapped() {
        updateButtonStyles(isSaveButtonSelected: false)
        updateStep2Style()
        frontTextField.isEnabled = true
        backTextField.isEnabled = true
        
        frontTextField.text = ""
        backTextField.text = ""
        infoFlag = false
        print(infoFlag)
    }

    // 저장 버튼 클릭 이벤트 처리
    @objc private func saveButtonTapped() {
        updateButtonStyles(isSaveButtonSelected: true)
        updateStep2Style()
        frontTextField.isEnabled = true
        backTextField.isEnabled = true
        frontText = frontTextField.text
        backText = backTextField.text
        
        if (frontText?.isEmpty == false || backText?.isEmpty == false) {
            infoFlag = true
            print(infoFlag)
            print("Front Text: \(frontText ?? "")")
            print("Back Text: \(backText ?? "")")
        } else {
            infoFlag = false
            print(infoFlag)
        }
        
    }

    // 촬영하기 버튼 클릭 이벤트 처리
    @objc private func shootButtonTapped() {
        if pillActionBtn {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            // 앨범 버튼 추가
            let albumButton = UIBarButtonItem(title: "앨범", style: .plain, target: self, action: #selector(openPhotoLibrary))
            imagePicker.navigationItem.rightBarButtonItem = albumButton
            
            present(imagePicker, animated: true, completion: nil)
        }
        pillActionBtn = false
        updateStep3Style()
    }

    @objc private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate 메서드 구현
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if info[.originalImage] is UIImage {
            // 촬영된 또는 선택된 이미지를 다음 화면에 전달하고 화면 전환
            let pillInfoVC = PillInfoViewController()
            //pillInfoVC.pillImage = image
            pillInfoVC.fDescription = frontText
            pillInfoVC.bDescription = backText
            pillInfoVC.flag = infoFlag
            pillInfoVC.shapeType = shapeType
            navigationController?.pushViewController(pillInfoVC, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // UI 레이아웃 배치
    private func layoutUI() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: pillImageView.leadingAnchor, constant: -10),

            pillImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 10),
            pillImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            pillImageView.heightAnchor.constraint(equalToConstant: 140),
            pillImageView.widthAnchor.constraint(equalToConstant: 140),

            whiteContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            whiteContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            whiteContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            whiteContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            mainStackView.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: whiteContainerView.bottomAnchor, constant: -60),
            
            shootButton.heightAnchor.constraint(equalToConstant: 50),
            shootButton.topAnchor.constraint(equalTo: step3LineViewBottom.bottomAnchor, constant: 10),
            shootButton.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: 20),
            shootButton.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -20)
        ])
        // Step 2 간격 조정
            mainStackView.setCustomSpacing(20, after: shapeSelectionView)  // 간격을 줄여 Step 2를 위로 올림
    }

    // 알약 모양 버튼 설정
    private func setupShapeButtons() {
        let shapes = [
            ("원형", "CirclePill"),
            ("타원형", "OvalPill"),
            ("삼각형", "TrianglePill"),
            ("사각형", "SquarePill"),
            ("오각형", "PentagonPill"),
            ("육각형", "HexagonPill")
        ]

        let firstRowStackView = UIStackView()
        firstRowStackView.axis = .horizontal
        firstRowStackView.distribution = .fillEqually
        firstRowStackView.spacing = 20

        let secondRowStackView = UIStackView()
        secondRowStackView.axis = .horizontal
        secondRowStackView.distribution = .fillEqually
        secondRowStackView.spacing = 20

        for (index, shape) in shapes.enumerated() {
            let button = createShapeButton(with: shape.0, imageName: shape.1)
            
            button.accessibilityIdentifier = shape.0

            if index < 3 {
                firstRowStackView.addArrangedSubview(button)
            } else {
                secondRowStackView.addArrangedSubview(button)
            }
        }

        shapeSelectionView.addArrangedSubview(firstRowStackView)
        shapeSelectionView.addArrangedSubview(secondRowStackView)
    }

    // 알약 모양 버튼 생성
    private func createShapeButton(with title: String, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 104.32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 75.067).isActive = true
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#E5E5E5").cgColor
        button.backgroundColor = .white

        // 이미지 설정
        let imageView = UIImageView(image: UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(hexCode: "#444444") // 원하는 색상으로 설정

        // 라벨 설정
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false

        // 스택 뷰에 이미지와 라벨 추가
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 25), // 버튼 안에 있는 알약 이미지 크기
            imageView.heightAnchor.constraint(equalToConstant: 25)
        ])

        button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)

        return button
    }
    
    // 버튼 스타일 업데이트
    private func updateButtonStyles(isSaveButtonSelected: Bool) {
        if isSaveButtonSelected {
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.backgroundColor = UIColor(hexCode: "#00459C")
            skipButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
            skipButton.backgroundColor = .white
        } else {
            saveButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
            saveButton.backgroundColor = .white
            skipButton.setTitleColor(.white, for: .normal)
            skipButton.backgroundColor = UIColor(hexCode: "#00459C")
        }
    }
    
    // Step2 스타일 업데이트
    private func updateStep2Style() {
        let step2CircleView = step2StackView.arrangedSubviews.first!
        step2CircleView.backgroundColor = UIColor(red: 0, green: 0.271, blue: 0.612, alpha: 1)
        step2NumberLabel.textColor = .white
        step2NumberLabel.text = "✔︎"
    }

    // Step3 스타일 업데이트
    private func updateStep3Style() {
        step3NumberLabel.text = "✔︎"
        let step3CircleView = step3StackView.arrangedSubviews.first!
        step3CircleView.backgroundColor = UIColor(red: 0, green: 0.271, blue: 0.612, alpha: 1)
        step3NumberLabel.textColor = .white
    }

    // 버튼 클릭 이벤트 처리
    @objc private func shapeButtonTapped(_ sender: UIButton) {
        // 이전에 선택된 버튼 스타일 초기화
        if let previousButton = selectedButton {
            if previousButton != sender {
                resetButtonStyle(previousButton)
            }
        }

        // 선택된 버튼 스타일 적용
        applySelectedStyle(to: sender)

        // step1NumberLabel을 체크 표시로 변경
        step1NumberLabel.text = "✔︎"
        
        // 선택된 버튼의 모양 이름을 shapeType에 저장
        shapeType = sender.accessibilityIdentifier
        print(shapeType!)
        // 현재 선택된 버튼으로 설정
        selectedButton = sender
        
        pillActionBtn = true
    }

    private func resetButtonStyle(_ button: UIButton) {
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#E5E5E5").cgColor
        button.layer.shadowColor = UIColor.clear.cgColor
        button.layer.shadowOpacity = 0
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 0
    }

    private func applySelectedStyle(to button: UIButton) {
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 32/255, green: 142/255, blue: 210/255, alpha: 0.78).cgColor
        button.layer.shadowColor = UIColor(red: 32/255, green: 142/255, blue: 210/255, alpha: 0.58).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 8, height: 6)
        button.layer.shadowRadius = 4
    }

}
