//
//  NewsCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/05.
//

import UIKit

class NewsCell: UITableViewCell {
    
    //MARK: - Properties
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "재난 속보"
        label.textColor = UIColor(named: "53B4CB")
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "장마철 집중호우로 인한 하천 범람..."
        label.textColor = UIColor(named: "525252")
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    private let rightArrow: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "right_arrow"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "NewsCell")
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        [self,categoryLabel,contentLabel].forEach { view in
            view.isSkeletonable = true
        }
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(23)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-19)
            make.width.equalTo(50)
        }
        contentView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-23)
            make.height.width.equalTo(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryLabel.snp.right).offset(10)
            make.right.equalTo(rightArrow.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(300)
        }
        
        
        
    }
}
