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
    private lazy var weatherHeaderView: HomeHeader = {
        let header = HomeHeader(viewModel: viewModel)
        return header
    }()
    
    private let naviIcon : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_navigate")
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return iv
    }()
    private let searchTextField: PaddingTextField = {
        let textfield = PaddingTextField(horizon: 18, vertical: 0)
        textfield.clipsToBounds = true
        textfield.layer.cornerRadius = 15
        textfield.backgroundColor = UIColor(named: "F4F6FA")
        textfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return textfield
    }()
    
    private lazy var searchStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [naviIcon, searchTextField])
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 11
        return sv
    }()
    
    let viewModel : HomeViewModel
    
    init(viewModel : HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(weatherHeaderView)
        weatherHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        view.addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherHeaderView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        searchTextField.delegate = self
    }
    
    // 화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

//MARK: - UICollectionViewDataSource
extension HomeViewController {
    
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchLocationViewController()
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true)
    }
    
}
