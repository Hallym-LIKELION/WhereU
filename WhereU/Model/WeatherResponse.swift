//
//  WeatherResponse.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/05.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let baseDate, baseTime: String
    let category: Category
    let fcstDate, fcstTime, fcstValue: String
    let nx, ny: Int
}

enum Category: String, Codable {
    case pcp = "PCP"
    case pop = "POP"
    case pty = "PTY"
    case reh = "REH"
    case sky = "SKY" // 하늘 상태
    case sno = "SNO"
    case tmn = "TMN" // 일 최저 기온
    case tmp = "TMP" // 1시간 기온
    case tmx = "TMX" // 일 최고 기온
    case uuu = "UUU"
    case vec = "VEC"
    case vvv = "VVV"
    case wav = "WAV"
    case wsd = "WSD"
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
