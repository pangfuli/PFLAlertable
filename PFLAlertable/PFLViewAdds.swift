//
//  PFL.swift
//  JiuDingPay
//
//  Created by dongbailan on 16/4/11.
//  Copyright © 2016年 pfl. All rights reserved.
//

import UIKit

public protocol ViewFrameable {
     public var x: CGFloat {set get}
     public var y: CGFloat  {set get}
     public var left: CGFloat  {set get}
     public var right: CGFloat  {set get}
     public var top: CGFloat  {set get}
     public var bottom: CGFloat  {set get}
     public var width: CGFloat {set get}
     public var height: CGFloat {set get}
     public var centerX: CGFloat {set get}
     public var centerY: CGFloat {set get}
     public var center_: CGPoint {set get}
     public var origin: CGPoint {set get}
     public var size: CGSize {set get}
}

public extension ViewFrameable where Self: UIView {
    
     public var x: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.x
        }
    }
    
     public var y: CGFloat {
        set {
            self.frame = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.y
        }
    }
    
     public var top: CGFloat {
        set {
            self.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
     public var bottom: CGFloat {
        set {
            self.frame = CGRectMake(self.x, newValue - self.height, self.width, self.height)
        }
        get {
            return self.y + self.height
        }
    }
    
     public var left: CGFloat {
        set {
            self.x = newValue
        }
        get {
            return self.x
        }
    }
    
     public var right: CGFloat {
        set {
            self.frame = CGRectMake(newValue - self.width, self.y, self.width, self.height)
        }
        get {
            return self.x + self.width
        }
    }
    
     public var centerX: CGFloat {
        set {
            self.center = CGPointMake(newValue, centerY);
        }
        get {
            return self.x + self.width/2
        }
    }
    
     public var centerY: CGFloat {
        set {
            self.center = CGPointMake(centerX, newValue);
        }
        get {
            return self.y + self.height/2
        }
    }
    
     public var center_: CGPoint {
        set {
            self.center = newValue
        }
        get {
            return self.center
        }
    }
    
     public var origin: CGPoint {
        set {
            self.frame.origin = origin
        }
        get {
            return self.frame.origin
        }
    }
    
     public var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }

     public var width: CGFloat {
        set {
            self.frame = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
        get {
            return self.frame.size.width
        }
    }
    
     public var height: CGFloat {
        set {
            self.frame = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
        }
        get {
            return self.frame.size.height
        }
    }
    
}

public extension UIView: ViewFrameable {}








