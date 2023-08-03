//
//  Extensions.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/03.
//

import UIKit

extension UIViewController {
    func activateNavigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
