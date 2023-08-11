//
//  GuideDetailViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation

class GuideDetailViewModel {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var guideURL: URL? {
        return URL(string: url)
    }
    
    var urlRequest: URLRequest? {
        guard let guideURL = guideURL else { return nil }
        return URLRequest(url: guideURL)
    }
    
}
