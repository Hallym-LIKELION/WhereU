//
//  ShelterViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit
import MapKit
import FloatingPanel

class ShelterViewController: UIViewController {
    
    //MARK: - Properties
    
    let mapView = MKMapView()
    let fpc = FloatingPanelController()
    
    let viewModel: ShelterViewModel

    
    //MARK: - LifeCycle
    
    init(viewModel: ShelterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupMapView()
        setupFloatingPannel()
        bindingViewModel()
        
        createAnnotaion()
    }
    
    //MARK: - Helpers
    
    private func bindingViewModel() {
        viewModel.locationObserver = { [weak self] coord in
            let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            self?.mapView.setRegion(region, animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.register(DisasterAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(DisasterAnnotationView.self))
        
        guard let coord = viewModel.currentLocation else { return }
        let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        mapView.setRegion(region, animated: true)
    }
    
    func setupFloatingPannel() {
        fpc.delegate = self
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 35
        fpc.surfaceView.appearance = appearance
//        fpc.layout = Floating()
        
        let contentVC = ShelterListViewController(viewModel: viewModel)
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        // content ViewController의 스크롤뷰를 추적?
//        fpc.track(scrollView: contentVC.tableView)
        
        // floatingPannelController의 부모를 현재 뷰컨트롤러로 지정
        fpc.addPanel(toParent: self)
    }
    
    func createAnnotaion() {
        ShelterManager.shared.fetchTest().forEach { shelter in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.lat, longitude: shelter.lon)
            annotation.title = shelter.areaName
            
            mapView.addAnnotation(annotation)
        }
    }
}

//MARK: - MKMapViewDelegate
extension ShelterViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        print("클릭! \(annotation.title)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 현재 위치 표시(점)도 일종에 어노테이션이기 때문에, 이 처리를 안하게 되면, 유저 위치 어노테이션도 변경 된다.
        // guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        guard !(annotation is MKUserLocation) else { return nil }

        
        // 식별자
        let identifier = "Custom"
        
        // 식별자로 재사용 가능한 AnnotationView가 있나 확인한 뒤 작업을 실행 (if 로직)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // 재사용 가능한 식별자를 갖고 어노테이션 뷰를 생성
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // 콜아웃 버튼을 보이게 함
            annotationView?.canShowCallout = true
            // 이미지 변경
            annotationView?.image = UIImage(named: "shelter_annotation")
            
            // 상세 버튼 생성 후 액세서리에 추가 (i 모양 버튼)
            // 버튼을 만들어주면 callout 부분 전체가 버튼 역활을 합니다
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        }
        
        
        return annotationView

    }
}
//MARK: - FloatingPanelControllerDelegate
extension ShelterViewController: FloatingPanelControllerDelegate {
    
}

extension ShelterViewController: ShelterListViewControllerDelegate {
    func item(seletedItem: Shelter) {
        let coord = CLLocationCoordinate2D(latitude: seletedItem.lat, longitude: seletedItem.lon)
        let region = MKCoordinateRegion(center: coord, span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
        
        fpc.move(to: .tip, animated: true)
        
    }
}
