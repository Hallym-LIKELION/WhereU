//
//  HospitalDetailViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import Foundation
import CoreLocation

class HospitalDetailViewModel {
    
    let hospital: Hospital
    
    var coord: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: hospital.longit, longitude: hospital.latit)
    }
    
    var name: String {
        return hospital.name
    }
    
    var type: String {
        return hospital.type
    }
    
    var address: String {
        return hospital.addr
    }
    
    var phone: String {
        return hospital.phone
    }
    
    init(hospital: Hospital) {
        self.hospital = hospital
    }
    
    
}
