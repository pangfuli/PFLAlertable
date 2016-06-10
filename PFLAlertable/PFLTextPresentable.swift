//
//  PFLLabelAtributable.swift
//  JiuDingPay
//
//  Created by dongbailan on 16/4/4.
//  Copyright © 2016年 JIUDING Electronic Pay. All rights reserved.
//


protocol TextPresentable {
    var text_color: UIColor {get}
    var font: UIFont {get}
    var accountColor: UIColor{set get}
}

extension TextPresentable {
    var font: UIFont {
        return UIFont.systemFontOfSize(17)
    }

    var text_color: UIColor {
        return UIColor(red: 0.114, green: 0.278, blue: 0.463, alpha: 1.0)
    }
    
    var accountColor: UIColor {
        get {
            return UIColor.redColor()
        }
    }

    
}

















