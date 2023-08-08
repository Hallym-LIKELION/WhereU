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
        layout.scrollDirection = .vertical
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: NameStore.ArticleCell)
        collectionView.register(GuideHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NameStore.GuideHeader)
    }
}

//MARK: - UICollectionViewDataSource
extension GuideViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameStore.ArticleCell, for: indexPath) as! ArticleCell
        cell.viewModel = ArticleViewModel()
        return cell
    }
    
    // 헤더 생성
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NameStore.GuideHeader, for: indexPath) as! GuideHeader
        header.delegate = self
        return header
    }
}

extension GuideViewController: UICollectionViewDelegateFlowLayout {
    // 연속적인 셀 사이의 간격 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    // cell의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 40)
        return CGSize(width: width, height: 157)
    }
    // header의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 237)
    }
}

//MARK: - UICollectionViewDelegate
extension GuideViewController : UICollectionViewDelegate {
    // item 클릭
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show guide...
        
    }
    
}

extension GuideViewController: GuideHeaderDelegate {
    func header(changedCategory index: Int) {
        viewModel.changedSelect(index: index) // 카테고리 변경
        print(viewModel.selected.rawValue)
    }
    
    func touchUpSearchBar() {
        // move to search 
        
    }
}
