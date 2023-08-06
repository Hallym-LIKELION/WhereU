//
//  GuideCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/05.
//

import UIKit
import SkeletonView

class GuideCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "D9D9D9")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이럴때\n산사태 의심할 수 있어요!"
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "#산사태 #안전 #대피방법"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .white
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
    
    func configureUI() {
        [self, contentView, bottomBackgroundView, titleLabel, tagLabel].forEach { view in
            view.isSkeletonable = true
        }
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(120)
        }
        contentView.addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        bottomBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(16)
            make.height.greaterThanOrEqualTo(30)
            make.width.greaterThanOrEqualTo(100)
        }
        bottomBackgroundView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(100)
        }
        
        clipsToBounds = true
        layer.cornerRadius = 12
    }
}
