//
//  BoardViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/07/28.
//

import UIKit


class GuideViewController: UIViewController {
    //MARK: - Properties
    private let topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "9BC6E4")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "재난 가이드"
        label.font = .boldSystemFont(ofSize: 20.37)
        label.textColor = .white
        return label
    }()
    

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let viewModel : GuideViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel : GuideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(topBackgroundView)
        topBackgroundView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120.8)
        }
        
        topBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.14)
        }
        
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topBackgroundView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        // 가로방향 스크롤 섹션 레이아웃
        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = .horizontal

        // 세로방향 스크롤 섹션 레이아웃
        let verticalLayout = UICollectionViewFlowLayout()
        verticalLayout.scrollDirection = .vertical
        
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return self.createHorizontalSection(using: horizontalLayout)
            } else {
                return self.createVerticalSection(using: verticalLayout)
            }
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: NameStore.CategoryCell)
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: NameStore.ArticleCell)
        collectionView.register(ArticleHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NameStore.ArticleSectionHeader)
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NameStore.CategoryHeader)
        collectionView.backgroundColor = .white
    }
    
    // 가로 방향 섹션 레이아웃 만들기
    private func createHorizontalSection(using layout: UICollectionViewFlowLayout) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(74), heightDimension: .absolute(74))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(74), heightDimension: .estimated(74))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        // 섹션에 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(93)) // Header height is estimated
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        header.contentInsets = .init(top: 0, leading: 0, bottom: 14, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    // 세로 방향 섹션 레이아웃 만들기
    private func createVerticalSection(using layout: UICollectionViewFlowLayout) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(view.bounds.width - 40), heightDimension: .absolute(157))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(view.bounds.width - 40), heightDimension: .absolute(157))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 14
        section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        // 섹션에 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(62)) // Header height is estimated
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        section.boundarySupplementaryItems = [header]
        return section
    }
}

//MARK: - UICollectionViewDataSource
extension GuideViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 5 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = indexPath.section == 0 ? NameStore.CategoryCell : NameStore.ArticleCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if indexPath.section == 0 {
            let categoryCell = cell as! CategoryCell
            categoryCell.viewModel = CategoryViewModel(categoryIndex: indexPath.row)
            return categoryCell
        } else {
            let articleCell = cell as! ArticleCell
            articleCell.viewModel = ArticleViewModel()
            return articleCell
        }
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension GuideViewController : UICollectionViewDelegate {
    
    // 헤더 생성
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = indexPath.section == 0 ? NameStore.CategoryHeader : NameStore.ArticleSectionHeader
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        if indexPath.section == 0 {
            let categoryHeader = header as! CategoryHeader
            return categoryHeader
        } else {
            let articleHeader = header as! ArticleHeader
            return articleHeader
        }
        
    }
    
    // item 클릭
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // 카테고리
            viewModel.changedSelect(index: indexPath.row)
        } else {
            // 아티클
            
        }
    }
    
}
