//
//  SearchLocationViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit
import MapKit

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
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "도시 검색"
        textField.addTarget(self, action: #selector(handleSearchTextChanged), for: .editingChanged)
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
        label.font = .boldSystemFont(ofSize: 14)
//        label.isHidden = true
        return label
    }()
    
    private let resultTableView = UITableView()
    
    private let noResultMainLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요.\n동네 이름을 다시 확인해주세요!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(named: "C3BEBE")
        return label
    }()
    
    private let noResultSubLabel: UILabel = {
        let label = UILabel()
        label.text = "동네 이름 다시 검색하기"
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(named: "477AE6")
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [noResultMainLabel, noResultSubLabel])
        sv.axis = .vertical
        sv.spacing = 18
        sv.alignment = .center
        sv.distribution = .fill
        sv.isHidden = true
        return sv
    }()
    
    let viewModel = SearchViewModel()
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
        setupSearchCompleter()
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
        
        view.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(236)
            make.left.right.equalToSuperview()
        }
    }
    
    func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(SearchResultCell.self, forCellReuseIdentifier: NameStore.searchResultCell)
        resultTableView.separatorStyle = .none
        resultTableView.rowHeight = 40
    }
    
    func setupSearchCompleter() {
        viewModel.setupSearchCompleter(delegate: self)
    }
    
    //MARK: - Actions
    @objc func handleClearButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func handleSearchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        viewModel.searchTextChanged(text: searchText)
        searchLabel.text = viewModel.searchResultText
        searchLabel.isHidden = viewModel.searchResultTextIsHidden
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
        let address = viewModel.searchResults[indexPath.row].title
        delegate?.updateLocation(location: address)
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameStore.searchResultCell, for: indexPath) as! SearchResultCell
        let address = viewModel.searchResultAddress(index: indexPath.row)
        cell.viewModel = SearchResultViewModel(address: address)
        return cell
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    // 검색 결과를 받아오는 메소드
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        viewModel.fetchSearchResults(results: completer.results)
        labelStack.isHidden = viewModel.noResultLabelIsHidden
        resultTableView.reloadData()
        
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
