//
//  PaddingTextField.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit

class PaddingTextField: UITextField {
    
    init(
        horizon: Int,
        vertical: Int
    ) {
        super.init(frame: .zero)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: horizon, height: vertical))
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
