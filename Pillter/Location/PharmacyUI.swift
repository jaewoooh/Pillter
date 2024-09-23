////PharmacyUI
//
////
////  PharmacyUI.swift
////  Pillter
////
////  Created by 이상원 on 8/25/24.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//
//extension LocationController: UITextFieldDelegate, UISearchTextFieldDelegate
//{
//
//    // 개별 약국 정보 뷰 생성 함수
//    func createPharmacyInfoView(pharmacy: DataItem, distance: Int) -> UIView {
//        let pharmacyView = UIView()
//        pharmacyView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        pharmacyView.layer.cornerRadius = 12
//
//
//        // 그림자 효과 추가
//        pharmacyView.layer.shadowColor = UIColor.black.cgColor
//        pharmacyView.layer.shadowOpacity = 0.3
//        pharmacyView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        pharmacyView.layer.shadowRadius = 4
//
//        // 약국 이름 레이블 추가
//        let pharmacyNameLabel = UILabel()
//        pharmacyNameLabel.text = pharmacy.dutyName
//        pharmacyNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        pharmacyNameLabel.textColor = UIColor.black
//        pharmacyNameLabel.textAlignment = .center
//
//        pharmacyView.addSubview(pharmacyNameLabel)
//
//        pharmacyNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        pharmacyNameLabel.topAnchor.constraint(equalTo: pharmacyView.topAnchor, constant: 8).isActive = true
//        pharmacyNameLabel.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor).isActive = true
//
//        // 약국 이름 레이블 아래에 회색 선 추가
//        let separatorView = UIView()
//        separatorView.layer.backgroundColor = UIColor(red: 0.943, green: 0.949, blue: 0.963, alpha: 1).cgColor
//        pharmacyView.addSubview(separatorView)
//
//        separatorView.translatesAutoresizingMaskIntoConstraints = false
//        separatorView.topAnchor.constraint(equalTo: pharmacyNameLabel.bottomAnchor, constant: 8).isActive = true
//        separatorView.leadingAnchor.constraint(equalTo: pharmacyView.leadingAnchor, constant: 16).isActive = true
//        separatorView.trailingAnchor.constraint(equalTo: pharmacyView.trailingAnchor, constant: -16).isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        // 전화번호 이미지와 레이블을 담을 스택뷰 추가
//        let phoneStackView = UIStackView()
//        phoneStackView.axis = .horizontal
//        phoneStackView.alignment = .center
//        phoneStackView.spacing = 8
//
//        pharmacyView.addSubview(phoneStackView)
//
//        phoneStackView.translatesAutoresizingMaskIntoConstraints = false
//        phoneStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5).isActive = true
//        phoneStackView.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor).isActive = true
//
//        // 전화번호 이미지 추가
//        let phoneImageView = UIImageView()
//        phoneImageView.image = UIImage(systemName: "phone.fill")
//        phoneImageView.tintColor = UIColor.gray
//
//        phoneStackView.addArrangedSubview(phoneImageView)
//
//        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
//        phoneImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
//        phoneImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
//
//        // 약국 전화번호 레이블 추가
//        let pharmacyPhoneLabel = UILabel()
//        pharmacyPhoneLabel.text = pharmacy.dutyTel1
//        pharmacyPhoneLabel.font = UIFont.systemFont(ofSize: 14)
//        pharmacyPhoneLabel.textColor = UIColor.gray
//        pharmacyPhoneLabel.textAlignment = .center
//
//        phoneStackView.backgroundColor = .green
//        phoneStackView.addArrangedSubview(pharmacyPhoneLabel)
//
//        // 거리 라벨
//        let distanceLabel = UILabel()
//        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
//        distanceLabel.text = "\(distance)m"
//        distanceLabel.font = UIFont.systemFont(ofSize: 12)
//        distanceLabel.textColor = UIColor.gray
//        distanceLabel.textAlignment = .center
//
//        pharmacyView.addSubview(distanceLabel)
//        distanceLabel.topAnchor.constraint(equalTo: phoneStackView.bottomAnchor, constant: 3).isActive = true
//        distanceLabel.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor).isActive = true
//
//        //운영시간보기 버튼
//        let infoBtn = UIButton()
//        infoBtn.setTitle("운영시간 및 위치보기", for: .normal)
//        infoBtn.translatesAutoresizingMaskIntoConstraints = false
//        infoBtn.backgroundColor = .systemBlue
//        infoBtn.layer.cornerRadius = 10
//        infoBtn.accessibilityHint = pharmacy.dutyName
//        infoBtn.addTarget(self, action: #selector(infoBtnTapped(_:)), for: .touchUpInside)
//
//        pharmacyView.addSubview(infoBtn)
//        infoBtn.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5).isActive = true
//        infoBtn.leadingAnchor.constraint(equalTo: pharmacyView.leadingAnchor, constant: 10).isActive = true
//        infoBtn.trailingAnchor.constraint(equalTo: pharmacyView.trailingAnchor, constant: -10).isActive = true
//        infoBtn.bottomAnchor.constraint(equalTo: pharmacyView.bottomAnchor, constant: -5).isActive = true
//
//
//
//        return pharmacyView
//    }
//
//    // 하단 약국 정보 스크롤뷰 설정 및 annotation 추가
//    func setupBottomPharmacyScrollView(with data: [DataItem]) {
//        guard let userLocation = locationManager.location?.coordinate else {
//            print("User location is not available")
//            return
//        }
//
//        //var sendDistance = Int() //createPharmacyInfoView 에 보낼 distance
//
//        // 기존 scrollView를 제거
//        scrollView?.removeFromSuperview()
//
//        //지도에 있는 어노테이션 제거
//        let allAnnotations = mapView.annotations
//        mapView.removeAnnotations(allAnnotations)
//
//        // 새로운 스크롤뷰 생성
//        scrollView = UIScrollView()
//        scrollView?.showsHorizontalScrollIndicator = false
//
//        scrollView?.backgroundColor = .clear //지정하는게 나을수도?
//
//        view.addSubview(scrollView!)
//
//        // 스크롤뷰 설정
//        NSLayoutConstraint.activate([
//            scrollView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView!.heightAnchor.constraint(equalToConstant: 200),
//            scrollView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
//        ])
//
//        // 새로운 컨텐츠뷰 생성
//        contentView = UIView()
//        scrollView?.addSubview(contentView!)
//
//        // 컨텐츠뷰 설정
//        NSLayoutConstraint.activate([
//            contentView!.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor),
//            contentView!.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor),
//            contentView!.topAnchor.constraint(equalTo: scrollView!.topAnchor),
//            contentView!.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor),
//            contentView!.heightAnchor.constraint(equalTo: scrollView!.heightAnchor, multiplier: 0.6)
//        ])
//
//
//
//        // 300m 안에 있는 약국 필터링
//        let nearbyPharmacies = data.filter { pharmacy in
//            guard let lat = Double(pharmacy.latitude), let lon = Double(pharmacy.longitude) else { return false }
//
//            let pharmacyLocation = CLLocation(latitude: lat, longitude: lon)
//            let distance = pharmacyLocation.distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
//
//            //print(pharmacy.dutyName + " \(distance)")
//            return distance <= 300
//        }
//
//        if nearbyPharmacies.isEmpty {
//
//            print("검색된 약국이 없음")
//            let alert = UIAlertController(title: "없음", message: "300m 내에 약국이 없습니다.", preferredStyle: .alert)
//            let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
//            alert.addAction(closeAction)
//            present(alert, animated: true, completion: nil)
//        }
//
//        // 약국 데이터를 저장 (팝업에서 사용할 용도)
//        filterPharmacyData = nearbyPharmacies
//
//        var previousView: UIView? = nil
//
//        for pharmacy in nearbyPharmacies {
//
//            guard let lat = Double(pharmacy.latitude), let lon = Double(pharmacy.longitude) else { continue }
//
//            // 약국 위치에서 사용자 위치까지의 거리 계산
//            let pharmacyLocation = CLLocation(latitude: lat, longitude: lon)
//            let distance = Int(pharmacyLocation.distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)))
//
//            // 약국 정보를 스크롤 뷰에 추가
//            let pharmacyView = createPharmacyInfoView(pharmacy: pharmacy, distance: distance)
//            pharmacyView.translatesAutoresizingMaskIntoConstraints = false
//            contentView?.addSubview(pharmacyView)
//
//            NSLayoutConstraint.activate([
//                pharmacyView.topAnchor.constraint(equalTo: contentView!.topAnchor),
//                pharmacyView.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor),
//                pharmacyView.widthAnchor.constraint(equalToConstant: 200)
//            ])
//
//            if let previous = previousView {
//                pharmacyView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 16).isActive = true
//            } else {
//                pharmacyView.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 16).isActive = true
//            }
//            previousView = pharmacyView
//
//            addPharmacyAnnotation(pharmacy: pharmacy) //약국 위치에 어노테이션 추가
//
//        }
//
//        if let lastView = previousView {
//            contentView?.trailingAnchor.constraint(equalTo: lastView.trailingAnchor, constant: 16).isActive = true
//        }
//    }
//
//    // 어노테이션 관련 함수
//    func addPharmacyAnnotation(pharmacy: DataItem) {
//        guard let lat = Double(pharmacy.latitude), let lon = Double(pharmacy.longitude) else { return } //이부분 주석하고다시 ㄱㄱ
//
//        let annotation = MKPointAnnotation()
//        annotation.title = pharmacy.dutyName
//        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        mapView.addAnnotation(annotation)
//    }
//
//    //운영시간조회 버튼을 눌렀을때
//    @objc func infoBtnTapped(_ sender: UIButton)
//    {
//        print("click")
//
//        guard let pharmacyName = sender.accessibilityHint else { return }
//        guard let pharmacy = findPharmacy(by: pharmacyName) else { return }
//
//        //infoBtn을 누르면 어노테이션도 띄우기
//        showPharmacyAnnotationOnMap(pharmacy: pharmacy)
//
//        let alert = UIAlertController(title: pharmacy.dutyName, message: nil, preferredStyle: .alert)
//        let message = """
//
//        월요일: \(pharmacy.mondayOpen ?? "정보 없음") ~ \(pharmacy.mondayClose ?? "정보 없음")
//        화요일: \(pharmacy.tuesdayOpen ?? "정보 없음") ~ \(pharmacy.tuesdayClose ?? "정보 없음")
//        수요일: \(pharmacy.wednesdayOpen ?? "정보 없음") ~ \(pharmacy.wednesdayClose ?? "정보 없음")
//        목요일: \(pharmacy.thursdayOpen ?? "정보 없음") ~ \(pharmacy.thursdayClose ?? "정보 없음")
//        금요일: \(pharmacy.fridayOpen ?? "정보 없음") ~ \(pharmacy.fridayClose ?? "정보 없음")
//        토요일: \(pharmacy.saturdayOpen ?? "정보 없음") ~ \(pharmacy.saturdayClose ?? "정보 없음")
//        일요일: \(pharmacy.sundayOpen ?? "정보 없음") ~ \(pharmacy.sundayClose ?? "정보 없음")
//        공휴일: \(pharmacy.holidayOpen ?? "정보 없음") ~ \(pharmacy.holidayClose ?? "정보 없음")
//        """
//        alert.message = message
//        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
//        alert.addAction(closeAction)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    // 약국 이름으로 약국 찾기 infoBtnTapped함수에서 사용
//     func findPharmacy(by name: String) -> DataItem? {
//         return filterPharmacyData.first { $0.dutyName == name }
//     }
//
//    // infoBtn에 해당하는 어노테이션의 정보창을 지도에 표시하는 함수
//    func showPharmacyAnnotationOnMap(pharmacy: DataItem) {
//        //약국에 해당하는 어노테이션 찾기
//        let matchingAnnotations = mapView.annotations.filter { annotation in
//            guard let title = annotation.title, title == pharmacy.dutyName else { return false }
//            return true
//        }
//
//        // 어노테이션을 찾으면 정보창을 표시하도록 선택
//        if let matchingAnnotation = matchingAnnotations.first {
//            mapView.selectAnnotation(matchingAnnotation, animated: true)
//        }
//    }
//}
