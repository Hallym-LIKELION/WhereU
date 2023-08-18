//
//  EmergencyCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

class EmergencyCell: UICollectionViewCell {
    
    //MARK: - Properties

    
    static let identity = "EmergencyCell"

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
        backgroundColor = .lightGray
        clipsToBounds = true
        layer.cornerRadius = 9
    }
    
}
