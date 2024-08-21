import UIKit

class CustomTabBarController: UITabBarController {

    private var selectedItemIndex: Int = 0
    private let selectedColor = UIColor(hexCode: "2260FF") // 선택된 아이템의 색상
    private let unselectedColor = UIColor.black // 비선택 아이템의 색상 (검정색)

    override func viewDidLoad() {
        super.viewDidLoad()

        // 탭바 배경을 투명하게 설정
        makeTabBarTransparent()

        // 탭바 항목 설정
        setupTabitem()

        // 커스텀 탭바 디자인 설정
        designCustomTabBar()

        // 초기화할 때 탭바 아이템 색상 업데이트
        updateTabBarItemColors()
    }

    func makeTabBarTransparent() {
        // 배경을 투명하게 설정
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
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
        // 기존 탭바 숨기기
        tabBar.isHidden = true

        // 흰색 배경 뷰 추가 (탭바 아래 부분과 옆부분 포함)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white

        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 100) // 높이를 100으로 지정하여 아래까지 덮음
        ])

        let customTabBarView = UIView()
        customTabBarView.layer.backgroundColor = UIColor(red: 0.929, green: 0.945, blue: 1, alpha: 1).cgColor
        customTabBarView.layer.cornerRadius = 24

        view.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.widthAnchor.constraint(equalToConstant: 350), // 너비 조정
            customTabBarView.heightAnchor.constraint(equalToConstant: 48),
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 좌우 여백 조정
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34) // 하단 간격 조정
        ])

        // 커스텀 탭바 위에 항목 컨테이너 추가
        let itemContainerView = UIView()
        itemContainerView.layer.backgroundColor = UIColor.clear.cgColor

        view.addSubview(itemContainerView)
        itemContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemContainerView.widthAnchor.constraint(equalToConstant: 300),
            itemContainerView.heightAnchor.constraint(equalToConstant: 40),
            itemContainerView.centerXAnchor.constraint(equalTo: customTabBarView.centerXAnchor),
            itemContainerView.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor)
        ])

        // 탭바 아이템 추가
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                let itemView = createTabBarItemView(for: item, at: index)
                itemView.tag = index
                itemContainerView.addSubview(itemView)
                itemView.translatesAutoresizingMaskIntoConstraints = false

                let leadingConstant = CGFloat(index) * (300 / CGFloat(items.count)) + 10

                NSLayoutConstraint.activate([
                    itemView.widthAnchor.constraint(equalToConstant: 40),
                    itemView.heightAnchor.constraint(equalToConstant: 40),
                    itemView.leadingAnchor.constraint(equalTo: itemContainerView.leadingAnchor, constant: leadingConstant),
                    itemView.centerYAnchor.constraint(equalTo: itemContainerView.centerYAnchor)
                ])
            }
        }
    }

    func createTabBarItemView(for item: UITabBarItem, at index: Int) -> UIView {
        let itemView = UIView()

        // 선택된 아이템에 원형 배경 추가
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 20
        backgroundView.backgroundColor = (index == selectedItemIndex) ? selectedColor : .clear
        backgroundView.tag = 99 // 백그라운드 뷰 태그

        // 선택된 아이템에 그림자 효과 추가
        if index == selectedItemIndex {
            backgroundView.layer.shadowColor = selectedColor.cgColor
            backgroundView.layer.shadowRadius = 10
            backgroundView.layer.shadowOpacity = 0.5
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }

        itemView.addSubview(backgroundView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 40),
            backgroundView.heightAnchor.constraint(equalToConstant: 40)
        ])

        let imageView = UIImageView(image: item.image?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = (index == selectedItemIndex) ? .white : unselectedColor // 초기 아이템 색상 설정
        imageView.tag = 100 // 태그를 사용하여 나중에 찾을 수 있도록 함
        backgroundView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped(_:)))
        itemView.addGestureRecognizer(tapGesture)

        return itemView
    }

    @objc func tabBarItemTapped(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            selectedItemIndex = tag
            self.selectedIndex = tag
            updateTabBarItemColors()
        }
    }

    func updateTabBarItemColors() {
        for (index, _) in (tabBar.items ?? []).enumerated() {
            if let itemView = view.viewWithTag(index),
               let backgroundView = itemView.viewWithTag(99), // 태그로 백그라운드 뷰 찾기
               let imageView = backgroundView.viewWithTag(100) as? UIImageView {

                if index == selectedItemIndex {
                    backgroundView.backgroundColor = selectedColor
                    imageView.tintColor = .white

                    // 그림자 효과 추가
                    backgroundView.layer.shadowColor = selectedColor.cgColor
                    backgroundView.layer.shadowRadius = 10
                    backgroundView.layer.shadowOpacity = 0.5
                    backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)

                } else {
                    backgroundView.backgroundColor = .clear
                    imageView.tintColor = unselectedColor

                    // 그림자 효과 제거
                    backgroundView.layer.shadowOpacity = 0
                }
            }
        }
    }
}
