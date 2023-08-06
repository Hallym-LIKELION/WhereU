//
//  StartViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import UIKit
import AuthenticationServices

protocol AuthenticationDelegate: AnyObject {
    func authenticationComplete()
}

class StartViewController: UIViewController {
    
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "rainy_1")
        return iv
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.attributedText = viewModel.makeAttributedText()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var kakaoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "kakao_login"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleKakaoButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(handleAppleButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [kakaoButton, appleButton])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 22
        return sv
    }()
    
    private let viewModel = StartViewModel()
    weak var delegate: AuthenticationDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            make.left.equalToSuperview().offset(23.5)
            make.right.equalToSuperview()
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
    }
    
    //MARK: - Actions
    @objc func handleKakaoButtonTapped() {
        viewModel.kakaoLogin { [weak self] in
            self?.delegate?.authenticationComplete()
            self?.dismiss(animated: true)
        }
    }
    @objc func handleAppleButtonTapped() {
        viewModel.appleLogin(currentVC: self)
    }
}

extension StartViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.successAppleLogin(authorization: authorization)
        delegate?.authenticationComplete()
        dismiss(animated: true)
    }

    // Apple ID 연동 실패 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error.localizedDescription)
    }
}
