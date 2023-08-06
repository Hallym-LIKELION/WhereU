//
//  WeatherDetailCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/06.
//

import UIKit
import SkeletonView

class WeatherDetailCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private lazy var localLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = " "
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .medium)
        label.text = " "
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .init(white: 1, alpha: 0)
        return cv
    }()
    
    private lazy var updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(named: "A39898")
        return label
    }()

    var viewModel: HomeViewModel? {
        didSet {
            configureUI()
            setupInitData()
            addViewModelObserver()

        }
    }
    
    private lazy var skeletonUI: [UIView] = [localLabel, tempLabel, collectionView, updateTimeLabel]
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupInnerCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.addGradient(colors: UIColor(red: 0.365, green: 0.506, blue: 0.639, alpha: 1).cgColor,
                            UIColor(red: 0.788, green: 0.822, blue: 0.896, alpha: 1).cgColor)
        
        contentView.addSubview(localLabel)
        localLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13.5)
            make.left.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(localLabel.snp.bottom).offset(5)
            make.left.equalTo(localLabel.snp.left)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        contentView.addSubview(updateTimeLabel)
        updateTimeLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-12)
        }
    }
    
    private func addViewModelObserver() {
        guard let viewModel = viewModel else { return }
        
        viewModel.appendWeatherObserver { [weak self] in
            DispatchQueue.main.async {
                self?.setupInitData()
            }
        }
    }
    
    private func setupInitData() {
        guard let viewModel = viewModel else { return }
        
        localLabel.text = viewModel.currentLocation
        tempLabel.text = viewModel.currentTemperature
        updateTimeLabel.text = viewModel.upTimeText
        collectionView.reloadData()
    }
    
    private func setupInnerCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeatherForTimeCell.self, forCellWithReuseIdentifier: NameStore.weatherForTimeCell)
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}

//MARK: - UICollectionViewDataSource
extension WeatherDetailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.weatherForTimeCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameStore.weatherForTimeCell, for: indexPath) as! WeatherForTimeCell
        cell.viewModel = WeatherForTimeViewModel(data: viewModel.getWeatherForTime(index: indexPath.row))
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WeatherDetailCell: UICollectionViewDelegateFlowLayout {
    //cell과 collectionview의 크기를 일치
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        return CGSize.init(width: 30, height: 80)
    }
    //section 내부 cell간의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
}

//MARK: - UICollectionViewDelegate
extension WeatherDetailCell: UICollectionViewDelegate {
    
}

