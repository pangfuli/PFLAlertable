////
////  PFLShareAlertView.swift
////  JiuDingPay
////
////  Created by dongbailan on 16/4/5.
////  Copyright © 2016年 JIUDING Electronic Pay. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//class PFLShareAlertView: UIControl, Animationable {
//    
//    var image: UIImage?
//    weak var controller: UIViewController?
//    var shareUrl: String?
//    var shareText: String?
//    var shareImage: AnyObject?
//    var shareTitle: String?
//    
//    var title: String = "分享至"
//    private lazy var titleLabel: UILabel = {
//        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 40))
//        label.textAlignment = .Center
//        label.text = self.title
//        label.font = UIFont.systemFontOfSize(15)
//        let line = UIView(frame: CGRect(x: 10, y: label.bottom-1, width: kScreen_width-20, height: 1))
//        line.backgroundColor = UIColor.lightGrayColor()
//        line.centerX = label.centerX
//        label.addSubview(line)
//        return label
//    }()
//    
//    private lazy var shareBackView: UIView = {
//        let label: UIView = UIView(frame: CGRect(x: 0, y: self.titleLabel.bottom, width: kScreen_width, height: 175))
//        return label
//    }()
//
//    private lazy var shareButton: UIButton = {
//       let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: kScreen_width-20, height: self.titleLabel.height))
//        button.top = self.shareBackView.bottom
//        button.centerX = self.centerX
//        button.backgroundColor = UIColor(red: 85.0/255, green: 149.0/255, blue: 255.0/255, alpha: 1.0)
//        button.setTitle("取消分享", forState: .Normal)
//        button.titleLabel?.font = UIFont.systemFontOfSize(15)
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 4
//        button.addTarget(self, action: #selector(dismissAlertView), forControlEvents: .TouchUpInside)
//        return button
//    }()
//    
//    
//    deinit {
//        print("deinit===========\(self)==")
//    }
//    
//    required init(image:UIImage, controller: UIViewController, shareTitle: String?, shareText: String?, shareImage: AnyObject?, shareURL: String?) {
//        self.image = image
//        self.controller = controller
//        self.shareTitle = shareTitle
//        self.shareText = shareText
//        self.shareImage = shareImage
//        self.shareUrl = shareURL
//        super.init(frame: CGRect(x: 0, y: 0, width: kScreen_width, height: 280))
//        self.bottom = kScreen_height
//        self.backgroundColor = UIColor.whiteColor()
//        setupSubviews()
//    
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    var allSns = ["wxsession","wxtimeline","qq","qzone","tencent","sina","sms","renren"]
//    
//    private var platform: UMSocialSnsPlatform?
//    
//    private func setupSubviews() {
//        self.addSubview(titleLabel)
//        self.addSubview(shareBackView)
//        self.addSubview(shareButton)
//        layoutShareItems()
//    }
//    
//    private func layoutShareItems() {
//        
//        let w: CGFloat = 80
//        let h: CGFloat = 60
//        let gapX = (self.width - 4 * w)/5
//        let gapY: CGFloat = 10
//        for i in 0 ..< allSns.count {
//            let row = i / 4
//            let col = i % 4
//            let snsName = allSns[i]
//            let btn: UIButton = UIButton(frame: CGRect(x:CGFloat(col) * w + (CGFloat(col)+1) * gapX, y: (CGFloat(row)) * gapY*2 + gapY*1.5 + CGFloat(row) * h, width: w, height: h))
//            platform = UMSocialSnsPlatformManager.getSocialPlatformWithName(snsName)
//            btn.tag = i + 1
//            shareBackView.addSubview(btn)
//            btn.addTarget(self, action: #selector(PFLShareAlertView.shareMsgForPlatform(_:)), forControlEvents: .TouchUpInside)
//            btn.setImage(UIImage(named:"share_platform_\(snsName)"), forState: .Normal)
//            btn.setTitle(platform?.displayName ?? "", forState: .Normal)
//            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
//            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
//            btn.titleLabel?.textAlignment = .Center
//            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
//            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -w/2, bottom: -(h-20), right: 0)
//        }
//
//    }
//    
//    
//    
//    
//    @objc private func shareMsgForPlatform(btn:UIButton) {
//        //设置分享内容，和回调对象
//        dismissAlertView()
//        if btn.tag == allSns.count + 1 {return}
//        let socialData: UMSocialData = UMSocialData.defaultData()
//        socialData.shareImage = shareImage
//        socialData.title = shareTitle
//        socialData.shareText = shareText
//        let service: UMSocialControllerService = UMSocialControllerService(UMSocialData:socialData)
//        let snsName = allSns[btn.tag-1]
//        platform = UMSocialSnsPlatformManager.getSocialPlatformWithName(snsName)
//        guard let platform = platform else {return}
//        switch platform.shareToType {
//        case UMSocialSnsTypeAlipaySession:
//            socialData.extConfig.alipaySessionData.alipayMessageType = .Web
//            socialData.extConfig.alipaySessionData.url = shareUrl
//        case UMSocialSnsTypeMobileQQ:
//            socialData.extConfig.qqData.url = shareUrl
//        case UMSocialSnsTypeQzone:
//            socialData.extConfig.qzoneData.url = shareUrl
//        case UMSocialSnsTypeSms: fallthrough
//        case UMSocialSnsTypeRenr: fallthrough
//        case UMSocialSnsTypeSina:
//            socialData.shareText = (shareText ?? "") + (shareUrl ?? "")
//        default:
//            let urlResource: UMSocialUrlResource = UMSocialUrlResource()
//            urlResource.resourceType = UMSocialUrlResourceTypeWeb
//            urlResource.url = shareUrl
//            socialData.urlResource = urlResource
//        }
//        platform.snsClickHandler(controller,service,true)
//    }
//    
//    
//    lazy private var dynamicAnimator: UIDynamicAnimator = {
//        var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.bgWindow)
//        return dynamicAnimator
//    }()
//    
//    lazy private var bgWindow: UIWindow = {
//        var bgWindow: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
////        bgWindow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PFLShareAlertView.dismissAlertView)))
//        bgWindow.makeKeyAndVisible()
//        return bgWindow
//    }()
//    
//    
//    lazy private var bgCoverView: UIView = {
//        var bgCoverView: UIView = UIView(frame: UIScreen.mainScreen().bounds)
//        bgCoverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
////        bgCoverView.blurRadius = 10.0
////        bgCoverView.tintColor = UIColor.whiteColor()
//
//        func addBlur() {
//             //blur效果
//            if #available(iOS 8.0, *) {
//                let effect = UIBlurEffect(style: .Dark)
//                let visualEfView = UIVisualEffectView(effect: effect)
//                visualEfView.frame = CGRectMake(0, 0, kScreen_width, kScreen_height)
//                visualEfView.alpha = 1.0;
//                bgCoverView.addSubview(visualEfView)
//            } else {
//                let layer = CALayer()
//                layer.frame = UIScreen.mainScreen().bounds
//                bgCoverView.layer.addSublayer(layer)
//                layer.contents = self.image?.CGImage
//            
//            }
//        }
////        addBlur()
//        return bgCoverView
//    }()
//    
//    func show() {
//        self.bgWindow.addSubview(self.bgCoverView)
//        self.bgWindow.addSubview(self)
//        self.dynamicAnimator.addBehavior(self.addDropBehavior())
//        self.performAnimation()
//        self.dynamicAnimator.removeAllBehaviors()
//    }
//    
//    @objc private func dismissAlertView() {
//        self.dismissAnimation()
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * 0.31))
//        dispatch_after(popTime, dispatch_get_main_queue()) {
//            self.bgCoverView.removeFromSuperview()
//            for vi in self.subviews {
//                vi.removeFromSuperview()
//            }
//            self.removeFromSuperview()
//            self.bgWindow.hidden = true
//            UIApplication.sharedApplication().windows.first?.makeKeyWindow()
//            self.dynamicAnimator.removeAllBehaviors()
//        }
//    }
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
