//
//  ArticleCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit

final class ArticleCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [mainLabel, subLabel])
        sv.axis = .vertical
        sv.spacing = 13
        sv.distribution = .fill
        sv.alignment = .leading
        return sv
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
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
        clipsToBounds = true
        layer.cornerRadius = 11
        
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        backgroundImageView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().offset(-35)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        mainLabel.attributedText = viewModel.makeMutableAttributedText()
        subLabel.text = viewModel.subLabelText
        backgroundImageView.image = viewModel.backgroundImage
    }
}
