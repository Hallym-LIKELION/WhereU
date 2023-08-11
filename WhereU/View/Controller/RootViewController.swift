//
//  ViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit
import CoreLocation

class RootViewController: UITabBarController {
    
    //MARK: - Properties
    let viewModel = RootViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetUp()
        fetchUser()
        checkLogin()
    }
    
    
    //MARK: - Helpers
    
    func baseSetUp() {
        view.backgroundColor = .white
        
        let tabBarAppear = UITabBarAppearance()
        tabBarAppear.configureWithOpaqueBackground()
        tabBarAppear.backgroundColor = .white
        tabBarAppear.shadowColor = .black
        tabBar.standardAppearance = tabBarAppear
        tabBar.scrollEdgeAppearance = tabBarAppear
    }
    
    func checkLogin() {
        viewModel.checkUserLoggedIn { isLoggedIn in
            if !isLoggedIn {
                DispatchQueue.main.async { [weak self] in
                    let startVC = StartViewController()
                    startVC.delegate = self
                    let nav = UINavigationController(rootViewController: startVC)
                    nav.modalPresentationStyle = .fullScreen
                    self?.present(nav, animated: true)
                }
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
        let mapViewModel = MapViewModel()
        let guideViewModel = GuideViewModel()
        
        let homeVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "home"),
            selectedImage: #imageLiteral(resourceName: "home"),
            rootViewController: HomeViewController(viewModel: homeViewModel)
        )
        let mapVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "pin"),
            selectedImage: #imageLiteral(resourceName: "pin"),
            rootViewController: MapViewController(viewModel: mapViewModel)
        )
        let guideVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "board"),
            selectedImage: #imageLiteral(resourceName: "board"),
            rootViewController: GuideViewController(viewModel: guideViewModel)
        )
        let myPageVC = templateNavigationController(
            unselectedImage: #imageLiteral(resourceName: "person"),
            selectedImage: #imageLiteral(resourceName: "person"),
            rootViewController: MyPageViewController()
        )
        viewControllers = [homeVC, mapVC, guideVC, myPageVC]
        tabBar.tintColor = UIColor(named: "53B4CB")
    }
    // 기본적인 셋팅이 끝난 NavigationController 생성해서 리턴
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        // 탭바의 뷰컨트롤러로 들어갈 UINavigationController를 생성 -> 탭바의 컨트롤러 각각은 UINavigationController임
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.isNavigationBarHidden = true
        nav.interactivePopGestureRecognizer?.delegate = nil
        return nav
    }
}
//MARK: - AuthenticationDelegate
extension RootViewController: AuthenticationDelegate {
    func authenticationComplete() {
        viewModel.checkUserLoggedIn { _ in } // 로그인 완료 시점에 다시 한번 호출
    }
}

