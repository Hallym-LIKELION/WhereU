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
    let topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "9BC6E4")
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "재난 가이드"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
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
        fpc.layout = MyFloatingPanelLayout()
        
        let contentVC = PannelContentViewController()
        contentVC.delegate = self
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

//MARK: - panelViewControllerDelegate
extension MapViewController: panelViewControllerDelegate {
    func panel() {
        
    }
}


class MyFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanel.FloatingPanelState = .tip
    
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}
