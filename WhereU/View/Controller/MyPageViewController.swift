//
//  MyPageViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit

class MyPageViewController: UIViewController {
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 정보"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요,\n이은재님"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = .clear
        return button
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        view.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.top.equalTo(titleLabel.snp.bottom).offset(53)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom).offset(36)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
    }


}
