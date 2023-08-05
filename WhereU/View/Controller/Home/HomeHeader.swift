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
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "\(viewModel.name)님,"
        return label
    }()
    
    private let adviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "오늘은 우산을 챙겨나가세요"
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
    
    
    private let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(named: "A39898")
        label.text = "11:00 AM 업데이트됨"
        return label
    }()
    
    let viewModel: HomeViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
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

}
