//
//  HomeKeyboard.swift
//  Pillter
//
//  Created by 이상원 on 9/22/24.
//

import Foundation
import UIKit

extension HomeController
{
    // MARK: 키보드
    @objc func dismissKeyboard() {
        view.endEditing(true) // 키보드 내리기
    }
}
