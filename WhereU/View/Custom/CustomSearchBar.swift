//
//  CustomSearchBar.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit


@objc protocol CustomSearchBarDelegate: AnyObject {
    @objc optional func rightButtonTapped()
    @objc optional func searchTextChanged()
}

final class CustomSearchBar: UIView {
    
    //MARK: - Properties
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleRightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)
        textField.placeholder = "동면(읍,면) 으로 검색 (ex. 석사동)"
        textField.addTarget(self, action: #selector(handleSearchTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var searchStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [searchTextField, rightButton])
        sv.alignment = .center
        sv.distribution = .fill
        sv.clipsToBounds = true
        sv.backgroundColor = UIColor(named: "F9F9F9")
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: .zero, right: 15)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    weak var delegate: CustomSearchBarDelegate?
    
    
    //MARK: - LifeCycle
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        addSubview(searchStack)
        searchStack.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    func setBackgroundColor(color : UIColor?) {
        searchStack.backgroundColor = color
    }
    
    func setPlaceHolder(text : String) {
        searchTextField.placeholder = text
    }
    
    func setRightButtonImage(image: UIImage?) {
        rightButton.setImage(image, for: .normal)
    }
    
    func setLayoutMargins(inset: UIEdgeInsets) {
        searchStack.layoutMargins = inset
    }
    
    func setTextFieldFont(font: UIFont) {
        searchTextField.font = font
    }
    
    //MARK: - Actions
    @objc func handleRightButtonTapped() {
        delegate?.rightButtonTapped?()
    }
    
    @objc func handleSearchTextChanged() {
        delegate?.searchTextChanged?()
    }
}
