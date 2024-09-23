//
////  LocationManagerCustom.swift
////  Pillter
////
////  Created by 이상원 on 9/8/24.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//extension LocationController
//{
//
//    // 사용자 위치가 업데이트되면 호출되는 메서드
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let userLocation = locations.last else {
//            print("사용자 위치를 받아오지 못했습니다.")
//            return
//        }
//
//        print("사용자 위치 업데이트: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
//
//        //locationManager.startUpdatingLocation() //실시간 위치, 이동했을때 문제가 발생한다면 이부분 삭제
//
//        //지도에서 기본 오버레이 제거
//        if let existingOverlay = circleOverlay {
//            mapView.removeOverlay(existingOverlay)
//        }
//
//        //새로운 오버레이 추가
//        circleOverlay = MKCircle(center: userLocation.coordinate, radius: 300) //300m
//        mapView.addOverlay(circleOverlay!)
//
//        setMapRegion(location: userLocation, distance: 300) // 500m 범위로 지도 이동
//
//
//        // json으로 불러온 데이터 보여주기
//        loadPharmacyData()
//        //locationManager.stopUpdatingLocation()
//    }
//
//    //바라보는 방향관련
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//
//        // 사용자 현재 위치 가져오기
//        guard let userLocation = locationManager.location else {
//            print("사용자 위치를 가져오지 못했습니다.")
//            return
//        }
//
//        if newHeading.headingAccuracy > 0 {
//            let heading = newHeading.trueHeading //사용자의 방위를 각도로 변형
//            print("사용자 \(heading)도")
//
//            //애니메이션이 부드럽게 되도록
//            UIView.animate(withDuration: 0.3) {
//
//                self.setMapRegion(location: userLocation, distance: 300)
//            }
//        }
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//
//        case .authorizedWhenInUse, .authorizedAlways:
//            //locationManager.startUpdatingLocation()
//            print("허용됨")
//
//        case .denied, .restricted:
//            print("위치 서비스 권한이 거부되었습니다.")
//
//            let alert = UIAlertController(title: "NO", message: "주변 약국을 조회하기 위해 위치 서비스 권한이 필요합니다.", preferredStyle: .alert)
//
//            let confirmAction = UIAlertAction(title: "이동", style: .default) { _ in
//                self.goToSetting()
//            }
//            alert.addAction(confirmAction)
//            self.present(alert, animated: true, completion: nil)
//
//        default:
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if let clError = error as? CLError {
//            switch clError.code {
//            case .denied:
//                print("위치 서비스 접근이 거부되었습니다. 설정에서 위치 서비스를 활성화하세요.")
//                //goToSetting()  // 위치 서비스를 설정하도록 안내
//                manager.requestWhenInUseAuthorization()
//            case .locationUnknown:
//                print("현재 위치를 확인할 수 없습니다. 잠시 후 다시 시도하세요.")
//            default:
//                print("위치 서비스 오류: \(clError.localizedDescription)")
//            }
//        } else {
//            print("알 수 없는 위치 서비스 오류: \(error.localizedDescription)")
//        }
//    }
//}
