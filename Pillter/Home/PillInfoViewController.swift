import UIKit
import RealmSwift

class PillInfoViewController: UIViewController {
    
    //여기
    //let realm = DBHelper.shared
    var pillModel = PillModel()
    let helper = DBHelper.shared
    
    var myPageFlag: Bool = false // MyPage 에서 정보를 반환하는 flag
    
    let pillImageView = UIImageView()
    let pillInfoScrollView = UIScrollView()
    var stackView = UIStackView()
    
    var pillImage: UIImage? // 촬영된 이미지를 전달받기 위한 변수
    var pillDataWrapper: PillDataWrapper?
    
    var id: Int!
    var shapeType: String!
    var fDescription: String!
    var bDescription: String!
    var flag: Bool = false //식별정보 유뮤 true면 식별정보 있음
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        loadPillJson()
        //displayPillInfo(id: 1, shapeType: shapeType, fDescription: fDescription, bDescription: bDescription) // 예시로 id: 1인 알약 정보를 표시
        if !flag {
            guard let shapeType = shapeType else { return } //아마 이부분에 let id = id 추가해야할듯
            if shapeType == "타원형" {
                displayPillInfo(id: 38, shapeType: shapeType)
            }
            else if shapeType == "삼각형" {
                displayPillInfo(id: 1, shapeType: shapeType)
            }
            //displayPillInfo(id: 1, shapeType: shapeType)
            print(flag)
            print(shapeType)
        }
        else {
            guard let shapeType = shapeType, let fDescription = fDescription, let bDescription = bDescription else { return }
            if shapeType == "타원형" {
                displayPillInfo(id: 38, shapeType: shapeType, fDescription: fDescription, bDescription: bDescription)
            }
            else if shapeType == "삼각형" {
                displayPillInfo(id: 1, shapeType: shapeType, fDescription: fDescription, bDescription: bDescription)
            }
            //displayPillInfo(id: 1, shapeType: shapeType, fDescription: fDescription, bDescription: bDescription)
            print(flag)
            print(shapeType)
            print(fDescription)
            print(bDescription)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if myPageFlag
        {
            guard let id = id else {
                print(id!)
                return
            }
            displayPillInfo(id: id)
        }
    }
    
    // UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        
        // 파란 반원 뷰 생성
        let blueArcView = UIView()
        blueArcView.layer.backgroundColor = UIColor(red: 0.647, green: 0.753, blue: 0.922, alpha: 1).cgColor
        view.addSubview(blueArcView)
        blueArcView.translatesAutoresizingMaskIntoConstraints = false
        blueArcView.widthAnchor.constraint(equalToConstant: 595).isActive = true
        blueArcView.heightAnchor.constraint(equalToConstant: 595).isActive = true
        blueArcView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -110).isActive = true
        blueArcView.topAnchor.constraint(equalTo: view.topAnchor, constant: -277).isActive = true
        
        // 둥근 모서리 설정
        blueArcView.layer.cornerRadius = 297.5 // 반원의 반지름 크기로 설정
        
        pillImageView.contentMode = .scaleAspectFit
        
        // 스크롤뷰 설정
        pillInfoScrollView.translatesAutoresizingMaskIntoConstraints = false
        pillInfoScrollView.showsVerticalScrollIndicator = true
        pillInfoScrollView.showsHorizontalScrollIndicator = false
        pillInfoScrollView.isDirectionalLockEnabled = true
    }
    
    // UI 레이아웃 설정
    private func layoutUI() {
        pillImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pillImageView)
        view.addSubview(pillInfoScrollView)
        
        NSLayoutConstraint.activate([
            pillImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pillImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pillImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pillImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            pillInfoScrollView.topAnchor.constraint(equalTo: pillImageView.bottomAnchor, constant: 20),
            pillInfoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pillInfoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pillInfoScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }
    
    // UILabel과 구분선(UIView)을 추가하는 함수
    private func addLabelAndSeparator(to stackView: UIStackView, title: String, content: String, titleFont: UIFont, contentFont: UIFont) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = contentFont
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        
        let separator = UIView()
        separator.backgroundColor = .systemBlue
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(separator)
    }
    
    //infoFlag가 false일때
    func displayPillInfo(id: Int, shapeType: String)
    {
        
        //이미지뷰 생성
        makeImage(id: id)
        
        // ID에 해당하는 Pill 데이터를 PillDataWrapper에서 찾기
        if let pillDataWrapper = pillDataWrapper, let pill = pillDataWrapper.PillData.first(where: { $0.id == id && $0.pillType == shapeType }) {
            // 각 항목에 대해 라벨과 구분선을 추가
            addLabelAndSeparator(to: stackView,
                                 title: "이름",
                                 content: pill.pillName,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "구성(함량)",
                                 content: pill.components,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "효과(효능)",
                                 content: pill.efficacy,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "용법(용량)",
                                 content: pill.usageCapacity,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "주의사항",
                                 content: pill.cautionSummation,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            let realm = try! Realm()
            if let existingPill = realm.objects(PillModel.self).filter("id == %@", id).first {
                // 이미 있는 데이터일 경우 업데이트
                try! realm.write {
                    existingPill.pillName = pill.pillName
                    print("이미 존재")
                }
            } else {
                // 데이터가 없으면 삽입
                pillModel = PillModel(id: id, pillName: pill.pillName)
                helper.insertData(pillModel)
            }
            
            helper.readData()

        }
        else {
            let errorLabel = UILabel()
            errorLabel.text = "약에 대한 정보가 없습니다."
            errorLabel.font = UIFont.systemFont(ofSize: 18)
            stackView.addArrangedSubview(errorLabel)
        }
    }
    
    //infoFlag가 true일때
    func displayPillInfo(id: Int, shapeType: String, fDescription: String, bDescription: String) {
        
        //이미지뷰생성
        makeImage(id: id)
        
        // ID에 해당하는 Pill 데이터를 PillDataWrapper에서 찾기
        if let pillDataWrapper = pillDataWrapper, let pill = pillDataWrapper.PillData.first(where: { $0.id == id && $0.pillType == shapeType && $0.frontInfo == fDescription && $0.frontBack == bDescription }) {
            // 각 항목에 대해 라벨과 구분선을 추가
            addLabelAndSeparator(to: stackView,
                                 title: "이름",
                                 content: pill.pillName,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "구성(함량)",
                                 content: pill.components,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "효과(효능)",
                                 content: pill.efficacy,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "용법(용량)",
                                 content: pill.usageCapacity,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "주의사항",
                                 content: pill.cautionSummation,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            //여기
            let realm = try! Realm()
            if let existingPill = realm.objects(PillModel.self).filter("id == %@", id).first {
                // 이미 있는 데이터일 경우 업데이트
                try! realm.write {
                    existingPill.pillName = pill.pillName
                    print("이미 존재")
                }
            } else {
                // 데이터가 없으면 삽입
                pillModel = PillModel(id: id, pillName: pill.pillName)
                helper.insertData(pillModel)
            }
            
            helper.readData()
            
        }
        else {
            let errorLabel = UILabel()
            errorLabel.text = "약에 대한 정보가 없습니다."
            errorLabel.font = UIFont.systemFont(ofSize: 18)
            stackView.addArrangedSubview(errorLabel)
        }
    }
    
    //mypill에서 정보줄때
    func displayPillInfo(id: Int)
    {
        makeImage(id: id)
        print(myPageFlag)
 
        // pillDataWrapper가 nil인 경우를 대비해 로그 추가
        guard let pillDataWrapper = pillDataWrapper else {
            print("pillDataWrapper가 nil입니다.")
            let errorLabel = UILabel()
            errorLabel.text = "약에 대한 정보가 없습니다."
            errorLabel.font = UIFont.systemFont(ofSize: 18)
            stackView.addArrangedSubview(errorLabel)
            return
        }
        
        // ID에 해당하는 Pill 데이터를 찾기
        if let pill = pillDataWrapper.PillData.first(where: { $0.id == id }) {
            // 각 항목에 대해 라벨과 구분선을 추가
            addLabelAndSeparator(to: stackView,
                                 title: "이름",
                                 content: pill.pillName,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "구성(함량)",
                                 content: pill.components,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "효과(효능)",
                                 content: pill.efficacy,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "용법(용량)",
                                 content: pill.usageCapacity,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
            
            addLabelAndSeparator(to: stackView,
                                 title: "주의사항",
                                 content: pill.cautionSummation,
                                 titleFont: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 contentFont: UIFont.systemFont(ofSize: 18))
        }
        else
        {
            let errorLabel = UILabel()
            errorLabel.text = "약에 대한 정보가 없습니다."
            errorLabel.font = UIFont.systemFont(ofSize: 18)
            stackView.addArrangedSubview(errorLabel)
        }
        
        myPageFlag = false
    }
    
    //약 사진
    func makeImage(id: Int)
    {
        // ID에 맞는 이미지를 Asset에서 불러오기
        if let pillImage = UIImage(named: "\(id)") { //UIImage(named: "\(id)")이걸로 교체
            pillImageView.image = pillImage
        } else {
            pillImageView.image = UIImage(systemName: "photo") // 이미지가 없을 경우 기본 이미지 표시
        }
        
        // 기존 스택뷰 제거 후 다시 추가
        pillInfoScrollView.subviews.forEach { $0.removeFromSuperview() } // 기존 뷰 제거
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        pillInfoScrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: pillInfoScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: pillInfoScrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: pillInfoScrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: pillInfoScrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: pillInfoScrollView.widthAnchor)
        ])
        
    }
}
