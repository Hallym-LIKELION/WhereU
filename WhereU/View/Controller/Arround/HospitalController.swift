//
//  HospitalController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

class HospitalController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: HospitalSearchViewController(viewModel: viewModel))
        sc.searchBar.placeholder = "병원을 검색해보세요"
        sc.searchResultsUpdater = self
        sc.searchBar.autocapitalizationType = .none
        return sc
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 120
        tv.register(HospitalCell.self, forCellReuseIdentifier: HospitalCell.identity)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    
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
        
        viewModel.hospitalObserver = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setupNavigationBarItems() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 20)]
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = viewModel.address
        navigationItem.searchController = self.searchController
        
        let findShelterButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(handleArroundButtonTapped))
        findShelterButton.tintColor = .black
        navigationItem.setRightBarButton(findShelterButton, animated: true)
    }
    
    //MARK: - Actions
    
    @objc func handleArroundButtonTapped(_ button: UIButton) {
        let shelterViewModel = ShelterViewModel()
        let shelterVC = ShelterViewController(viewModel: shelterViewModel)
        navigationController?.pushViewController(shelterVC, animated: true)
    }
    
}

//MARK: - UITableViewDataSource
extension HospitalController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hospitalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HospitalCell.identity, for: indexPath) as! HospitalCell
        cell.configure(data: viewModel.hospitalList[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension HospitalController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewModel = HospitalDetailViewModel(hospital: viewModel.hospitalList[indexPath.row])
        let hospitalDetailVC = HospitalDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(hospitalDetailVC, animated: true)
    }
    
}

//MARK: - UISearchResultsUpdating
// 서치바에 검색하는 동안 새로운 화면을 보여주는 등 복잡한 내용 구현
extension HospitalController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text ?? ""
        viewModel.keyword = keyword
    }
}
