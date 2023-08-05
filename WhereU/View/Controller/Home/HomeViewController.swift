//
//  HomeViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit

let homeHeaderIdentifier = "HomeHeader"

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let scrollView = UIScrollView()
    
    private lazy var weatherHeaderView: HomeHeader = {
        let header = HomeHeader(viewModel: viewModel)
        return header
    }()
    
    private let naviIcon : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_navigate")
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return iv
    }()
    private let searchTextField: PaddingTextField = {
        let textfield = PaddingTextField(horizon: 18, vertical: 0)
        textfield.clipsToBounds = true
        textfield.layer.cornerRadius = 15
        textfield.placeholder = "지역 설정"
        textfield.backgroundColor = UIColor(named: "F4F6FA")
        textfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return textfield
    }()
    
    private lazy var searchStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [naviIcon, searchTextField])
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 11
        return sv
    }()
    
    private let divider : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "D9D9D9")
        return view
    }()
    
    private let tableView = UITableView()
    
    private let collectionViewTitle: UILabel = {
        let label = UILabel()
        label.text = "비가 많이 오는 날이에요"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8 // cell 간격 설정
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    let viewModel : HomeViewModel
    
    init(viewModel : HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupTableView()
        setupCollectionView()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(weatherHeaderView)
        weatherHeaderView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(scrollView)
            make.height.equalTo(200)
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(searchStackView)
        searchStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherHeaderView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        searchTextField.delegate = self
        
        scrollView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(searchStackView.snp.bottom).offset(22)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(116)
        }
        
        scrollView.addSubview(collectionViewTitle)
        collectionViewTitle.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(24)
        }
        scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(222)
        }
    }
    
    func setupTableView() {
        tableView.rowHeight = 58
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.separatorColor = UIColor(named: "D9D9D9")
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: "GuideCell")
        collectionView.showsHorizontalScrollIndicator = false
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.separatorInset = .zero
        return cell
    }
}
//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideCell", for: indexPath) as! GuideCell
        return cell
    }
    
    
}
//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }
}

//MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchLocationViewController()
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

//MARK: - SearchLocationCompleteDelegate

extension HomeViewController: SearchLocationCompleteDelegate {
    // SearchController의 대리자 역할 정의
    
    func updateLocation(location: String) {
        searchTextField.text = location
    }
}

