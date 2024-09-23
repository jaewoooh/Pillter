//
//  SearchViewController.swift
//  pillter
//
//  Created by 안희영 on 9/22/24.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var searchTextField: UITextField!
    var onSearch: ((String) -> Void)? // 검색어를 전달하기 위한 클로저
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    // 검색창 UI 설정
    func setupSearchBar() {
        let searchView = UIView()
        searchView.layer.cornerRadius = 12
        searchView.clipsToBounds = true
        searchView.backgroundColor = UIColor.white

        // "magnifyingglass" 이미지 뷰 추가
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor.gray
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        // UITextField를 검색창에 추가
        searchTextField = UITextField()
        searchTextField.placeholder = "지하철역, 약국명으로 검색"
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .clear
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchTextField.delegate = self

        // 스택 뷰를 사용하여 이미지와 텍스트 필드를 왼쪽에 정렬
        let stackView = UIStackView(arrangedSubviews: [imageView, searchTextField])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        searchView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16).isActive = true

        // 뷰에 검색창 추가 및 Auto Layout 설정
        self.view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    // 사용자가 검색어를 입력한 후 검색 버튼을 눌렀을 때 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            onSearch?(query)  // 검색어를 전달
        }
        textField.resignFirstResponder()
        return true
    }
}
