//
//  WeatherForTimeCell.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/06.
//

import UIKit

class WeatherForTimeCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [timeLabel, weatherImageView, tempLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 4
        return sv
    }()
    
    var viewModel: WeatherForTimeViewModel? {
        didSet {
            configureUI()
        }
    }
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(27)
        }
        
        guard let viewModel = viewModel else { return }
        timeLabel.text = viewModel.time
        weatherImageView.image = viewModel.weatherImage
        tempLabel.text = viewModel.temperature
    }
    
    
}

