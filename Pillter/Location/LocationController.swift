import UIKit
import CoreLocation
import MapKit

class LocationController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private var mapView: MKMapView!
    
    private let mapTedxtField: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "약국 검색..."
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .none
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = false
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView = MKMapView(frame: self.view.frame)
        view.addSubview(mapView)
        
        mapView.addSubview(mapTedxtField)
        
        mapFunction()
        setConstraints()
    }
  
    func mapFunction()
    {
        
        
    }
    
    func setConstraints()
    {
        NSLayoutConstraint.activate([
            mapTedxtField.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapTedxtField.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mapTedxtField.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            mapTedxtField.widthAnchor.constraint(equalToConstant: 200),
            mapTedxtField.heightAnchor.constraint(equalToConstant: 40)
        ])
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

        // 이 조건을 넣어주지 않으면, 각각의 텍스트필드마다 keyboardWillShow 동작이 실행되므로 아래와 같은 현상이 발생
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


