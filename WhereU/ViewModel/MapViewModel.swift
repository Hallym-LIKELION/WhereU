//
//  MapViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import Foundation
import CoreLocation
import UIKit

class MapViewModel {
    
    var currentLocation: CLLocationCoordinate2D?
    var selectedCategory: DisasterCategory? {
        didSet {
            // 재난 카테고리 변경 시
            fetchDisaster()
        }
    }
    
    var disaster: Disaster = [] {
        didSet {
            disasterObserver(disaster)
        }
    }
    var disasterObserver: (Disaster) -> Void = { _ in }
    
    init() {
        LocationManager.shared.locationManager.requestWhenInUseAuthorization()
        currentLocation = LocationManager.shared.locationManager.location?.coordinate
    }
    
    func makeAttributedText() -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(
            string: "지금, 대한민국에서 일어나는 재난을 알아볼 수 있습니다\n",
            attributes: [
                .foregroundColor: UIColor(named: "958D8D")?.withAlphaComponent(0.8) ?? .black,
                .font: UIFont.systemFont(ofSize: 13.58)
            ]
        )
        attrString.append(
            NSAttributedString(
                string: "찾고자 하는 재난 단어를 클릭해주세요",
                attributes: [
                    .foregroundColor: UIColor(named: "958D8D") ?? .black,
                    .font: UIFont.boldSystemFont(ofSize: 13.58)
                ]
            )
        )
        
        return attrString
    }
    
    func setCategory(selectedIndex: Int) {
        self.selectedCategory = DisasterCategory.categories[selectedIndex]
    }
    
    func fetchDisaster() {
        guard let categoryIndex = self.selectedCategory?.rawValue else { return }
        
        DisasterManager.shared.fetchDisasters(categoryIndex: categoryIndex) { [weak self] result in
            switch result {
            case .success(let disaster):
                self?.disaster = disaster
            case .failure(let error):
                switch error {
                case .invalidURL:
                    print("invalidURL Error")
                case .decodeError:
                    print("decodeError Error")
                case .emptyData:
                    print("emptyData Error")
                case .networkError:
                    print("networkError Error")
                case .timeout:
                    print("timeout Error")
                case .unknown:
                    print("unknown Error")
                }
                
                self?.disaster = []
            }
            
        }
    }
}
