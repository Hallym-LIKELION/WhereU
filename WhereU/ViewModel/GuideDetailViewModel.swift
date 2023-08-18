//
//  GuideDetailViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation

class GuideDetailViewModel {
    
    let guide: GuideElement
    
    init(guide: GuideElement) {
        self.guide = guide
    }
    
    var guideURL: URL? {
        return URL(string: guide.url)
    }
    
    var title: String {
        return "\(guide.keyword) 대처요령"
    }
    
    var urlRequest: URLRequest? {
        guard let guideURL = guideURL else { return nil }
        return URLRequest(url: guideURL)
    }
    
}
