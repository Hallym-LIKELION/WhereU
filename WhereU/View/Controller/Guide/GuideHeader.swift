//
//  GuideHeader.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/08.
//

import UIKit

protocol GuideHeaderDelegate: AnyObject {
    func header(changedCategory index: Int)
    func touchUpSearchBar()
}

final class GuideHeader: UICollectionReusableView {
    
    //MARK: - Properties
    private lazy var searchBar: CustomSearchBar = {
        let sb = CustomSearchBar()
        sb.setBackgroundColor(color: UIColor(named: "F4F6FA"))
        sb.setPlaceHolder(text: "재난에 따른 가이드를 찾아보세요")
        sb.setRightButtonImage(image: UIImage(named: "icon_search"))
        sb.setTextFieldFont(font: .systemFont(ofSize: 15.64))
        sb.setTextFieldEnabled(value: false)
        sb.clipsToBounds = true
        sb.layer.cornerRadius = 30
        sb.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarTapped))
        sb.addGestureRecognizer(gestureRecognizer)
        return sb
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "5F5F5F")
        label.text = "아티클"
        return label
    }()
    
    weak var delegate: GuideHeaderDelegate?
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func makeUI() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(74)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(42)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: NameStore.CategoryCell)
    }
    
    //MARK: - Actions
    
    @objc func handleSearchBarTapped() {
        delegate?.touchUpSearchBar()
    }
    
}
//MARK: - UICollectionViewDataSource
extension GuideHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameStore.CategoryCell, for: indexPath) as! CategoryCell
        cell.viewModel = CategoryViewModel(categoryIndex: indexPath.row)
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GuideHeader: UICollectionViewDelegateFlowLayout {
    // 연속적인 셀 사이의 간격 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    // cell의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }
}

//MARK: - UICollectionViewDelegate
extension GuideHeader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.header(changedCategory: indexPath.row)
    }
}
