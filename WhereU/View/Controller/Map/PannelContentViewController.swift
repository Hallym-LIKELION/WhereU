//
//  PannelContentViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/07.
//

import UIKit


final class PannelContentViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = viewModel.makeAttributedText()
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let viewModel: MapViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(17.7)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 50, bottom: 0, right: 50)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: NameStore.CategoryCell)
    }
    
    //MARK: - Actions
    
}

//MARK: - UICollectionViewDataSource
extension PannelContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameStore.CategoryCell, for: indexPath) as! CategoryCell
        cell.viewModel = CategoryViewModel(categoryIndex: indexPath.row + 1)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension PannelContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 카테고리 선택시
        viewModel.setCategory(selectedIndex: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PannelContentViewController: UICollectionViewDelegateFlowLayout {
    // 셀 수직 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    // 셀 수평 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 33
    }
    
    // cell의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 66 - 100) / 3
        return CGSize(width: width, height: width)
    }
}
