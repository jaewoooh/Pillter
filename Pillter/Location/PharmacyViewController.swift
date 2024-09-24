
import UIKit
import MapKit
import CoreLocation

class PharmacyViewController: UIViewController {
    
    var pharmacies: [MKMapItem] = []
    var scrollView: UIScrollView!
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPharmacyScrollView()
    }
    
    func setupPharmacyScrollView() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
    }
    
    func updatePharmacyData(pharmacies: [MKMapItem], currentLocation: CLLocation) {
        self.pharmacies = pharmacies
        self.currentLocation = currentLocation
        
        // 약국 데이터를 거리 기준으로 정렬
        let sortedPharmacies = pharmacies.sorted {
            let location1 = CLLocation(latitude: $0.placemark.coordinate.latitude, longitude: $0.placemark.coordinate.longitude)
            let location2 = CLLocation(latitude: $1.placemark.coordinate.latitude, longitude: $1.placemark.coordinate.longitude)
            return location1.distance(from: currentLocation) < location2.distance(from: currentLocation)
        }
        
        // 기존 약국 정보 제거
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var previousView: UIView? = nil
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for pharmacy in sortedPharmacies {
            let destinationLocation = CLLocation(latitude: pharmacy.placemark.coordinate.latitude,
                                                 longitude: pharmacy.placemark.coordinate.longitude)
            let distance = LocationCalculator.calculateDistance(from: currentLocation, to: destinationLocation)
            let formattedDistance = LocationCalculator.formatDistance(distance)
            let pharmacyView = createPharmacyInfoView(pharmacyName: pharmacy.name ?? "Unknown", phoneNumber: pharmacy.phoneNumber ?? "N/A", distance: formattedDistance)
            contentView.addSubview(pharmacyView)
            
            pharmacyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pharmacyView.widthAnchor.constraint(equalToConstant: 200),
                pharmacyView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            if let previous = previousView {
                pharmacyView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 16).isActive = true
            } else {
                pharmacyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            }
            previousView = pharmacyView
        }
        
        if let lastView = previousView {
            lastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }
    }
    
    func highlightSelectedPharmacy(_ selectedPharmacy: MKMapItem) {
        guard let currentLocation = currentLocation else { return }
        
        // 선택한 약국을 맨 앞에 위치시키고, 나머지 약국은 거리순으로 정렬
        let sortedPharmacies = pharmacies.filter { $0 != selectedPharmacy }.sorted {
            let location1 = CLLocation(latitude: $0.placemark.coordinate.latitude, longitude: $0.placemark.coordinate.longitude)
            let location2 = CLLocation(latitude: $1.placemark.coordinate.latitude, longitude: $1.placemark.coordinate.longitude)
            return location1.distance(from: currentLocation) < location2.distance(from: currentLocation)
        }
        
        // 선택한 약국을 맨 앞에 추가한 새로운 배열 생성
        let updatedPharmacies = [selectedPharmacy] + sortedPharmacies
        
        // 스크롤 뷰 업데이트
        updatePharmacyScrollView(with: updatedPharmacies)
    }

    private func updatePharmacyScrollView(with pharmacies: [MKMapItem]) {
        // 스크롤 뷰 내용 제거
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var previousView: UIView? = nil
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // 정렬된 약국들을 다시 스크롤 뷰에 추가
        for pharmacy in pharmacies {
            let destinationLocation = CLLocation(latitude: pharmacy.placemark.coordinate.latitude,
                                                 longitude: pharmacy.placemark.coordinate.longitude)
            let distance = LocationCalculator.calculateDistance(from: currentLocation!, to: destinationLocation)
            let formattedDistance = LocationCalculator.formatDistance(distance)
            let pharmacyView = createPharmacyInfoView(pharmacyName: pharmacy.name ?? "Unknown", phoneNumber: pharmacy.phoneNumber ?? "N/A", distance: formattedDistance)
            contentView.addSubview(pharmacyView)
            
            pharmacyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pharmacyView.widthAnchor.constraint(equalToConstant: 200),
                pharmacyView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            
            if let previous = previousView {
                pharmacyView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 16).isActive = true
            } else {
                pharmacyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            }
            previousView = pharmacyView
        }
        
        if let lastView = previousView {
            lastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        }
    }

    
    func createPharmacyInfoView(pharmacyName: String, phoneNumber: String, distance: String) -> UIView {
        let pharmacyView = UIView()
        pharmacyView.layer.backgroundColor = UIColor.white.cgColor
        pharmacyView.layer.cornerRadius = 12
        
        let pharmacyIcon = UIImageView()
        pharmacyIcon.image = UIImage(named: "pharmacy")
        pharmacyIcon.contentMode = .scaleAspectFit
        pharmacyView.addSubview(pharmacyIcon)
        
        pharmacyIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pharmacyIcon.topAnchor.constraint(equalTo: pharmacyView.topAnchor, constant: 20),
            pharmacyIcon.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor),
            pharmacyIcon.widthAnchor.constraint(equalToConstant: 70),
            pharmacyIcon.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        let pharmacyNameLabel = UILabel()
        pharmacyNameLabel.text = pharmacyName
        pharmacyNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        pharmacyNameLabel.textColor = UIColor.black
        pharmacyNameLabel.textAlignment = .center
        pharmacyView.addSubview(pharmacyNameLabel)
        
        pharmacyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pharmacyNameLabel.topAnchor.constraint(equalTo: pharmacyIcon.bottomAnchor, constant: 16),
            pharmacyNameLabel.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor)
        ])
        
        let distanceLabel = UILabel()
        distanceLabel.text = distance
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = UIColor.gray
        distanceLabel.textAlignment = .center
        pharmacyView.addSubview(distanceLabel)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: pharmacyNameLabel.bottomAnchor, constant: 8),
            distanceLabel.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor)
        ])
        
        let separatorView = UIView()
        separatorView.layer.backgroundColor = UIColor(red: 0.943, green: 0.949, blue: 0.963, alpha: 1).cgColor
        pharmacyView.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 16),
            separatorView.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 153),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let phoneIcon = UIImageView(image: UIImage(systemName: "phone.fill"))
        phoneIcon.tintColor = .gray
        phoneIcon.contentMode = .scaleAspectFit
        
        let pharmacyPhoneLabel = UILabel()
        pharmacyPhoneLabel.text = phoneNumber
        pharmacyPhoneLabel.font = UIFont.systemFont(ofSize: 14)
        pharmacyPhoneLabel.textColor = UIColor.gray
        pharmacyPhoneLabel.textAlignment = .center
        
        let phoneStackView = UIStackView(arrangedSubviews: [phoneIcon, pharmacyPhoneLabel])
        phoneStackView.axis = .horizontal
        phoneStackView.spacing = 8
        phoneStackView.alignment = .center
        pharmacyView.addSubview(phoneStackView)
        
        phoneStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            phoneStackView.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor)
        ])
        
        phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneIcon.widthAnchor.constraint(equalToConstant: 20),
            phoneIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return pharmacyView
    }
}
