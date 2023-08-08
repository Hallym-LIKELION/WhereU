//
//  ArticleViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit

final class ArticleViewModel {
    
    
    func makeMutableAttributedText() -> NSMutableAttributedString {
        let attrText = NSMutableAttributedString(
            string: "이럴때\n",
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        attrText.append(NSAttributedString(
            string: "산사태",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        ))
        attrText.append(NSAttributedString(
            string: " 의심할 수 있어요!",
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        ))
        return attrText
    }
    
}
