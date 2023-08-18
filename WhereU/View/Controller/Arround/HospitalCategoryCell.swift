//
//  HospitalCategoryCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit


class HospitalCategoryCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 9
        iv.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8).cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
      
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "소아청소년과"
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [thumbnailImageView, categoryLabel])
        sv.axis = .vertical
        sv.spacing = 8.5
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()

    static let identity = "HospitalCategoryCell"

    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
    }
    
}
