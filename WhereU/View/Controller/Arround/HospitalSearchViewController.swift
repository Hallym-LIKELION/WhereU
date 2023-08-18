//
//  HospitalSearchViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

class HospitalSearchViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 120
        tv.register(HospitalCell.self, forCellReuseIdentifier: HospitalCell.identity)
        tv.dataSource = self
        return tv
    }()
    
    let viewModel: HospitalViewModel
    
    init(viewModel: HospitalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        bindingViewModel()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindingViewModel() {
        
        viewModel.searchListObserver = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
}

//MARK: - UITableViewDataSource
extension HospitalSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HospitalCell.identity, for: indexPath) as! HospitalCell
        cell.configure(data: viewModel.searchList[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension HospitalSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
}
