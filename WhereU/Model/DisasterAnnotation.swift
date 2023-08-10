//
//  CustomAnnotation.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import UIKit
import MapKit

class DisasterAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var localName: String
    var disasterType: DisasterCategory
    
    init(localName: String, disasterType: DisasterCategory, coordinate: CLLocationCoordinate2D) {
        self.localName = localName
        self.disasterType = disasterType
        self.coordinate = coordinate
    }
    
    
}
