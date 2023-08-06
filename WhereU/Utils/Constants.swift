//
//  Constant.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import Foundation

class Constants {
    static let KAKAO_APP_KEY = "edcc806528baee4b03aa033b29cf39ad"
    static let WEATHER_KEY = "YQIXp8EKAR6ZzAqzyMpwvhYYLuBDdXEKzeHn%2FENhqy1IQUBC4p%2Bg8l4Kr9EBvgQEVPdhILFgVODQvZRhfZyVZA%3D%3D"
    static let WEATHER_BASE_URL = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(WEATHER_KEY)&pageNo=1&numOfRows=288&dataType=JSON"
    static let APPLE_USER_ID = "AppleUserID" // Apple 로그인시 UID를 저장하기 위한 key
    static let LOGIN_PLATFORM = "LoginPlatform" // kakao or apple 중 어떤 플랫폼을 통해 로그인했는지 저장하기 위한 Key
    static let APPLE = "Apple"
    static let KAKAO = "Kakao"
    
}

class NameStore {
    static let searchResultCell = "searchResultCell"
    static let weatherMainCell = "WeatherMainCell"
    static let weatherForTimeCell = "WeatherForTimeCell"
    static let weatherDetailCell = "WeatherDetailCell"
    static let guideCell = "GuideCell"
    static let newsCell = "NewsCell"
}
