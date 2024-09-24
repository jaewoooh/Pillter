import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var searchTextField: UITextField!
    var onSearch: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        let searchView = UIView()
        searchView.layer.cornerRadius = 12
        searchView.clipsToBounds = true
        searchView.backgroundColor = UIColor.white
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = UIColor.gray
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        searchTextField = UITextField()
        searchTextField.placeholder = "지하철역, 약국명으로 검색"
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .clear
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchTextField.delegate = self
        
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
        
        self.view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            onSearch?(query)
        }
        textField.resignFirstResponder()
        return true
    }
}
