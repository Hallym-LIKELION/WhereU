//
//  ViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit

class RootViewController: UITabBarController {
    
    //MARK: - Properties
    let viewModel = RootViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkLogin()
        fetchUser()
    }
    
    //MARK: - Helpers
    func checkLogin() {
        let isLoggedIn = viewModel.checkUserLoggedIn()

        if !isLoggedIn {
            DispatchQueue.main.async {
                let startVC = StartViewController()
                let nav = UINavigationController(rootViewController: startVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    func fetchUser() {
        viewModel.loginStateObserver = { [weak self] user in
            self?.configureViewControllers(user: user)
        }
    }
    
    func configureViewControllers(user: User) {
        view.backgroundColor = .white
        let homeViewModel = HomeViewModel(user: user)
        
        let homeVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "home"),
            selectedImage: #imageLiteral(resourceName: "home").withTintColor(.systemPurple),
            rootViewController: HomeViewController(viewModel: homeViewModel)
        )
        let mapVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "pin"),
            selectedImage: #imageLiteral(resourceName: "pin").withTintColor(.systemPurple),
            rootViewController: MapViewController()
        )
        let boardVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "board"),
            selectedImage: #imageLiteral(resourceName: "board").withTintColor(.systemPurple),
            rootViewController: BoardViewController()
        )
        let myPageVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "person"),
            selectedImage: #imageLiteral(resourceName: "person").withTintColor(.systemPurple),
            rootViewController: MyPageViewController()
        )
        viewControllers = [homeVC, mapVC, boardVC, myPageVC]
        let tabBarAppear = UITabBarAppearance()
        tabBarAppear.configureWithOpaqueBackground()
        tabBarAppear.backgroundColor = .white
        tabBarAppear.shadowColor = .black
        tabBar.standardAppearance = tabBarAppear
        tabBar.scrollEdgeAppearance = tabBarAppear
    }
    // 기본적인 셋팅이 끝난 NavigationController 생성해서 리턴
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        // 탭바의 뷰컨트롤러로 들어갈 UINavigationController를 생성 -> 탭바의 컨트롤러 각각은 UINavigationController임
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .white
        // UINavigationBarAppearance를 설정해야 NavBar의 background를 지정할 수 있음
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.black
//        ]
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        return nav
    }
}

