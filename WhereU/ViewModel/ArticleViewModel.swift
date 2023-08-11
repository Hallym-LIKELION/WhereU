//
//  ArticleViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit

final class ArticleViewModel {
    
    let guide: GuideElement
    
    init(guide: GuideElement) {
        self.guide = guide
    }
    
    var backgroundImage: UIImage? {
        guard let index = DisasterCategory.categories.firstIndex(where: { guide.keyword.contains($0.name) }) else {
            return nil
        }
        return DisasterCategory.categories[index].image
    }
    
    var subLabelText: String {
        return "생활 속 \(guide.keyword) 대처요령을 알아보세요"
    }
    
    var guideUrl: String {
        return guide.url
    }
    
    func makeMutableAttributedText() -> NSMutableAttributedString {
        let attrText = NSMutableAttributedString(
            string: "생활속\n",
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        attrText.append(NSAttributedString(
            string: guide.keyword,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        ))
        attrText.append(NSAttributedString(
            string: " 대처요령",
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        ))
        return attrText
    }
    
    
    
}
