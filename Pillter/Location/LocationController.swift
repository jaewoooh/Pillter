import MapKit
import CoreLocation

class LocationController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager() // 위치 관리자
    var mapView: MKMapView! // 지도 뷰
    var userMovedMap = false // 사용자가 지도를 움직였는지 추적하는 변수
    let navigationBarController = NavigationBarController()
    var searchViewController: SearchViewController!
    var pharmacyViewController: PharmacyViewController!
    let subwaySearchController = SubwaySearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 설정
        navigationBarController.setupNavigationBarTitleView(for: self.navigationItem)
        navigationBarController.setupNavigationBarAppearance(for: self.navigationController)
        
        // 지도 설정
        mapView = MKMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.showsUserLocation = true // 사용자 위치 표시
        mapView.userTrackingMode = .followWithHeading // 사용자의 방향을 추적
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = false // 커스텀 나침반을 사용하기 위해 내장 나침반 비활성화
        
        view.addSubview(mapView)
        
        // 검색창, 약국 정보, 나침반 및 위치 버튼 추가
        setupSearchViewController()
        setupPharmacyViewController()
        setupCompassAndLocationButtons() // 나침반과 위치 버튼 추가
        
        // 위치 권한 요청 및 위치 업데이트 시작
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // 위치 업데이트 시작
        locationManager.startUpdatingHeading() // 방향 업데이트 시작
    }
    
    // 약국 정보 표시를 위한 뷰 컨트롤러 설정
    func setupPharmacyViewController() {
        pharmacyViewController = PharmacyViewController()
        addChild(pharmacyViewController)
        view.addSubview(pharmacyViewController.view)
        pharmacyViewController.didMove(toParent: self)
        
        // 약국 정보를 표시할 하단 뷰 설정
        pharmacyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pharmacyViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pharmacyViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pharmacyViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pharmacyViewController.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        view.bringSubviewToFront(pharmacyViewController.view)
    }
    
    // 검색창 뷰 컨트롤러 설정
    func setupSearchViewController() {
        searchViewController = SearchViewController()
        
        // 검색 기능 설정: 검색어를 지하철역으로 처리하고 검색 결과로 약국 찾기
        searchViewController.onSearch = { [weak self] query in
            self?.subwaySearchController.searchForSubwayStation(query: query, mapView: self!.mapView) { coordinate in
                if let coordinate = coordinate {
                    self?.searchForPharmacies(at: coordinate)
                }
            }
        }
        
        addChild(searchViewController)
        view.addSubview(searchViewController.view)
        searchViewController.didMove(toParent: self)
        
        // 검색창 레이아웃 설정
        searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchViewController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // 나침반 및 위치 버튼 추가
    func setupCompassAndLocationButtons() {
        // 커스텀 나침반 버튼을 지도에서 직접 위치 설정
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        view.addSubview(compassButton)
        
        // 나침반 버튼의 위치를 수동으로 설정
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compassButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            compassButton.topAnchor.constraint(equalTo: searchViewController.view.bottomAnchor, constant: 8), // 검색창 바로 아래에 배치
            compassButton.widthAnchor.constraint(equalToConstant: 50),
            compassButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 위치 버튼 설정
        let locationButton = UIButton(type: .custom)
        if let locationImage = UIImage(systemName: "location.fill") {
            locationButton.setImage(locationImage, for: .normal)
        } else {
            locationButton.setImage(UIImage(named: "location_icon"), for: .normal)
        }
        
        // 위치 버튼 스타일 설정
        locationButton.tintColor = .blue
        locationButton.backgroundColor = UIColor.white
        locationButton.layer.cornerRadius = 10
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOpacity = 0.3
        locationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        locationButton.layer.shadowRadius = 4
        locationButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        view.addSubview(locationButton)
        
        // 위치 버튼 레이아웃 설정
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 위치 버튼을 나침반 아래에 배치
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationButton.topAnchor.constraint(equalTo: compassButton.bottomAnchor, constant: 16),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MKMapViewDelegate 메서드: 약국 핀을 클릭했을 때 처리
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        // 선택한 핀의 크기를 크게 설정
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        // 선택된 약국에 해당하는 MKMapItem 찾기
        if let selectedPharmacy = pharmacyViewController.pharmacies.first(where: { $0.placemark.coordinate.latitude == annotation.coordinate.latitude &&
            $0.placemark.coordinate.longitude == annotation.coordinate.longitude }) {
            
            // 약국 뷰 컨트롤러에 선택된 약국을 전달
            pharmacyViewController.highlightSelectedPharmacy(selectedPharmacy)
        }
    }
    
    // MKMapViewDelegate 메서드: 약국 핀을 선택 해제했을 때 처리
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // 핀의 크기를 원래대로 되돌림
        view.transform = CGAffineTransform.identity
    }
    
    // 현재 위치로 지도 중심 이동
    @objc func centerMapOnUserLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // 방향 업데이트 콜백
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let userLocationView = mapView.view(for: mapView.userLocation) as? MKAnnotationView {
            // 사용자 방향에 따라 마커 회전
            let rotation = CGFloat(newHeading.trueHeading / 180.0 * .pi)
            userLocationView.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    // 위치 업데이트 콜백
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // 사용자가 지도를 움직이지 않았다면 현재 위치로 지도 업데이트
            if !userMovedMap {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
                mapView.setRegion(region, animated: false)
                searchForPharmacies(at: location.coordinate)
            }
        }
    }
    
    // 지도가 움직일 때 호출되는 메서드
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        searchForPharmacies(at: centerCoordinate)
        userMovedMap = true
    }
    
    // 위치 및 약국 검색 후 PharmacyViewController로 데이터 전달
    func searchForPharmacies(at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "약국"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            if let error = error {
                print("검색 중 오류 발생: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("검색 결과가 없습니다.")
                return
            }
            
            // 기존 약국 핀 제거
            self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            
            // 검색된 약국 핀 추가
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self?.mapView.addAnnotation(annotation)
            }
            
            // 약국 정보를 PharmacyViewController에 업데이트
            if let currentLocation = self?.locationManager.location {
                self?.pharmacyViewController.updatePharmacyData(pharmacies: response.mapItems, currentLocation: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
    }
    
}
