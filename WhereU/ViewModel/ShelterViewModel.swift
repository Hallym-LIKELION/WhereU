//
//  ShelterViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation
import CoreLocation

class ShelterViewModel {
    
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let coord = currentLocation else { return }
            locationObserver(coord)
        }
    }
    var locationObserver: (CLLocationCoordinate2D) -> Void = { _ in }
    
    var shelterList: [Shelter] = [] {
        didSet {
            shelterObserver(shelterList)
        }
    }
    var shelterObserver: ([Shelter]) -> Void = { _ in }
    
    
    init() {
        LocationManager.shared.locationManager.requestWhenInUseAuthorization()
        currentLocation = LocationManager.shared.locationManager.location?.coordinate
        
        guard let coord = currentLocation else { return }
        
        ShelterManager.shared.fetchArround(lat: coord.latitude, lon: coord.longitude) { [weak self] result in
            switch result {
            case .success(let list):
                self?.shelterList = list
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
