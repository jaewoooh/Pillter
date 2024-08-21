//
//  CustomTabBarControllerViewController.swift
//  pillter
//
//  Created by 오재우 on 7/23/24.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        designTabBar()
        setupTabitem()
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
        
//        let chatbot = ChatBotController()
//        chatbot.view.backgroundColor = .white
//        chatbot.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 2)
        
        let alarm = UINavigationController(rootViewController: AlarmController())
        alarm.view.backgroundColor = .white
        alarm.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bell"), tag: 3)
        
        let mypage = UINavigationController(rootViewController: MyPageController())
        mypage.view.backgroundColor = .white
        mypage.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar"), tag: 4)
        
        viewControllers = [home, location, chatbot, alarm, mypage]
    }


    func designTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hexCode: "#2260FF")
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor.white
        itemAppearance.selected.iconColor = UIColor.white
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.layer.cornerRadius = 25
        tabBar.layer.masksToBounds = true
        
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = 40
        tabBar.itemSpacing = (UIScreen.main.bounds.width - 350) / CGFloat((tabBar.items?.count ?? 1) - 1)
        
        // 아이템의 이미지 크기 조정
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }

    func FrameTabBar() {
        var tabFrame = tabBar.frame
        tabFrame.size.height = 40 // 원하는 높이로 설정
        tabFrame.size.width = 350
        tabFrame.origin.x = (view.frame.size.width - tabFrame.size.width) / 2
        tabFrame.origin.y = view.frame.size.height - 80 // 화면 하단에 더 가깝게 배치
        tabBar.frame = tabFrame
        
        tabBar.layer.cornerRadius = tabFrame.height / 2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        FrameTabBar()
    }
}

    
