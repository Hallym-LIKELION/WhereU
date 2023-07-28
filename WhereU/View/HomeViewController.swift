//
//  HomeViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    //MARK: - Helpers
    
    func configure() {
        view.backgroundColor = .systemBlue
    }

}
