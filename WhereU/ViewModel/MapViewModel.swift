//
//  MapViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    var currentLocation: CLLocationCoordinate2D?
    
    init() {
        LocationManager.shared.locationManager.requestWhenInUseAuthorization()
        currentLocation = LocationManager.shared.locationManager.location?.coordinate
    }
    
}
