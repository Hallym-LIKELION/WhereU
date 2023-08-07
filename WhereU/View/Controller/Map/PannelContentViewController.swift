//
//  PannelContentViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit

protocol panelViewControllerDelegate: AnyObject {
    func panel()
}

final class PannelContentViewController: UIViewController {
    
    //MARK: - Properties
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음 화면", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: panelViewControllerDelegate?
    
    //MARK: - LifeCycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.width.equalTo(200)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    
    @objc func handleButtonTapped() {
        delegate?.panel()
    }
}
