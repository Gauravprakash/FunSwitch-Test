//
//  GMDCircularProgressView.swift
//  Travolution
//
//  Created by Hemant Singh on 05/01/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import Foundation

class GMDCircularProgressView: UIView, CAAnimationDelegate {
    
    let circularLayer = CAShapeLayer()
    
    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * Double.pi
        animation.duration = 2.0
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circularLayer.strokeColor = Theme.Colors.loaderStrokeColor.cgColor
        circularLayer.lineWidth = 4.0
        circularLayer.fillColor = nil
        layer.addSublayer(circularLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circularLayer.lineWidth / 2
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi / 2 + (2 * Double.pi)), clockwise: true)
        circularLayer.position = center
        circularLayer.path = arcPath.cgPath
        circularLayer.add(inAnimation, forKey: "strokeEnd")
        circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag) {
            animateProgressView()
        }
    }
    
    func animateProgressView() {
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 2.0
        strokeAnimationGroup.repeatCount = 1
        strokeAnimationGroup.animations = [inAnimation]
        strokeAnimationGroup.delegate = self
        circularLayer.removeAnimation(forKey: "strokeAnimation")
        circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
    }
}
