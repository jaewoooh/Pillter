import UIKit
import MapKit

class PharmacyViewController: UIViewController {
    
    // 약국 정보를 저장할 데이터 구조체
    var pharmacies: [MKMapItem] = []  // MKMapItem 배열로 약국 정보를 저장
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPharmacyScrollView()  // 스크롤뷰 설정
    }
    
    // 하단 약국 정보 스크롤뷰 설정
    func setupPharmacyScrollView() {
        // 스크롤 뷰 생성
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // 스크롤 뷰 제약 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
    }
    
    // 약국 데이터를 업데이트하는 함수
    func updatePharmacyData(pharmacies: [MKMapItem]) {
        self.pharmacies = pharmacies
        
        // 스크롤 뷰에 약국 정보 추가
        var previousView: UIView? = nil
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        // 컨텐츠 뷰 제약 설정
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        for pharmacy in pharmacies {
            let pharmacyView = createPharmacyInfoView(pharmacyName: pharmacy.name ?? "Unknown", phoneNumber: pharmacy.phoneNumber ?? "N/A")
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
    
    // 개별 약국 정보 뷰 생성 함수
    func createPharmacyInfoView(pharmacyName: String, phoneNumber: String) -> UIView {
        let pharmacyView = UIView()
        pharmacyView.layer.backgroundColor = UIColor.white.cgColor
        pharmacyView.layer.cornerRadius = 12
        
        // 그림자 효과 추가
        pharmacyView.layer.shadowColor = UIColor.black.cgColor
        pharmacyView.layer.shadowOpacity = 0.3
        pharmacyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        pharmacyView.layer.shadowRadius = 4
        
        // 약국 아이콘 추가
        let pharmacyIcon = UIImageView()
        pharmacyIcon.image = UIImage(named: "pharmacy")
        pharmacyIcon.contentMode = .scaleAspectFit
        pharmacyView.addSubview(pharmacyIcon)
        
        // 약국 아이콘 제약 조건 설정
        pharmacyIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pharmacyIcon.topAnchor.constraint(equalTo: pharmacyView.topAnchor, constant: 20),
            pharmacyIcon.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor),
            pharmacyIcon.widthAnchor.constraint(equalToConstant: 70),
            pharmacyIcon.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // 약국 이름 레이블 추가
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
        
        // 구분선 추가
        let separatorView = UIView()
        separatorView.layer.backgroundColor = UIColor(red: 0.943, green: 0.949, blue: 0.963, alpha: 1).cgColor
        pharmacyView.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: pharmacyNameLabel.bottomAnchor, constant: 16),
            separatorView.centerXAnchor.constraint(equalTo: pharmacyView.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 153),
            separatorView.heightAnchor.constraint(equalToConstant: 1) // 구분선의 높이 설정
        ])
        
        // 전화기 아이콘 추가
        let phoneIcon = UIImageView(image: UIImage(systemName: "phone.fill"))
        phoneIcon.tintColor = .gray
        phoneIcon.contentMode = .scaleAspectFit
        
        // 전화번호 레이블 추가
        let pharmacyPhoneLabel = UILabel()
        pharmacyPhoneLabel.text = phoneNumber
        pharmacyPhoneLabel.font = UIFont.systemFont(ofSize: 14)
        pharmacyPhoneLabel.textColor = UIColor.gray
        pharmacyPhoneLabel.textAlignment = .center
        
        // 스택뷰에 전화기 아이콘과 전화번호 레이블 추가
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
        
        // 전화기 아이콘 크기 제약 설정
        phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneIcon.widthAnchor.constraint(equalToConstant: 20),
            phoneIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return pharmacyView
    }
}
