//
//  PFLSwiftAlertView.swift
//  JiuDingPay
//
//  Created by pfl on 15/9/29.
//  Copyright © 2015年 QianHai Electronic Pay. All rights reserved.
//

import UIKit
import AudioToolbox
import IQKeyboardManagerSwift

let leadingX: CGFloat = 10
let trailingX: CGFloat = 10
let topYY: CGFloat = 40
let itemH: CGFloat = 30
let fontSize: CGFloat = 16
let btnH: CGFloat = 44
let alertViewWidth: CGFloat = 250
let deltaY: CGFloat = 5
let aCenter: CGPoint = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))

@objc protocol PFLSwiftAlertViewDelegate {
    optional
    func didClick(alertView: PFLSwiftAlertView, cancelButton:UIButton)
    optional
    func didClick(alertView: PFLSwiftAlertView, confirmButton:UIButton)
}

typealias cancelClosure = ()->()
typealias confirmClosure = ()->()
typealias textFieldDidEndEditingClosure = (sting: String)->()
typealias didSelectedIndexPathClosures = (String, NSInteger)->()





class PFLSwiftAlertView: UIView, Animationable {

    var didClickedCancelBtnClosure: cancelClosure?
    var didClickedConfirmBtnClosure: confirmClosure?
    var textFieldDidEndEditClosure: textFieldDidEndEditingClosure?
    var didSelectedIndexPathClosure: didSelectedIndexPathClosures?
    var passwordLength: Int = 6
    var message: String? {
        didSet {
            self.messageLabel?.text = message
        }
    }
    
    private var delegate: PFLSwiftAlertViewDelegate?
    private var cancelButtonTitle: String?
    private var confirmButtonTitle: String?
    private var tableView: UITableView?
    
    var title: String? {
        didSet {
            self.titleLabel?.text = title
        }
    }
    
