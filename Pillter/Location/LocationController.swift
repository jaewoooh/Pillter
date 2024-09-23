

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var mapView: MKMapView!
    var zoomController: ZoomController!
    var pharmacyViewController: PharmacyViewController!
    var pharmacies: [MKMapItem] = [] // 약국 정보를 저장하는 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 설정
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        // 위치 권한 요청 및 시작
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 줌 컨트롤러 추가
        setupZoomController()
        
        // 검색창 화면을 추가
        setupSearchViewController()
        
        // 약국 정보 화면 추가
        setupPharmacyViewController()
        
        // Auto Layout 설정
        setupMapViewConstraints()
    }
    
    // 지도 뷰의 Auto Layout 설정
    func setupMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),  // 부모 뷰의 상단에 맞춤
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)  // 부모 뷰의 하단에 맞춤
        ])
    }
    
    // 줌 컨트롤러 추가
    func setupZoomController() {
        zoomController = ZoomController()
        
        // 줌 변경 시 호출되는 클로저 설정
        zoomController.onZoomChange = { [weak self] zoomLevel in
            self?.zoomMap(to: zoomLevel)
        }
        
        // 줌 컨트롤러를 자식 뷰로 추가
        addChild(zoomController)
        view.addSubview(zoomController.view)
        zoomController.didMove(toParent: self)
    }
    
    // 줌 기능 구현
    func zoomMap(to zoomLevel: Double) {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // 검색창 화면 추가 함수
    func setupSearchViewController() {
        let searchViewController = SearchViewController()
        
        // 검색어를 받아서 처리하는 클로저 설정
        searchViewController.onSearch = { [weak self] query in
            self?.searchForLocations(query: query)
        }
        
        // 검색창을 하위 뷰로 추가
        addChild(searchViewController)
        view.addSubview(searchViewController.view)
        searchViewController.didMove(toParent: self)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            searchViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            searchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchViewController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    
    // 약국 정보 화면 추가
    func setupPharmacyViewController() {
        pharmacyViewController = PharmacyViewController()
        
        // 약국 데이터를 전달하는 등의 추가 작업 필요
        addChild(pharmacyViewController)
        view.addSubview(pharmacyViewController.view)
        pharmacyViewController.didMove(toParent: self)
        
        // Auto Layout 설정 (하단에 더 아래로 고정)
        pharmacyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pharmacyViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pharmacyViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pharmacyViewController.view.heightAnchor.constraint(equalToConstant: 280),
            pharmacyViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 43)
        ])
    }
    
    
    // 위치 업데이트 콜백
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // latitudinalMeters와 longitudinalMeters 값을 현재 줌 레벨에 맞게 설정
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            // 현재 위치를 기반으로 약국 검색 함수 호출
            searchForPharmacies(location: location)
        }
    }
    
    // 약국 검색 함수
    func searchForPharmacies(location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "약국"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("검색 중 오류 발생: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("검색 결과가 없습니다.")
                return
            }
            
            // 지도에 있는 기존 핀 제거
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            // 가장 가까운 약국 정보를 PharmacyViewController에 전달
            let nearestPharmacies = response.mapItems.sorted(by: { $0.placemark.location!.distance(from: location) < $1.placemark.location!.distance(from: location) })
            
            // PharmacyViewController에 약국 정보 전달
            self.pharmacyViewController.updatePharmacyData(pharmacies: nearestPharmacies)
            
            // 가장 가까운 약국 지도에 표시
            for item in nearestPharmacies {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
            
            // 검색 결과를 저장
            self.pharmacies = response.mapItems
            
            // 현재 보이는 영역의 약국들만 표시
            self.displayVisiblePharmacies()
        }
    }
    
    // 검색어로 장소 검색
    func searchForLocations(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("검색 중 오류 발생: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("검색 결과가 없습니다.")
                return
            }
            
            // 기존 핀 제거
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            // 검색된 위치를 지도에 핀으로 표시
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    // 현재 지도에서 보이는 영역의 약국들만 필터링하여 표시
    func displayVisiblePharmacies() {
        let visibleRegion = mapView.region // 현재 보이는 지도 영역
        
        // 지도에서 보이는 영역 안에 있는 약국들 필터링
        let visiblePharmacies = pharmacies.filter { pharmacy in
            let pharmacyLocation = pharmacy.placemark.coordinate
            return visibleRegion.contains(coordinate: pharmacyLocation)
        }
        
        // 지도에서 기존 약국 핀 제거
        mapView.removeAnnotations(mapView.annotations)
        
        // 필터링된 약국들만 지도에 표시
        for pharmacy in visiblePharmacies {
            let annotation = MKPointAnnotation()
            annotation.title = pharmacy.name
            annotation.coordinate = pharmacy.placemark.coordinate
            mapView.addAnnotation(annotation)
        }
        
        // PharmacyViewController에 약국 정보 업데이트
        pharmacyViewController.updatePharmacyData(pharmacies: visiblePharmacies)
    }
    
    // 지도 영역이 변경되었을 때 호출되는 델리게이트 메서드
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        displayVisiblePharmacies()
    }
    
}

// MKCoordinateRegion에 좌표를 포함하는지 확인하는 확장 함수
extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let northWest = CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta / 2,
                                               longitude: center.longitude - span.longitudeDelta / 2)
        let southEast = CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta / 2,
                                               longitude: center.longitude + span.longitudeDelta / 2)
        
        return coordinate.latitude >= southEast.latitude &&
               coordinate.latitude <= northWest.latitude &&
               coordinate.longitude >= northWest.longitude &&
               coordinate.longitude <= southEast.longitude
    }
}
