//
////  SetAuthorization.swift
////  Pillter
////
////  Created by 이상원 on 9/5/24.
////
//
//import MapKit
//import UIKit
//
//extension LocationController
//{
//
//    func locationGPSCheck() {
//        // 디바이스 자체 위치 서비스 관련 로직
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard CLLocationManager.locationServicesEnabled() else {
//                print("디버깅: 현재 디바이스 위치 서비스 상태는 ❌")
//                self.goToSetting() //여기한번 체크해보자
//                return
//            }
//            print("디버깅: 현재 디바이스의 위치 서비스 상태는 ⭕️")
//            let authStatus = self.locationManager.authorizationStatus
//            self.checkCurrentLocationAuth(authStatus)
//        }
//    }
//
//    private func checkCurrentLocationAuth(_ status: CLAuthorizationStatus) {
//        // 디바이스 확인해서 허용이면, CLAuthorizationStatus를 통해 앱 설정
//        switch status {
//
//        case .notDetermined:
//            print("디버깅: notDetermined")
//            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
//            print("requestWhenInUseAuthorization 실행전")
//            self.locationManager.requestWhenInUseAuthorization()
//            print("requestWhenInUseAuthorization 실행됨")
//            // 권한 요청을 보낸다.
//
////        case .denied: //여기에 alert해서 gotosetting 갈수잇게?
////            // 사용자가 명시적으로 권한을 거부
////            print("디버깅: denied")
////            goToSetting()
////
////        case .restricted:
////            // 안심 자녀 서비스 등 위치 서비스 활성화가 제한된 상태
////            // 시스템 설정에서 설정값을 변경하도록 유도
////            print("디버깅: restricted")
////            goToSetting()
////
//        case .authorizedWhenInUse, .authorizedAlways:
//            print("디버깅: authorizedWhenInUse ")
//            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
//            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
//            //locationManager.startUpdatingLocation()
//
//        default:
//            print("디버깅: default")
//        }
//    }
//
//    func goToSetting() {
//        let alert = UIAlertController(title: "위치 정보 이용", message: "디바이스 설정 ->개인정보 보호에서 위치 서비스를 키세요", preferredStyle: .alert)
//        let setting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
//            if let setting = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(setting)
//            }
//        }
//        alert.addAction(setting)
//        present(alert, animated: true)
//    }
//}
