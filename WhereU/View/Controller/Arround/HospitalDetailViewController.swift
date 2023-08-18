//
//  HospitalDetailViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit
import MapKit

class HospitalDetailViewController: UIViewController {
    
    //MARK: - Properties
    private let mapView = MKMapView()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var nameStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [typeLabel, nameLabel])
        sv.spacing = 4
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var infoStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [addressLabel, phoneLabel])
        sv.spacing = 4
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    let viewModel: HospitalDetailViewModel
    
    
    //MARK: - LifeCycle
    init(viewModel: HospitalDetailViewModel) {
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
        bindingViewModel()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(215)
        }
        
        view.addSubview(nameStack)
        nameStack.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(13)
        }
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(nameStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(10)
        }
        view.addSubview(infoStack)
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(13)
        }
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion(center: viewModel.coord, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))

        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = viewModel.coord
        annotation.title = viewModel.name
        annotation.subtitle = viewModel.phone
        mapView.addAnnotation(annotation)
    }
    
    func bindingViewModel() {
        navigationItem.title = viewModel.name
        
        typeLabel.text = viewModel.type
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        phoneLabel.text = viewModel.phone
        
    }
    
    
}

