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
    
    // 특정 모서리만 둥글게
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
            let topLeftRadius = CGSize(width: topLeft, height: topLeft)
            let topRightRadius = CGSize(width: topRight, height: topRight)
            let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
            let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
            let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            layer.mask = shape
        }
}
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}
