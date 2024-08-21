import UIKit
class CustomTabBarController: UITabBarController {

    private var selectedItemIndex: Int = 0
    private let selectedColor = UIColor(hexCode: "#00459C")
    private let unselectedColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabitem()
        designCustomTabBar()
    }

    func setupTabitem() {
        let home = UINavigationController(rootViewController: HomeController())
        home.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        
        let location = UINavigationController(rootViewController: LocationController())
        location.view.backgroundColor = .white
        location.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "location"), tag: 1)
        
        let chatbot = UINavigationController(rootViewController: ChatBotController())
        chatbot.view.backgroundColor = .white
        chatbot.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 2)
        
        let alarm = UINavigationController(rootViewController: AlarmController())
        alarm.view.backgroundColor = .white
        alarm.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bell"), tag: 3)
        
        let mypage = UINavigationController(rootViewController: MyPageController())
        mypage.view.backgroundColor = .white
        mypage.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar"), tag: 4)
        
        viewControllers = [home, location, chatbot, alarm, mypage]
    }

    func designCustomTabBar() {
        // 기존 탭바를 숨기고 커스텀 탭바를 추가
        tabBar.isHidden = true
        
        let customTabBarView = UIView()
        customTabBarView.layer.backgroundColor = UIColor(red: 0.133, green: 0.376, blue: 1, alpha: 1).cgColor
        customTabBarView.layer.cornerRadius = 24
        
        view.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.widthAnchor.constraint(equalToConstant: 350), // 탭바의 길이를 늘림
            customTabBarView.heightAnchor.constraint(equalToConstant: 48),
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 양쪽 여백 조정
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34) // 하단에서의 간격 조정
        ])
        
        // 커스텀 탭바 위에 아이템들을 추가
        let itemContainerView = UIView()
        itemContainerView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        view.addSubview(itemContainerView)
        itemContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemContainerView.widthAnchor.constraint(equalToConstant: 300), // 탭바 아이템 컨테이너의 길이 증가
            itemContainerView.heightAnchor.constraint(equalToConstant: 40), // 높이를 증가시켜 아이템이 보이게 함
            itemContainerView.centerXAnchor.constraint(equalTo: customTabBarView.centerXAnchor),
            itemContainerView.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor)
        ])
        
        // 탭바 아이템 이미지 추가
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                let itemView = createTabBarItemView(for: item, at: index)
                itemContainerView.addSubview(itemView)
                itemView.translatesAutoresizingMaskIntoConstraints = false
                
                // 오른쪽으로 조금 이동시키기 위해 5 포인트 추가
                let leadingConstant = CGFloat(index) * (300 / CGFloat(items.count)) + 10
                
                NSLayoutConstraint.activate([
                    itemView.widthAnchor.constraint(equalToConstant: 40),
                    itemView.heightAnchor.constraint(equalToConstant: 40),
                    itemView.leadingAnchor.constraint(equalTo: itemContainerView.leadingAnchor, constant: leadingConstant),
                    itemView.centerYAnchor.constraint(equalTo: itemContainerView.centerYAnchor)
                ])
            }
        }
        
        // 초기 선택된 아이템 색상 업데이트
        updateTabBarItemColors()
    }

    func createTabBarItemView(for item: UITabBarItem, at index: Int) -> UIView {
        let itemView = UIView()
        
        let imageView = UIImageView(image: item.image?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = (index == selectedItemIndex) ? selectedColor : unselectedColor // 초기 아이템 색상 설정
        imageView.tag = 100 // 태그를 사용하여 나중에 찾을 수 있도록 함
        itemView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped(_:)))
        itemView.tag = index
        itemView.addGestureRecognizer(tapGesture)
        
        return itemView
    }
    
    @objc func tabBarItemTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            self.selectedIndex = tag
            selectedItemIndex = tag
            updateTabBarItemColors()
        }
    }
    
    func updateTabBarItemColors() {
        for (index, _) in (tabBar.items ?? []).enumerated() {
            if let itemView = view.viewWithTag(index),
               let imageView = itemView.viewWithTag(100) as? UIImageView {
                imageView.tintColor = (index == selectedItemIndex) ? selectedColor : unselectedColor
            }
        }
    }
}
