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
        label.text = "장마철 집중호우로 인한 하천 범람 어쩌고 저쩌고"
        label.textColor = UIColor(named: "525252")
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let rightArrow: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "right_arrow"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [categoryLabel, contentLabel, rightArrow])
        sv.spacing = 10
        sv.distribution = .fillProportionally
        sv.alignment = .center
        return sv
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
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(23)
            make.right.equalToSuperview().offset(-23)
        }
        rightArrow.snp.makeConstraints { make in
            make.height.width.equalTo(10)
        }
    }
}
