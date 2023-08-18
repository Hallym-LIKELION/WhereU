//
//  HomeHeader.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit
import SnapKit
import SkeletonView

class WeatherMainCell: UICollectionViewCell {
    
    //MARK: - Properties
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
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
            addViewModelObservers()
        }
    }
    
    private lazy var skeletonUI: [UIView] = [adviceLabel,weatherImageView]
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        backgroundImageView.addSubview(updateTimeLabel)
        updateTimeLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-12)
        }
        
        backgroundImageView.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        
        backgroundImageView.addSubview(adviceLabel)
        adviceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(weatherImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(10)
        }
        
        adviceLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(150)
        }
        
    }
    func addViewModelObservers() {
        guard let viewModel = viewModel else { return }
        
        viewModel.appendWeatherObserver {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.adviceLabel.text = viewModel.adviceText
                self.adviceLabel.textColor = viewModel.adviceTextColor
                self.updateTimeLabel.text = viewModel.upTimeText
                
                guard let (weatherImage, backgroundImage) = viewModel.weatherImage else { return }
                self.weatherImageView.image = weatherImage
                self.backgroundImageView.image = backgroundImage
                
                removeSkelton()
            }
        }
    }
    
    func addSkeleton() {
        self.isSkeletonable = true
        self.showSkeleton(usingColor: .lightGray)
        
        self.skeletonUI.forEach { view in
            view.addSkeletonEffect(baseColor: .gray)
        }
    }
    func removeSkelton() {
        self.stopSkeletonAnimation()
        self.hideSkeleton()
        
        self.skeletonUI.forEach { view in
            view.stopSkeletonAnimation()
            view.hideSkeleton()
        }
    }
}
