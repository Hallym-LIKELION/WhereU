//
//  DisasterAnnotationView.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/10.
//

import UIKit
import MapKit

class DisasterAnnotationView: MKAnnotationView {
    
    //MARK: - Properties
    private let imageCircle: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0.064, green: 0.261, blue: 0.442, alpha: 1).withAlphaComponent(0.81)
        return view
    }()
    
    private let disasterImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let pointView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0.064, green: 0.261, blue: 0.442, alpha: 1).withAlphaComponent(0.81)
        return view
    }()
    
    //MARK: - LifeCycle
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 어노테이션 재사용시 다른 값 들어가는 것을 방지하는 코드 작성
        
    }
    
    private func configureUI() {
        self.addSubview(imageCircle)
        imageCircle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageCircle.addSubview(disasterImageView)
        disasterImageView.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.centerX.centerY.equalToSuperview()
        }
        
        self.addSubview(pointView)
        pointView.snp.makeConstraints { make in
            make.top.equalTo(imageCircle.snp.bottom).offset(1)
            make.centerX.equalTo(imageCircle)
            make.height.width.equalTo(10)
        }
        pointView.layer.cornerRadius = 5
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        // 어노테이션이 표시되기전에 호출되는 메서드
        // 뷰에 들어갈 값을 미리 설정
        
        guard let annotation = annotation as? DisasterAnnotation else { return }
        
        disasterImageView.image = annotation.disasterType.icon
        
        // 이미지의 크기 및 레이블의 사이즈가 변경될 수 있으므로 레이아웃을 업데이트 한다.
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        bounds.size = CGSize(width: 33, height: 37)
        imageCircle.roundCorners(topLeft: imageCircle.frame.width/2, topRight: imageCircle.frame.width/2, bottomLeft: imageCircle.frame.width/2 + 8, bottomRight: imageCircle.frame.width/2 + 8)

    }
    
}
