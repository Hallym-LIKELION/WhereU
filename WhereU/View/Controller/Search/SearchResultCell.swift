//
//  SearchResultCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    //MARK: - Properties
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var viewModel: SearchResultViewModel? {
        didSet {
            configureUI()
        }
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NameStore.searchResultCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        locationLabel.text = viewModel.address
    }
}
