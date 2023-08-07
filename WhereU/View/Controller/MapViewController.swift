//
//  MapViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    let mapView = MKMapView()
    
    let viewModel: MapViewModel
    
    //MARK: - LifeCycle
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        setupMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func setupMapView() {
        mapView.delegate = self
        
        guard let coord = viewModel.currentLocation else { return }
        let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
    }


}

extension MapViewController: MKMapViewDelegate {
    
}
