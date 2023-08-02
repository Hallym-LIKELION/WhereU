//
//  SearchLocationViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit

protocol SearchLocationCompleteDelegate: AnyObject {
    func updateLocation(location: String)
}

class SearchLocationViewController: UIViewController {
    
    //MARK: - Properties
    private let searchBar = UISearchBar()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.text = "지역설정"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        return label
    }()
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_search")
        iv.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return iv
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.addTarget(self, action: #selector(handleClearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "지역 검색"
        return textField
    }()
    
    private lazy var searchStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [searchIcon, searchTextField, clearButton])
        sv.alignment = .center
        sv.distribution = .fill
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 8
        sv.spacing = 8
        sv.backgroundColor = UIColor(named: "F4F6FA")
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: .zero, right: 15)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    private lazy var findCurrentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("현재위치로 찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "845BED")
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 41).isActive = true
        return button
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "'서울' 검색 결과"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let resultTableView = UITableView()
    
    weak var delegate: SearchLocationCompleteDelegate?
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupTableView()
    }
    
    //MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        view.addSubview(searchStack)
        
        searchStack.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(46)
            make.left.equalTo(view).offset(29)
            make.right.equalTo(view).offset(-29)
            make.height.equalTo(40)
        }
        
        view.addSubview(findCurrentLocationButton)
        findCurrentLocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.top.equalTo(searchStack.snp.bottom).offset(15)
        }
        
        view.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(findCurrentLocationButton.snp.bottom).offset(25)
        }
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(SearchResultCell.self, forCellReuseIdentifier: NameStore.searchResultCell)
        resultTableView.separatorStyle = .none
        resultTableView.rowHeight = 40
    }
    
    //MARK: - Actions
    @objc func handleClearButtonTapped() {
        dismiss(animated: true)
    }
    
    //MARK: - Override
    
    // 화면 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - UITableViewDelegate
extension SearchLocationViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 테이블뷰 스크롤시 키보드 내림
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell 터치시
        delegate?.updateLocation(location: "서울특별시 마포구")
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameStore.searchResultCell, for: indexPath) as! SearchResultCell
        
        return cell
    }
    
    
}
