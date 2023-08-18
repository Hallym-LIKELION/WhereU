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
    
    private let findShelterLabel: UILabel = {
        let label = UILabel()
        label.text = "자신의 근처, 재난 대피소 찾기"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var arroundShelterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(
            string: "근처 재난 대피소\t",
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
    
    private let findHospitalLabel: UILabel = {
        let label = UILabel()
        label.text = "자신의 근처 의료시설 찾기"
        label.font = .boldSystemFont(ofSize: 17)
        return label
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
        
        scrollView.addSubview(findShelterLabel)
        findShelterLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(57)
            make.left.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(arroundShelterButton)
        arroundShelterButton.snp.makeConstraints { make in
            make.top.equalTo(findShelterLabel.snp.bottom).offset(9)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(51)
            make.width.equalTo(234)
        }
        
        scrollView.addSubview(findHospitalLabel)
        findHospitalLabel.snp.makeConstraints { make in
            make.top.equalTo(arroundShelterButton.snp.bottom).offset(46)
            make.left.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(arroundHospitalButton)
        arroundHospitalButton.snp.makeConstraints { make in
            make.top.equalTo(findHospitalLabel.snp.bottom).offset(9)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(51)
            make.width.equalTo(234)
        }
        
        scrollView.addSubview(hospitalCategoryTitleLabel)
        hospitalCategoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(arroundHospitalButton.snp.bottom).offset(53)
            make.left.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(hospitalCategoryCollectionView)
        hospitalCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hospitalCategoryTitleLabel).offset(30)
            make.left.right.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(100)
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
    }
    
    //MARK: - Actions
    
    @objc func handleArroundButtonTapped(_ button: UIButton) {
        if button == arroundShelterButton {
            let shelterViewModel = ShelterViewModel()
            let shelterVC = ShelterViewController(viewModel: shelterViewModel)
            navigationController?.pushViewController(shelterVC, animated: true)
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension HospitalController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HospitalCategoryCell.identity, for: indexPath) as! HospitalCategoryCell
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
        return CGSize.init(width: 80, height: 100)
        
    }
    //section 내부 cell간의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        25
    }
    
}

//MARK: - UICollectionViewDelegate
extension HospitalController: UICollectionViewDelegate {
    
}
