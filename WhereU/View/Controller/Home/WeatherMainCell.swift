//
//  HomeHeader.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit
import SnapKit

class WeatherMainCell: UICollectionViewCell {
    
    //MARK: - Properties
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "bg_sunny")
        return iv
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "cloudy_1")
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var stackLabel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, adviceLabel])
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
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
      
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        backgroundImageView.layoutIfNeeded()
//
//        gradientLayer = backgroundImageView.addGradientWithAnimation()
//        (blurEffect, loadingIndicator) = backgroundImageView.addBlurEffect()
        
//    }
    
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
            make.width.height.equalTo(120)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        backgroundImageView.addSubview(stackLabel)
        stackLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(weatherImageView.snp.right).offset(20)
        }
        
    }
    func addViewModelObservers() {
        guard let viewModel = viewModel else { return }
        
        viewModel.appendWeatherObserver {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.adviceLabel.text = viewModel.adviceText
                self.adviceLabel.textColor = viewModel.adviceTextColor
                self.nameLabel.text = "\(viewModel.name)님,"
                self.nameLabel.textColor = viewModel.adviceTextColor
                self.updateTimeLabel.text = viewModel.upTimeText
                
                guard let (weatherImage, backgroundImage) = viewModel.weatherImage else { return }
                self.weatherImageView.image = weatherImage
                self.backgroundImageView.image = backgroundImage
                
//                UIView.animate(withDuration: 1) {
//                    self.blurEffect?.alpha = 0
//                    self.gradientLayer?.opacity = 0
//                }
//                loadingIndicator?.stopAnimating()
                
                
                
            }
        }
    }
}
