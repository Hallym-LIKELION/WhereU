//
//  LocationManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/03.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject {
    // 싱글톤 인스턴스 생성
    static let shared = LocationManager()
    var locationManager: CLLocationManager!
    
    private override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager {
    // 지오펜싱 : 지리 + 울타리
    // 지정한 위치의 반경에 Enter/Exit 상태를 모니터링
    func registLocation() {
        let location = CLLocationCoordinate2D(latitude: 37.4967867, longitude: 126.9978993)
        let region = CLCircularRegion(center: location, radius: 1.0, identifier: "id")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: region)
        print("region regist: \(region)")
    }
    
    
    func reverseGeoCodeLocation(completion: @escaping (String, (Int,Int)) -> Void) {
        guard let coor = locationManager.location?.coordinate else { return }
        
        let lat = coor.latitude
        let lon = coor.longitude
        
        let converter = LocationConverter()
        let (x,y) = converter.convertGrid(lon: lon, lat: lat)
        
        let findLocation = CLLocation(latitude: lat, longitude: lon)
        let geoCoder = CLGeocoder()
        let local = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { places, error in
            if let error = error {
                // 에러 발생
                print(error.localizedDescription)
                return
            }
            guard let place = places?.last,
                  let area = place.administrativeArea,
                  let local = place.locality else {
                print("주소가 없음")
                return
            }
            if let subLocal = place.subLocality {
                completion("\(area) \(local) \(subLocal)", (x,y))
            } else {
                completion("\(area) \(local)", (x,y))
            }
        }
    }
    
    func requestLocalNotification(title: String, body: String) {
        let options = UNAuthorizationOptions(arrayLiteral: [.badge, .sound, .alert])
        UNUserNotificationCenter.current().requestAuthorization(options: options) { [weak self] success, error in
            if success {
                self?.sendLocalNotification(title: title, body: body)
            } else {
                print("알림 허용 요청 오류 : \(error?.localizedDescription ?? "nil")")
            }
        }
    }
    
    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
//        content.userInfo = ["targetScene": "splash"] // 푸시 받을 때 오는 데이터 -> UserInfo를 사용해서 deep link 구현 가능
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            print(#function, error ?? "nil")
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            requestLocalNotification(title: "WhereU", body: "재난 발생 지역 근처입니다.\n재난 상황에 대비하세요!")
        case .outside:
            requestLocalNotification(title: "WhereU", body: "재난 발생 지역에서 벗어났습니다.")
        case .unknown: break
        }
    }
    
}
