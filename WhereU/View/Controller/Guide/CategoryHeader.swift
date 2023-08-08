//
//  CategoryHeader.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//
import UIKit

class CategoryHeader: UICollectionReusableView {
    
    private let searchBar: CustomSearchBar = {
        let sb = CustomSearchBar()
        sb.setBackgroundColor(color: UIColor(named: "F4F6FA"))
        sb.setPlaceHolder(text: "재난에 따른 가이드를 찾아보세요")
        sb.setRightButtonImage(image: UIImage(named: "icon_search"))
        sb.setTextFieldFont(font: .systemFont(ofSize: 15.64))
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 30
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
