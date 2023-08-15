//
//  GuideSearchViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/08.
//

import UIKit

class GuideSearchViewController: UIViewController {
    //MARK: - Properties
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "left_arrow"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: CustomSearchBar = {
        let sb = CustomSearchBar()
        sb.setBackgroundColor(color: UIColor(named: "F4F6FA"))
        sb.setPlaceHolder(text: "재난에 따른 가이드를 찾아보세요")
        sb.setRightButtonImage(image: UIImage(named: "icon_search"))
        sb.setTextFieldFont(font: .systemFont(ofSize: 15.64))
        sb.delegate = self
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 30
        return sb
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let viewModel: GuideViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: GuideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
    }
    
    //MARK: - Helpers
    private func configure() {
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(30)
        }
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.left.equalTo(backButton.snp.right)
            make.right.equalToSuperview().offset(-23)
            make.height.equalTo(55)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: NameStore.ArticleCell)
    }

    //MARK: - Actions
    
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension GuideSearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.searchResult.count : viewModel.guidesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameStore.ArticleCell, for: indexPath) as! ArticleCell
        let guide = viewModel.isSearching ? viewModel.searchResult[indexPath.row] : viewModel.guide(index: indexPath.row)
        cell.viewModel = ArticleViewModel(guide: guide)
        return cell
    }
}

extension GuideSearchViewController: UICollectionViewDelegateFlowLayout {
    // 연속적인 셀 사이의 간격 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    // cell의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40)
        return CGSize(width: width, height: 157)
    }
}

//MARK: - UICollectionViewDelegate
extension GuideSearchViewController : UICollectionViewDelegate {
    // item 클릭
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show guide...
        let guide = viewModel.isSearching ? viewModel.searchResult[indexPath.row] : viewModel.guides[indexPath.row]
        let detailViewModel = GuideDetailViewModel(guide: guide)
        let detailVC = GuideDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: - CustomSearchBarDelegate
extension GuideSearchViewController : CustomSearchBarDelegate {
    func searchTextChanged(text: String?) {
        guard let text = text else { return }
        
        viewModel.keyword = text
        collectionView.reloadData()
    }
}
