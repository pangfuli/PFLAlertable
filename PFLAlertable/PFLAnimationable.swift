//
//  PFLAnimationable.swift
//  JiuDingPay
//
//  Created by dongbailan on 16/3/29.
//  Copyright © 2016年 JIUDING Electronic Pay. All rights reserved.
//

import UIKit
import Foundation

protocol Animationable {
     func performAnimation()
     func performRotationAnimation()
     func dismissAnimation()
     func addBehavior() -> UIGravityBehavior
     func addDropBehavior() -> UIGravityBehavior
}

extension Animationable where Self: UIView {
    
    func performRotationAnimation() {
        let baseAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        baseAnimation.fromValue = NSNumber(double: 0)
        baseAnimation.fromValue = NSNumber(double: M_PI * 2)
        baseAnimation.duration = 0.03
        baseAnimation.repeatCount = 10
        self.layer.addAnimation(baseAnimation, forKey: nil)
    }
    
    func dismissAnimation() {
        let dismissAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        dismissAnimation.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
        dismissAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 1.0))
        dismissAnimation.removedOnCompletion = false
        
        let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(float: 1.0)
        opacityAnimation.toValue = NSNumber(float: 0)
        opacityAnimation.removedOnCompletion = false
        
        let groupAnimation: CAAnimationGroup = CAAnimationGroup()
        groupAnimation.duration = 0.3
        groupAnimation.removedOnCompletion = false
        groupAnimation.animations = [dismissAnimation, opacityAnimation]
        groupAnimation.fillMode = kCAFillModeForwards
        self.layer.addAnimation(groupAnimation, forKey: nil)
        
    }
    
    func performAnimation() {
        let baseAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        baseAnimation.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0))
        baseAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
        baseAnimation.duration = 0.3
        self.layer.addAnimation(baseAnimation, forKey: nil)
    }
    
    func addBehavior() -> UIGravityBehavior {
        let behavior: UIGravityBehavior = UIGravityBehavior()
        behavior.angle = CGFloat(M_PI_2)
        behavior.magnitude = 10
        behavior.addItem(self)
        return behavior
    }
    
    func addDropBehavior() -> UIGravityBehavior {
        let behavior: UIGravityBehavior = UIGravityBehavior()
        behavior.magnitude = 10
        behavior.addItem(self)
        return behavior
    }
    

}


protocol OptionalType {
    associatedtype T
    var asOptional: T? {get}
}
extension Optional: OptionalType {
    var asOptional: Wrapped? {return self}
}
extension SequenceType where Generator.Element: OptionalType {
    var flatMapped: [Generator.Element.T] {
        return self.flatMap {$0.asOptional}
    }
}










