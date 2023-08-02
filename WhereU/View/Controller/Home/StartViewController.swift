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
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "재난의 WAY, 웨얼유"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "근처에서 일어나는 재난 실시간 알림부터\n재난 가이드까지,\n지금 내 위치를 선택하고 시작해보세요!"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var kakaoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "kakao_login"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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
    
    private lazy var logoLabelStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [logoImageView, mainLabel, subLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 14
        return sv
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
        view.addSubview(logoLabelStack)
        logoLabelStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.left.right.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
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
