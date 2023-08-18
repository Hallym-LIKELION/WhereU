//
//  HospitalCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

class HospitalCell: UITableViewCell {
    
    //MARK: - Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, addressLabel, phoneLabel, typeLabel])
        sv.spacing = 4
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    static let identity = "HospitalCell"
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(data: Hospital) {
        
        nameLabel.text = data.name
        addressLabel.text = data.addr
        phoneLabel.text = data.phone
        typeLabel.text = data.type
        
        
    }
    
    
}

