//
//  Guide.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import Foundation
// MARK: - GuideElement
struct GuideElement: Codable {
    let gid: Int
    let url: String
    let keyword: String
}

typealias Guide = [GuideElement]
