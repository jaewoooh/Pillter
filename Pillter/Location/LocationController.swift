//LocationController

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var pharmacyAnnotations: [MKPointAnnotation] = []
    var circleOverlay: MKCircle? //UserOverlay에서 사용
    
    // 스크롤뷰와 컨텐츠뷰를 클래스 레벨에서 정의, PharmacyUI에서 사용
    var scrollView: UIScrollView? {
        didSet {
            scrollView?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var contentView: UIView? {
        didSet {
            contentView?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var filterPharmacyData: [DataItem] = [] //운영시간조회에 담을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MKMapView 인스턴스 생성
        if mapView == nil {
            mapView = MKMapView(frame: self.view.bounds)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.mapType = .standard
            
            // View에 MKMapView 추가
            view.addSubview(mapView)
        }

        
//        // 위치 권한 ㅇㅋ안했을시 초기 위치를 한성대학교 근처로 설정 (한성대입구역 근처)
//        let initialLocation = CLLocation(latitude: 37.5887, longitude: 127.0069)
//        setMapRegion(location: initialLocation, distance: 500) // 500m 범위로 설정

        
        mapManagerSettings()

        // 검색창 추가
        //setupSearchBar()

        // json으로 불러온 데이터 보여주기
        //loadPharmacyData()
        
        mapUICustom()
        locationGPSCheck()
    }
    
    //맵뷰와 위치관리자 권한 설정같은거
    func mapManagerSettings()
    {
        //맵뷰 설정
        mapView.delegate = self
        mapView.showsUserLocation = true
        //mapView.userTrackingMode = .followWithHeading
        
        // 위치 관리자 설정
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //위치 정확도 향상
        locationManager.distanceFilter = 20.0 //20m 이동시에만 업데이트
        locationManager.requestWhenInUseAuthorization() //권한요청
        locationManager.startUpdatingLocation() //실시간 위치
        //locationManager.startUpdatingHeading() //방향 업데이트
        //locationManager.startMonitoringSignificantLocationChanges() //장거리 이동시 위치업뎃
    }
        
    func mapUICustom() {
        // 사용자 위치 추적 버튼 (MKUserTrackingButton 대신 커스텀 버튼 사용)
        let userTrackingBtn = UIButton(type: .system)
        userTrackingBtn.setImage(UIImage(systemName: "location.fill"), for: .normal)

        userTrackingBtn.translatesAutoresizingMaskIntoConstraints = false
        userTrackingBtn.backgroundColor = .white
        userTrackingBtn.layer.cornerRadius = 5
        userTrackingBtn.layer.borderWidth = 1
        userTrackingBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        // 버튼 클릭 시 행동 추가
        userTrackingBtn.addTarget(self, action: #selector(startTrackingWithHeading), for: .touchUpInside)
        userTrackingBtn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        userTrackingBtn.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])
        
        mapView.addSubview(userTrackingBtn)
        
        // UI constraint
        NSLayoutConstraint.activate([
            userTrackingBtn.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            userTrackingBtn.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
            userTrackingBtn.widthAnchor.constraint(equalToConstant: 44),
            userTrackingBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc func startTrackingWithHeading(_ sender: UIButton) {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    func setMapRegion(location: CLLocation, distance: CLLocationDistance) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: distance * 2, // 지도를 더 확대
            longitudinalMeters: distance * 2)
        mapView.setRegion(region, animated: true)
    }
    
}

