//
//  SearchLocationViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit

class SearchLocationViewController: UIViewController {
    
    //MARK: - Properties
    private let searchBar = UISearchBar()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.text = "지역설정"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_search")
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return iv
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.addTarget(self, action: #selector(handleClearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        return textField
    }()
    
    private lazy var searchStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [searchIcon, searchTextField, clearButton])
        sv.alignment = .center
        sv.distribution = .fill
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 8
        sv.spacing = 8
        sv.backgroundColor = UIColor(named: "F4F6FA")
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: .zero, right: 15)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        view.addSubview(searchStack)
        
        searchStack.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(46)
            make.left.equalTo(view).offset(29)
            make.right.equalTo(view).offset(-29)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - Actions
    @objc func handleClearButtonTapped() {
        dismiss(animated: true)
    }
}
