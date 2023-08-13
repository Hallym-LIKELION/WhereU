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
        addViewModelObservers()
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
        mapView.register(DisasterAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(DisasterAnnotationView.self))
    }
    
    func setupFloatingPannel() {
        fpc.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 35
        fpc.surfaceView.appearance = appearance
        fpc.layout = MyFloatingPanelLayout()
        
        let contentVC = PannelContentViewController(viewModel: viewModel)
        fpc.set(contentViewController: contentVC)
        // content ViewController의 스크롤뷰를 추적?
//        fpc.track(scrollView: contentVC.tableView)
        
        // floatingPannelController의 부모를 현재 뷰컨트롤러로 지정
        fpc.addPanel(toParent: self)
    }
    
    func addViewModelObservers() {
        viewModel.disasterObserver = { [weak self] disaster in
            DispatchQueue.main.async {
                self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
                
                if disaster.isEmpty {
                    self?.showAlert()
                    return
                }
                
                disaster.forEach { element in
                    let type = DisasterCategory.init(rawValue: element.warnVar)!
                    let coordinate = CLLocationCoordinate2D(latitude: element.lat, longitude: element.lon)
                    self?.addAnnotation(localName: element.areaName, type: type, coordinate: coordinate)
                }
            }
        }
        viewModel.loadingStateObserver = { [weak self] state in
            self?.showLoader(state)
        }
    }
    
    func addAnnotation(localName: String, type: DisasterCategory, coordinate: CLLocationCoordinate2D) {
        let annotation = DisasterAnnotation(localName: localName, disasterType: type, coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }
    
    // 식별자를 갖고 Annotation view 생성
    func setupAnnotationView(for annotation: DisasterAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        // dequeueReusableAnnotationView: 식별자를 확인하여 사용가능한 뷰가 있으면 해당 뷰를 반환
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(DisasterAnnotationView.self), for: annotation)
    }
    
    private func showAlert() {
        let action = UIAlertAction(title: "확인", style: .default)
        self.alert(title: "재난 위치", body: "현재 재난이 없습니다", style: .alert, actions: [action])
    }
    

}
//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 현재 위치 표시(점)도 일종에 어노테이션이기 때문에, 이 처리를 안하게 되면, 유저 위치 어노테이션도 변경 된다.
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        // 다운캐스팅이 되면 CustomAnnotation를 갖고 CustomAnnotationView를 생성
        if let disasterAnnotation = annotation as? DisasterAnnotation {
            annotationView = setupAnnotationView(for: disasterAnnotation, on: mapView)
        }
        
        return annotationView
    }
}
//MARK: - FloatingPanelControllerDelegate
extension MapViewController: FloatingPanelControllerDelegate {
    
}


class MyFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanel.FloatingPanelState = .tip
    
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
//            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 80.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}
