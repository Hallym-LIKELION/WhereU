//
//  ShelterListViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/18.
//

import UIKit

protocol ShelterListViewControllerDelegate: AnyObject {
    func item(seletedItem: Shelter)
}

class ShelterListViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var findCurrentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitle("현재위치로 찾기", for: .normal)
        button.setAttributedTitle(
            NSAttributedString(string: "현재 내 위치주변으로 찾아보기", attributes: [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]),
            for: .normal
        )
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "9BC6E4")
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 80
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    let cellIdentity = "shelterCell"
    
    let viewModel: ShelterViewModel
    weak var delegate: ShelterListViewControllerDelegate?
    
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
        
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(findCurrentLocationButton)
        findCurrentLocationButton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(30)
            make.height.equalTo(36)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(findCurrentLocationButton.snp.bottom).offset(28)
            make.left.right.bottom.equalToSuperview()
        }
        
    }

    
    //MARK: - Actions
    
    @objc func handleLocationButtonTapped() {
        
    }
}

//MARK: - UITableViewDataSource
extension ShelterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShelterManager.shared.fetchTest().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        cell.textLabel?.text = ShelterManager.shared.fetchTest()[indexPath.row].areaName
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension ShelterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.item(seletedItem: ShelterManager.shared.fetchTest()[indexPath.row])
    }
    
}
