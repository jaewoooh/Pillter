////
////  LocationKeyBoard.swift
////  Pillter
////
////  Created by 이상원 on 8/30/24.
////
//
//import UIKit
//
//extension LocationController
//{
//    // MARK: 키보드
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    //키보드 열고닫기
//    func setupKeyboardEvent() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillShow),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillHide),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
//    }
//
//    @objc func keyboardWillShow(_ sender: Notification) {
//        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
//        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardHeight = keyboardFrame.cgRectValue.height
//
//        // 이 조건을 넣어주지 않으면, 각각의 텍스트필드마다 keyboardWillShow 동작이 실행되므로 아래와 같은 현상이 발생
//        if view.frame.origin.y == 0 {
//            view.frame.origin.y -= keyboardHeight
//        }
//    }
//
//    @objc func keyboardWillHide(_ sender: Notification) {
//        if view.frame.origin.y != 0 {
//            view.frame.origin.y = 0
//        }
//    }
//
//    // 버튼 눌림 애니메이션
//    @objc func buttonPressed(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2) {
//            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            sender.alpha = 0.7
//        }
//    }
//
//    // 버튼 떼었을 때 애니메이션
//    @objc func buttonReleased(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2) {
//            sender.transform = .identity
//            sender.alpha = 1.0
//        }
//    }
//}
