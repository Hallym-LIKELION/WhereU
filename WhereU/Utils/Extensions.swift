//
//  Extensions.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/03.
//

import UIKit
import SkeletonView

extension UIViewController {
    func activateNavigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

extension String {
    func stringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}

extension UIView {
    func addSkeletonEffect(baseColor: UIColor) {
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: baseColor), animation: animation, transition: .crossDissolve(0.5))
    }
    
    func addBlurEffect() -> (UIVisualEffectView,UIActivityIndicatorView) {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        blurView.alpha = 1
        self.addSubview(blurView)
        blurView.frame = self.bounds
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.color = .white
        blurView.contentView.addSubview(loadingView)
        loadingView.center = blurView.center
        loadingView.startAnimating()
        return (blurView,loadingView)
    }
    
    func addGradient(colors: CGColor...) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0,1]
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    func addGradientWithAnimation() -> CAGradientLayer {
        let colors: [CGColor] = [
           .init(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1),
           .init(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1),
           .init(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        ]
        let changeColors: [CGColor] = [
           .init(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
           .init(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
           .init(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        ]

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame  = bounds
        gradientLayer.colors = colors
        gradientLayer.opacity = 0.4
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)

        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.toValue = changeColors
        colorAnimation.duration = 3
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        gradientLayer.add(colorAnimation, forKey: "colorChangeAnimation")
        
        return gradientLayer
    }
}
