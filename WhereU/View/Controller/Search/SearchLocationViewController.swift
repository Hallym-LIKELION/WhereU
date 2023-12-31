//
//  SearchLocationViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit
import MapKit
import CoreLocation

protocol SearchLocationCompleteDelegate: AnyObject {
    func updateLocation(address: String, x: Int, y: Int)
}

class SearchLocationViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "left_arrow"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.isHidden = true
        button.addTarget(self, action: #selector(handleClearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)
        textField.placeholder = "동면(읍,면) 으로 검색 (ex. 석사동)"
        textField.addTarget(self, action: #selector(handleSearchTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var searchStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [searchTextField, clearButton])
        sv.alignment = .center
        sv.distribution = .fill
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 4
        sv.spacing = 8
        sv.layer.borderColor = UIColor(named: "D9D9D9")?.cgColor
        sv.layer.borderWidth = 0.5
        sv.backgroundColor = UIColor(named: "F9F9F9")
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: .zero, right: 15)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    private lazy var findCurrentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitle("현재위치로 찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "9BC6E4")
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
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
        addViewModelObserver()
    }
    
    //MARK: - Helpers
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(9)
            make.height.width.equalTo(30)
        }
        
        view.addSubview(searchStack)
        searchStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(backButton.snp.right).offset(8)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(31)
        }
        
        view.addSubview(findCurrentLocationButton)
        findCurrentLocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(searchStack.snp.bottom).offset(13)
            make.height.equalTo(36)
        }
        
        view.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.top.equalTo(findCurrentLocationButton.snp.bottom).offset(25)
        }
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(27)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
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
    
    func addViewModelObserver() {
        viewModel.searchTextObserver = { [weak self] text in
            self?.searchTextField.text = text
            self?.searchLabel.text = self?.viewModel.searchResultText
            self?.searchLabel.isHidden = self?.viewModel.searchResultTextIsHidden ?? true
            self?.clearButton.isHidden = self?.viewModel.clearButtonIsHidden ?? true
        }
    }
    
    //MARK: - Actions
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleClearButtonTapped() {
        viewModel.searchTextChanged(text: "")
        resultTableView.reloadData()
    }
    
    @objc func handleSearchTextChanged(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        viewModel.searchTextChanged(text: searchText)
    }
    
    @objc func handleLocationButtonTapped() {
        viewModel.findCurrentLocation()
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        let suggestion = viewModel.searchResults[indexPath.row]
        viewModel.search(for: suggestion) { [weak self] x,y in
            let address = suggestion.title
            self?.delegate?.updateLocation(address: address, x: x, y: y)
        }

        navigationController?.popViewController(animated: true)
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
