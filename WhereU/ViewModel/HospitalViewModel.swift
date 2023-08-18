//
//  HospitalViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation

class HospitalViewModel {
    
    var address: String = "" {
        didSet {
            addressObserver(address)
        }
    }
    var addressObserver: (String) -> Void = { _ in }
    
    var hospitalList: [Hospital] = [] {
        didSet {
            hospitalObserver(hospitalList)
        }
    }
    var hospitalObserver: ([Hospital]) -> Void = { _ in }
    
    
    var searchList: [Hospital] = [] {
        didSet {
            searchListObserver(searchList)
        }
    }
    var searchListObserver: ([Hospital]) -> Void = { _ in }
    var keyword: String = "" {
        didSet {
            
            HospitalManager.shared.search(for: keyword) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.searchList = response
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    init() {
        
        LocationManager.shared.reverseGeoCodeLocation { [weak self] address, location in
            guard let self = self else { return }

            self.address = address
        }
        
        LocationManager.shared.locationManager.requestWhenInUseAuthorization()
        guard let coord = LocationManager.shared.locationManager.location?.coordinate else { return }
        
        HospitalManager.shared.fetchArround(lat: coord.longitude, lon: coord.latitude) { [weak self] result in
            switch result {
            case .success(let response):
                self?.hospitalList = response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
}
