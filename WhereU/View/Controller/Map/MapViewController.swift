//
//  MapViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit
import MapKit
import FloatingPanel

class MapViewController: UIViewController {
    
    //MARK: - Properties
    let mapView = MKMapView()
    let fpc = FloatingPanelController()
    
    
    let viewModel: MapViewModel
    
    //MARK: - LifeCycle
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        setupMapView()
        setupFloatingPannel()
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
    
    func setupFloatingPannel() {
        fpc.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 35
        fpc.surfaceView.appearance = appearance
        
        let contentVC = PannelContentViewController()
        fpc.set(contentViewController: contentVC)
        // content ViewController의 스크롤뷰를 추적?
//        fpc.track(scrollView: contentVC.tableView)
        
        // floatingPannelController의 부모를 현재 뷰컨트롤러로 지정
        fpc.addPanel(toParent: self)

    }


}
//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
}
//MARK: - FloatingPanelControllerDelegate
extension MapViewController: FloatingPanelControllerDelegate {
    
}
