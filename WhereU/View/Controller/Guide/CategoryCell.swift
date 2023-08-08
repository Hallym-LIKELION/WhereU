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
        return iv
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.78)
        return label
    }()
    
    var viewModel: CategoryViewModel? {
        didSet {
            configure()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(named: "4C61D3")
                categoryTitleLabel.textColor = .white
                categoryImageView.tintColor = .white
            } else {
                backgroundColor = UIColor(named: "D9D9D9")
                categoryTitleLabel.textColor = .black
                categoryImageView.tintColor = .black
            }
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
    
    private func makeUI() {
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
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        categoryImageView.image = viewModel.icon
        categoryTitleLabel.text = viewModel.title
    }
}