    /**
     自定义alertView
     
     - parameter title:             标题
     - parameter message:           信息
     - parameter delegate:          代理
     - parameter cancelButtonTitle: 取消按钮
     - parameter otherButtonTitle:  确定按钮
     
     - returns: alertView
     */
    required init(title: String? = "提示", message: String?, delegate: AnyObject?, cancelButtonTitle: String?, otherButtonTitle: String?) {
        let rect: CGRect = CGRectMake(0, 0, alertViewWidth, 100)
        super.init(frame:rect)
        self.title = title
        self.delegate = delegate as? PFLSwiftAlertViewDelegate
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.confirmButtonTitle = otherButtonTitle
        self.frame = rect
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PFLSwiftAlertView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PFLSwiftAlertView.keyboardDidHide(_:)), name:UIKeyboardDidHideNotification, object: nil)
        
        if let _ = title {
            self.contentView.addSubview(self.titleLabel!)
        }
        
        if let _ = message {
            self.contentView.addSubview(self.messageLabel!)
        }
        
        if let _ = cancelButtonTitle {
            self.contentView.addSubview(self.cancelBtn!)
        }
        
        if let _ = confirmButtonTitle {
            self.contentView.addSubview(self.confirmBtn!)
        }
        
        self.contentView.addSubview(self.topLine)
        
        if let _ = cancelButtonTitle, _ = confirmButtonTitle {
            self.contentView.addSubview(self.midLine!)
        }
        
        self.adjustCenter()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    convenience init(withTableView tableView:UITableView) {
        self.init(title: "交易类别", message: nil, delegate: nil, cancelButtonTitle: nil, otherButtonTitle: "确定")
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.contentView.addSubview(tableView)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero;
        self.frame = CGRectMake(0, 0, alertViewWidth, 400)
        tableView.frame = CGRectMake(0, 40, self.bounds.width, self.bounds.height)
        adjustCenter()
    }
    
    var inputTextFieldPlaceholder = "请输入支付密码" {
        didSet {
            self.inputTextField.placeholder = inputTextFieldPlaceholder
        }
    }

    var dataSource: [String]? {
        didSet {
            if let tableView = self.tableView {
                if let dataSource = self.dataSource {
                    print(dataSource.count)
                    self.topY = CGFloat(dataSource.count) * itemH > 400 ? 400:CGFloat(dataSource.count) * itemH + btnH + itemH
                    tableView.frame.size.height = self.bounds.height - 40
                    adjustCenter()
                }
            }
        }
    }
    
    //MARK: itemsArr 与 hasTextField 不能同时设置
    var itemsArr: NSArray? {
        didSet {
            
            guard  self.alertViewType != .TextFieldType else {return};
            
            if let arr = itemsArr {
                if arr.count > 0 {
                    var y: CGFloat = 0;
                    if let lab = self.messageLabel {
                        y = CGRectGetMaxY(lab.frame) + topY / 4
                    }
                    else {
                        y = topY
                    }
                    for i in 0..<arr.count {
                        let label = UILabel(frame: CGRectMake(leadingX, y + CGFloat(i) * itemH, CGRectGetWidth(self.bounds) - 2*leadingX, itemH))
                        label.text = arr[i] as? String
                        label.textAlignment = .Left
                        label.textColor = UIColor.brownColor()
                        label.font = UIFont.systemFontOfSize(fontSize)
                        label.numberOfLines = 0
                        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        label.frame.size.height = self.getLabelHeight(label)
                        self.contentView.addSubview(label)
                        self.topY += itemH
                    }
                    
                    self.adjustCenter()
                }
            }
        }
    }
    
    //MARK:  itemsArr 与 hasTextField 不能同时设置
    private var hasTextField: String? {
        didSet {
            if let _ = hasTextField {
                self.contentView.addSubview(self.inputTextField)
                IQKeyboardManager.sharedManager().enable = false
            }
        }
    }
    
    var alertViewType: AlertViewType = .PlainType {
        didSet {
            switch (alertViewType) {
            case .PlainType:
                break
            case .TextFieldType:
                guard let itemsArr = itemsArr where itemsArr.count > 0 else {
                    self.contentView.addSubview(self.inputTextField)
                    IQKeyboardManager.sharedManager().enable = false
                    break
                }
                
            }
        }
    }

    var textFieldHeight: CGFloat = itemH {
        didSet {
            guard  alertViewType == .TextFieldType else{return}
            inputTextField.frame.size.height = textFieldHeight;
        }
    }
    
    
    private var topY: CGFloat = 0 {
        didSet {
            topY = topY>40 ? topY : 40
            self.frame.size.height = topY
            self.contentView.frame.size.height = topY
            self.center = aCenter
            print(self.contentView.frame)
            print(self.frame)
        }
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
        }
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        let kbHeight:CGFloat = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
        let kbRect: CGRect = CGRectMake(0, UIScreen.mainScreen().bounds.height - kbHeight, UIScreen.mainScreen().bounds.width, kbHeight)
        let point: CGPoint = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds)/2 + UIScreen.mainScreen().bounds.height/2)

        if (CGRectContainsPoint(kbRect, point)) {
            let deltaY: CGFloat =  point.y - kbRect.origin.y;
            self.frame.origin.y -= deltaY
        }
    }

    lazy private var contentView: UIView = {
        var contentView = UIView(frame: self.bounds)
        self.addSubview(contentView)
        return contentView
    }()
    
    lazy private var titleLabel: UILabel? = {
        
        if let title = self.title {
            var titleLabel: UILabel = UILabel(frame: CGRectMake(20, leadingX, CGRectGetWidth(self.bounds)-40, itemH))
            titleLabel.text = self.title
            titleLabel.font = UIFont.systemFontOfSize(fontSize)
            titleLabel.textAlignment = .Center
            self.contentView.addSubview(titleLabel)
            self.topY = CGRectGetMaxY(titleLabel.frame)
            return titleLabel
        }
        else {
            return nil
        }
    }()
    
    
    var isCenter: Bool = true {
        didSet {
            titleLabel?.textAlignment = isCenter ? .Center : .Left
        }
    }
    
    lazy private var messageLabel: UILabel? = {
        if let message = self.message {
            var messageLabel: UILabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(self.titleLabel!.frame), CGRectGetWidth(self.bounds), itemH))
            messageLabel.text = message
            messageLabel.font = UIFont.systemFontOfSize(fontSize - 2)
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            messageLabel.textAlignment = .Center
            messageLabel.frame.size.height = self.getLabelHeight(messageLabel);
            self.contentView.addSubview(messageLabel)
            self.topY = CGRectGetMaxY(messageLabel.frame)
            return messageLabel
 
        }
        else {
            return nil
        }
    }()

    lazy private var cancelBtn: UIButton? = {
        if let cancelTitle = self.cancelButtonTitle {
            var btn: UIButton = UIButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.5, btnH))
            btn.center = CGPointMake(CGRectGetMidX(self.bounds), self.topY + btnH * 0.5)
            btn.addTarget(self, action: #selector(PFLSwiftAlertView.btnPressed(_:)), forControlEvents: .TouchUpInside)
            btn.tag = 1
            btn.titleLabel?.font = UIFont.systemFontOfSize(fontSize + 1)
            btn.setTitle(cancelTitle, forState: .Normal)
            btn.setTitleColor(UIColor.redColor(), forState: .Normal)
            return btn
        }
        else {
            return nil
        }
    }()
    
    var cancelBtnColor: UIColor = UIColor.redColor() {
        didSet {
            guard let cancelBtn = cancelBtn else {return}
            cancelBtn.setTitleColor(cancelBtnColor, forState: .Normal)
        }
    }
    
    
    var confirmBtnColor: UIColor = UIColor.redColor() {
        didSet {
            guard let confirmBtn = confirmBtn else {return}
            confirmBtn.setTitleColor(confirmBtnColor, forState: .Normal)
        }
    }


    
    lazy private var confirmBtn: UIButton? = {
        if let confirmTitle = self.confirmButtonTitle {
            var btn: UIButton = UIButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.5, btnH))
            btn.center = CGPointMake(CGRectGetMidX(self.bounds), self.topY + btnH * 0.5)
            btn.addTarget(self, action: #selector(PFLSwiftAlertView.btnPressed(_:)), forControlEvents: .TouchUpInside)
            btn.tag = 2
            btn.titleLabel?.font = UIFont.systemFontOfSize(fontSize + 1)
            btn.setTitle(confirmTitle, forState: .Normal)
            btn.setTitleColor(UIColor.redColor(), forState: .Normal)
            return btn
        }
        else {
            return nil
        }
        }()
    
    lazy private var dynamicAnimator: UIDynamicAnimator = {
        var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.bgWindow)
        return dynamicAnimator
    }()
    
    lazy private var bgWindow: UIWindow = {
        var bgWindow: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        bgWindow.makeKeyAndVisible()
        return bgWindow
        }()

    lazy private var bgCoverView: UIView = {
        var bgCoverView: UIView = UIView(frame: UIScreen.mainScreen().bounds)
        bgCoverView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return bgCoverView
        }()

    lazy private var topLine: UIView = {
        
        var y: CGFloat =  (self.cancelBtn != nil) ? CGRectGetMinY(self.cancelBtn!.frame) : CGRectGetMinY(self.confirmBtn!.frame)
        var topLine: UIView = UIView(frame: CGRectMake(0, y - 0.5, CGRectGetWidth(self.bounds), 1))
        topLine.backgroundColor = UIColor.lightGrayColor()
        return topLine
    }()
    
    lazy private var midLine: UIView? = {
        if let _ = self.cancelButtonTitle,  _ = self.confirmButtonTitle {
            var midLine: UIView = UIView(frame: CGRectMake(0, 0, 1, btnH))
            midLine.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.confirmBtn!.frame))
            midLine.backgroundColor = UIColor.lightGrayColor()
            return midLine
        }
        else {
            return nil
        }
    }()
    
    lazy var inputTextField: UITextField = {
        
        var y: CGFloat = topYY/4
        if let msgL = self.messageLabel {
            y = CGRectGetMaxY(msgL.frame) + topYY/4
        }
        else if let titleL = self.titleLabel {
            y = CGRectGetMaxY(titleL.frame) + topYY/4
        }
        var inputTextField: UITextField = UITextField(frame: CGRectMake(leadingX, y, CGRectGetWidth(self.bounds)-2*leadingX, itemH))
        self.topY = CGRectGetMaxY(inputTextField.frame) + topYY/4
        inputTextField.placeholder = self.inputTextFieldPlaceholder
        inputTextField.textAlignment = .Center
        inputTextField.font = UIFont.systemFontOfSize(fontSize-1)
        inputTextField.delegate = self
        inputTextField.layer.cornerRadius = 3
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.grayColor().CGColor
        inputTextField.layer.masksToBounds = true
        self.adjustCenter()
        return inputTextField
    }()

    
    private func getLabelHeight(label: UILabel) -> CGFloat {
        
        var height: CGFloat = 0
        guard let text = label.text else {return height}
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0 {
            height = text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(label.frame), 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:label.font], context: nil).size.height
        }
        else {
            height = text.sizeWithAttributes([NSFontAttributeName:label.font]).height
        }
        return height
    }
    
    
    @objc private func btnPressed(btn: UIButton) {
        
        self.inputTextField.endEditing(true)
        
        switch (btn.tag) {
        case 1:
            if let cancelB = self.didClickedCancelBtnClosure {
                cancelB()
            }
            if let delegate = self.delegate {
                if (delegate as AnyObject).respondsToSelector(#selector(PFLSwiftAlertViewDelegate.didClick(_:cancelButton:))) {
                    delegate.didClick!(self, cancelButton: btn)
                }
                
            }
            
        case 2:
            
            if hasTextField != nil || alertViewType == .TextFieldType {
                if let txt = inputTextField.text where txt.utf8.count == 0 || txt.characters.count < passwordLength {
                    animationForNoneString()
                    return
                }
            }
            
            
            
            if let confirmB = self.didClickedConfirmBtnClosure {
                confirmB()
            }
            if let delegate = self.delegate {
                if (delegate as AnyObject).respondsToSelector(#selector(PFLSwiftAlertViewDelegate.didClick(_:confirmButton:))) {
                    delegate.didClick!(self, confirmButton: btn)
                }
            }

        default: break
        }
        self.dismissAlertView()
    }
    
    
    func animationForNoneString() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        let animationKeyPath = CAKeyframeAnimation(keyPath: "position.x")
        let centerX = CGRectGetMidX(self.bounds) * 0
        animationKeyPath.values = [centerX-6,centerX-4,centerX-2,centerX,centerX+2,centerX+4,centerX+6]
        animationKeyPath.keyTimes = [NSNumber(float: 0.1),NSNumber(float: 0.2),NSNumber(float: 0.4),NSNumber(float: 0.6),NSNumber(float: 0.7),NSNumber(float: 0.8),NSNumber(float: 0.9),NSNumber(float: 1.0)]
        animationKeyPath.duration = 0.3
        animationKeyPath.additive = true
        self.inputTextField.layer .addAnimation(animationKeyPath, forKey: "shake")
    }
    
    private func adjustCenter() {
        
        if let _ = self.confirmButtonTitle {
            self.confirmBtn?.frame.size.width = CGRectGetWidth(self.bounds)
            self.confirmBtn?.center.y = self.topY + btnH * 0.5 + deltaY
            self.confirmBtn?.center.x = CGRectGetWidth(self.bounds) * 0.5
        }
        if let _ = self.cancelButtonTitle {
            self.cancelBtn?.frame.size.width = CGRectGetWidth(self.bounds)
            self.cancelBtn?.center.y = self.topY + btnH * 0.5 + deltaY
            self.cancelBtn?.center.x = CGRectGetWidth(self.bounds) * 0.5
        }
        if let _ = self.cancelButtonTitle, _ = self.confirmButtonTitle {
            self.cancelBtn?.frame.size.width = CGRectGetWidth(self.bounds) * 0.5
            self.confirmBtn?.frame.size.width = CGRectGetWidth(self.bounds) * 0.5
            self.cancelBtn?.center.x = CGRectGetWidth(self.bounds) * 0.25
            self.confirmBtn?.center.x = CGRectGetWidth(self.bounds) * 0.75
            self.midLine!.center.y = self.cancelBtn!.center.y
            
        }
        
        if (self.cancelButtonTitle != nil) {
            self.topLine.center.y = CGRectGetMinY(self.cancelBtn!.frame)
        }
        else {
            self.topLine.center.y = CGRectGetMinY(self.confirmBtn!.frame)
        }
        self.topY += btnH + deltaY
        
        
    }
    
    
        
    func show() {
        self.bgWindow.addSubview(self.bgCoverView)
        self.bgWindow.addSubview(self)
        self.dynamicAnimator.addBehavior(self.addDropBehavior())
        self.performAnimation()
        self.dynamicAnimator.removeAllBehaviors()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dismissAlertView), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    @objc private func dismissAlertView() {
        self.dismissAnimation()
        self.dynamicAnimator.addBehavior(addBehavior())
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * 0.31))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.bgCoverView.removeFromSuperview()
            for vi in self.subviews {
                vi.removeFromSuperview()
            }
            self.removeFromSuperview()
            self.bgWindow.hidden = true
            UIApplication.sharedApplication().windows.first?.makeKeyWindow()
            self.dynamicAnimator.removeAllBehaviors()
        }
    }
    
    deinit {
        IQKeyboardManager.sharedManager().enable = true
        print("deinit=============")
    }
}

extension PFLSwiftAlertView: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if let isEndBlock = self.textFieldDidEndEditClosure, txt = textField.text {
            isEndBlock(sting: txt)
        }
    }
}


extension PFLSwiftAlertView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = self.dataSource![indexPath.row] as String
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if let closure = self.didSelectedIndexPathClosure, let dataSource = dataSource {
            closure(dataSource[indexPath.row], indexPath.row)
        }
        self.dismissAlertView()

    }
    
}












