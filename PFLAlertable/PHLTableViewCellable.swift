//
//  PHLTableViewCellable.swift
//  PuhuiLife
//
//  Created by haq on 16/5/3.
//  Copyright © 2016年 JIUDING Electronic Pay. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellable {
    func adjustEdgeInsets()
}

extension TableViewCellable where Self: UITableViewCell {
    func adjustEdgeInsets() {
        if self.respondsToSelector(Selector("separatorInset")) {
            self.separatorInset = UIEdgeInsetsZero
        }
        if self.respondsToSelector(Selector("layoutMargins")) {
            if #available(iOS 8.0, *) {
                self.layoutMargins = UIEdgeInsetsZero
            } else {}
        }
    }
}

extension UITableViewCell: TableViewCellable {
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        self.adjustEdgeInsets()
    }
    
}
