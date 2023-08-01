//
//  HomeViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit

let homeHeaderIdentifier = "HomeHeader"

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private let weatherHeaderView: HomeHeader = {
        let header = HomeHeader()
        return header
    }()
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(weatherHeaderView)
        weatherHeaderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        
    }

}

//MARK: - UICollectionViewDataSource
extension HomeViewController {
    
}
