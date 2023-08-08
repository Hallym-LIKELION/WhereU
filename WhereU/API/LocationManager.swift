//
//  LocationManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/03.
//

import Foundation
import CoreLocation

class LocationManager {
    // 싱글톤 인스턴스 생성
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    
    private init() {}
    
    func setupLocationManger(delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
}
