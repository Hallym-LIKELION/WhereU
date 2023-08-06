//
//  HomeHeader.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/01.
//

import UIKit
import SnapKit

class HomeHeader: UIView {
    
    //MARK: - Properties
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = viewModel.isNight ? #imageLiteral(resourceName: "bg_sunny_night") : #imageLiteral(resourceName: "bg_sunny")
        return iv
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "\(viewModel.name)님,"
        label.textColor = viewModel.adviceTextColor
        return label
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = viewModel.adviceTextColor
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
        label.text = viewModel.upTimeText
        return label
    }()
    
    var blurEffect: UIVisualEffectView?
    var loadingIndicator: UIActivityIndicatorView?
    var gradientLayer: CAGradientLayer?
    
    let viewModel: HomeViewModel
      
    //MARK: - LifeCycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureUI()
        addViewModelObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.layoutIfNeeded()
        gradientLayer = backgroundImageView.addGradient(isNight: viewModel.isNight)
        (blurEffect,loadingIndicator) = backgroundImageView.addBlurEffect()
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
            make.height.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(60)
        }
        backgroundImageView.addSubview(stackLabel)
        stackLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(weatherImageView.snp.right).offset(20)
        }
        
    }
    func addViewModelObservers() {
        viewModel.weatherObserver = {
            DispatchQueue.main.async { [weak self] in
                self?.adviceLabel.text = self?.viewModel.adviceText
                guard let (weatherImage, backgroundImage) = self?.viewModel.weatherImage else { return }
                self?.weatherImageView.image = weatherImage
                self?.backgroundImageView.image = backgroundImage
                
                UIView.animate(withDuration: 1) {
                    self?.blurEffect?.alpha = 0
                    self?.gradientLayer?.opacity = 0
                }
                self?.loadingIndicator?.stopAnimating()
            }
        }
    }
}
