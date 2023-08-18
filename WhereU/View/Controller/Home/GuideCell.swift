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
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .white
        return label
    }()
    
    var viewModel: ArticleViewModel? {
        didSet {
            configure()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func makeUI() {
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
    
    private func configure() {
        thumbnailImageView.image = viewModel?.backgroundImage
        titleLabel.attributedText = viewModel?.makeMutableAttributedText()
        tagLabel.text = viewModel?.tagText
    }
}
