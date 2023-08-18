//
//  HospitalController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

class HospitalController: UIViewController {
    
    //MARK: - Properties
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: HospitalSearchViewController())
        sc.searchBar.placeholder = "병원을 검색해보세요"
        return sc
    }()
    
    private lazy var arroundHospitalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(
            string: "근처 의료시설\t",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.black]),
            for: .normal
        )
        button.setImage(UIImage(named: "hospital"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.imageView?.contentMode = .scaleAspectFill
        button.largeContentImageInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8).cgColor
        button.addTarget(self, action: #selector(handleArroundButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let hospitalCategoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진료과로 자신에게 적합한 의료시설 찾기"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var hospitalCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private let emergencyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "응급상황에 맞는 대처방법"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var emergencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private let scrollView = UIScrollView()
    
    let viewModel: HospitalViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: HospitalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBarItems()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Helpers
    private func bindingViewModel() {
        
        viewModel.addressObserver = { [weak self] addr in
            self?.navigationItem.title = addr
        }
    }
    
    private func configureUI() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(arroundHospitalButton)
        arroundHospitalButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(42)
            make.left.equalToSuperview().offset(27)
            make.height.equalTo(51)
            make.width.equalTo(190)
        }
        
        scrollView.addSubview(hospitalCategoryTitleLabel)
        hospitalCategoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(arroundHospitalButton.snp.bottom).offset(53)
            make.left.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(hospitalCategoryCollectionView)
        hospitalCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hospitalCategoryTitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(emergencyTitleLabel)
        emergencyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalCategoryCollectionView.snp.bottom).offset(33)
            make.left.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(emergencyCollectionView)
     
        emergencyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(emergencyTitleLabel.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(205)
        }
    }
    
    private func setupNavigationBarItems() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 20)]
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = viewModel.address
        navigationItem.searchController = self.searchController
    }
    
    private func setupCollectionView() {
        hospitalCategoryCollectionView.register(HospitalCategoryCell.self, forCellWithReuseIdentifier: HospitalCategoryCell.identity)
        hospitalCategoryCollectionView.dataSource = self
        hospitalCategoryCollectionView.delegate = self
        hospitalCategoryCollectionView.showsHorizontalScrollIndicator = false
        hospitalCategoryCollectionView.contentInset = .init(top: 0, left: 26, bottom: 0, right: 26)
        
        emergencyCollectionView.register(EmergencyCell.self, forCellWithReuseIdentifier: EmergencyCell.identity)
        emergencyCollectionView.dataSource = self
        emergencyCollectionView.delegate = self
        emergencyCollectionView.showsHorizontalScrollIndicator = false
        emergencyCollectionView.contentInset = .init(top: 0, left: 26, bottom: 0, right: 26)
    }
    
    //MARK: - Actions
    
    @objc func handleArroundButtonTapped() {
        print("근처 의료시설")
    }
    
}

//MARK: - UICollectionViewDataSource
extension HospitalController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hospitalCategoryCollectionView {
            return 30
        } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identity = collectionView == hospitalCategoryCollectionView ? HospitalCategoryCell.identity : EmergencyCell.identity
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identity, for: indexPath)

        if collectionView == hospitalCategoryCollectionView {
            cell = cell as! HospitalCategoryCell
            
        } else {
            cell = cell as! EmergencyCell
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HospitalController: UICollectionViewDelegateFlowLayout {
    //cell과 collectionview의 크기를 일치
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        if collectionView == hospitalCategoryCollectionView {
            return CGSize.init(width: 80, height: 100)
        } else {
            return CGSize.init(width: (view.frame.width - 100) / 3, height: 90)
        }
        
    }
    //section 내부 cell간의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == hospitalCategoryCollectionView {
            return 25
        } else {
            return 25
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == hospitalCategoryCollectionView {
            return 0
        } else {
            return 25
        }
    }
    
    
    
}

//MARK: - UICollectionViewDelegate
extension HospitalController: UICollectionViewDelegate {
    
}
