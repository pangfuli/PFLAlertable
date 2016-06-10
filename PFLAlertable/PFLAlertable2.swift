//
//  PFLAlertable.swift
//  JiuDingPay
//
//  Created by dongbailan on 16/3/28.
//  Copyright © 2016年 JIUDING Electronic Pay. All rights reserved.
//


@objc protocol PFLAlertable2 {
    optional func showMsg(msg: String, cancel: String?, ok: String?, handle:(()->())?, cancelHandle:(()->())?)
}

extension PFLAlertable2 {
   func showMsg(msg: String, cancel: String? = nil,ok: String? = "确定", handle:(()->())? = nil, cancelHandle:(()->())? = nil) {
        let alertView = PFLSwiftAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: cancel, otherButtonTitle: ok)
        alertView.didClickedConfirmBtnClosure = { _ in
            guard let handle = handle else{return}
            handle()
        }
    
        alertView.didClickedCancelBtnClosure = {
            guard let handle = cancelHandle else{return}
            handle()
        }
    
        alertView.show()
    }

}

