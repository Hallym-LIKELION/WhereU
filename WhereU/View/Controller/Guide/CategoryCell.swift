//
//  CategoryCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "icon_fire")
        return iv
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "폭염"
        label.font = .systemFont(ofSize: 11.78)
        return label
    }()
    

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
        clipsToBounds = true
        layer.cornerRadius = 9
        backgroundColor = UIColor(named: "D9D9D9")
        
        contentView.addSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}