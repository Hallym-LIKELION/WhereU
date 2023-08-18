//
//  CustomAnnotation.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import UIKit
import MapKit

class DisasterAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    let disasterType: DisasterCategory
    
    init(localName: String, disasterType: DisasterCategory, coordinate: CLLocationCoordinate2D) {
        
        self.title = localName
        self.subtitle = disasterType.name
        self.coordinate = coordinate
        
        self.disasterType = disasterType
        
    }
    
}

