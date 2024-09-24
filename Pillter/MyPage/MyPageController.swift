
//  MyPageController.swift
//  pillter
//
//  Created by 오재우 on 7/23/24.
//

import UIKit
import RealmSwift

class MyPageController: UIViewController {

    
    // UI 구성
    var titleLabel: UILabel =
    {
        let titleLabel = UILabel()
        
        titleLabel.text = "나의 약통"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        return titleLabel
    }()

    var tableView = UITableView()
    var pillData: Results<PillModel>?
    let realm = DBHelper.shared

    let emptyStateImageView = UIImageView()
    let emptyStateMessageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
//        if ((pillData?.isEmpty) != nil) {
//            setupUI()
//        }
//        else {
//            setTableView()
//            setupTableView() //테이블뷰 setup
//            realm.readData()
//            tableView.reloadData()
//        }
        setTableView()
        setupTableView() //테이블뷰 setup
        realm.readData()
        fetchDataFromRealm()
        //tableView.reloadData()
        
        //네비게이션바 애니메이션효과 추가
        setupNavigationBarTitleView()
        
        // Long Press Gesture 추가
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromRealm()
        //tableView.reloadData()
    }
    
    private func fetchDataFromRealm()
    {
        let realmInstance = try! Realm()
        pillData = realmInstance.objects(PillModel.self)
        tableView.reloadData()
    }
    //네비게이션바 애니메이션 효과 기능 함수
    private func setupNavigationBarTitleView() {
        // "Pill List" 텍스트 설정
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Pill List"
        navTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        navTitleLabel.textColor = UIColor.black // 텍스트 색상 설정
        
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
        let stackView = UIStackView(arrangedSubviews: [navTitleLabel, animatedImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8 // 텍스트와 이미지 간의 간격 설정
        stackView.alignment = .center
        
        // 스택 뷰를 네비게이션 바의 타이틀 뷰로 설정
        self.navigationItem.titleView = stackView
    }
    
    //테이블 뷰가 비어있으면 나타나는 함수
    private func setupUI() {
        view.backgroundColor = .white

        // Empty State Image View Configuration
        emptyStateImageView.image = UIImage(named: "mypage")
        emptyStateImageView.contentMode = .scaleAspectFit
        
        // Empty State Message Label Configuration
        emptyStateMessageLabel.text = "검색한 약이 없습니다."
        emptyStateMessageLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateMessageLabel.textColor = .black
        emptyStateMessageLabel.textAlignment = .center
        emptyStateMessageLabel.numberOfLines = 0
        
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateMessageLabel)
        
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
    
    //테이블 뷰가 존재하면 나타나는 함수
    private func setTableView()
    {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        tableView.reloadData()
        

    }
    
    // Long Press를 처리하는 함수
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // 선택된 셀에 대한 PillModel 데이터를 가져옴
                if let pill = pillData?[indexPath.row] {
                    // 경고창을 띄워 사용자가 삭제 여부를 확인하도록 함
                    let alert = UIAlertController(title: "삭제", message: "\(pill.pillName)을(를) 삭제하시겠습니까?", preferredStyle: .alert)
                    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                        // Realm에서 데이터 삭제
                        self.realm.deleteData(pill.id)
                        self.fetchDataFromRealm() // 데이터 삭제 후 다시 가져옴
                        //self.tableView.reloadData() // 테이블 뷰 갱신
                        self.realm.readData()
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    
                    alert.addAction(deleteAction)
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

