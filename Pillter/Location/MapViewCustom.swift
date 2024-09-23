//
////  MapViewCustom.swift
////  Pillter
////
////  Created by 이상원 on 9/5/24.
////
//
//import UIKit
//import MapKit
//
//extension LocationController
//{
//    //오버레이
//    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
//
//        if let polyline = overlay as? MKPolyline
//        {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemBlue
//            renderer.lineWidth = 10
//
//            return renderer
//        }
//
//        if let circleOverlay = overlay as? MKCircle
//        {
//            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
//            circleRenderer.strokeColor = .blue
//            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
//            circleRenderer.lineWidth = 2
//            return circleRenderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//
//    // 어노테이션 커스텀
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 사용자 위치 어노테이션은 건너뛰기
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        let identifier = "PharmacyAnnotation"
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) //기존 어노테이션 뷰가 있는지 확인
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true // 어노테이션 클릭 시 정보 표시
//
//            // 약국 이미지를 사용하는 어노테이션
//            let pharmacyImage = UIImage(systemName: "cross.case.fill") // 시스템 심볼 사용
//            //let pharmacyImage = UIImage(named: "blue-robot")
//
//            // UIImageView를 사용하여 이미지 크기 조정
//            let imageView = UIImageView(image: pharmacyImage)
//            imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35) // 원하는 크기로 조정 (여기서는 40x40으로 설정)
//            imageView.backgroundColor = .clear
//            imageView.tintColor = .red
//
//            annotationView?.addSubview(imageView) // 이미지를 어노테이션 뷰에 추가
//            annotationView?.frame = imageView.frame // 어노테이션 뷰의 크기를 이미지 뷰에 맞춤
//
//            // 어노테이션의 정보창에 약국 이미지를 추가 (선택사항)
////            let annotationImageView = UIImageView(image: pharmacyImage)
////            annotationImageView.backgroundColor = .white
////            annotationView?.tintColor = .red
////            annotationImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // 이미지 크기 조정
////            annotationView?.leftCalloutAccessoryView = annotationImageView // 정보창에 이미지를 추가할 경우
//
//            let button = UIButton(type: .custom)
//            button.setImage(UIImage(systemName: "figure.walk.motion"), for: .normal)
//            //button.setTitle("길찾기", for: .normal)
//            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            button.tintColor = .red
//            annotationView?.leftCalloutAccessoryView = button
//
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        return annotationView
//    }
//
//    // 어노테이션 정보창의 타이틀이나 버튼이 클릭되었을 때 호출되는 메서드
//    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        showAlert(for: annotationView)
//    }
//
//    // 공통으로 Alert 표시 메서드
//    func showAlert(for annotationView: MKAnnotationView) {
//        if let annotationTitle = annotationView.annotation?.title {
//            print("어노테이션 클릭: \(annotationTitle ?? "정보없음")")
//
//            let alert = UIAlertController(title: annotationTitle, message: "이 약국을 선택하시겠습니까?", preferredStyle: .alert)
//
//            // 길찾기 액션
//            let naviAction = UIAlertAction(title: "길찾기", style: .default)
//            { [weak self] _ in
//                guard let self = self else { return }
//                print("네비")
//
//                // 사용자 위치 가져오기
//                guard let userLocation = self.locationManager.location?.coordinate else {
//                    print("사용자 위치를 가져오지 못했습니다.")
//                    return
//                }
//
//                // 어노테이션 위치 가져오기
//                guard let annotationLocation = annotationView.annotation?.coordinate else {
//                    print("어노테이션 위치를 가져오지 못했습니다.")
//                    return
//                }
//
//                self.drawRoute(from: userLocation, to: annotationLocation)
//            }
//            alert.addAction(naviAction)
//
//            // 닫기 액션
//            let closeAction = UIAlertAction(title: "뒤로가기", style: .cancel)
//            { _ in
//                print("끄기")
//                self.mapView.deselectAnnotation(annotationView as? MKAnnotation, animated: true)
//            }
//            alert.addAction(closeAction)
//
//            present(alert, animated: true, completion: nil)
//        }
//        else {
//            print("click")
//        }
//    }
//
//    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        // 사용자 위치와 어노테이션 위치 설정
//        let sourcePlacemark = MKPlacemark(coordinate: source)
//        let destinationPlacemark = MKPlacemark(coordinate: destination)
//
//        let sourceItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationItem = MKMapItem(placemark: destinationPlacemark)
//
//        let directionsRequest = MKDirections.Request()
//        directionsRequest.source = sourceItem
//        directionsRequest.destination = destinationItem
//        directionsRequest.transportType = .walking // 도보 경로
//
//        let directions = MKDirections(request: directionsRequest)
//        directions.calculate { [weak self] (response, error) in
//            guard let self = self, let response = response, error == nil else {
//                print("경로 계산에 실패했습니다: \(error?.localizedDescription ?? "오류 없음")")
//                return
//            }
//
//            // 지도에 기존 경로 제거
////            let overlays = self.mapView.overlays
////            self.mapView.removeOverlays(overlays)
//            for overlay in self.mapView.overlays {
//                if overlay is MKPolyline {
//                    self.mapView.removeOverlay(overlay)
//                }
//            }
//
//
//            // 새로운 경로를 지도에 추가
//            if let route = response.routes.first {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
//    }
//}
