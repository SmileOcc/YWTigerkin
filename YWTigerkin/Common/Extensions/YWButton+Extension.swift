//
//  YWButton+Extension.swift
//  YWTigerkin
//
//  Created by odd on 3/9/23.
//

import Foundation
import UIKit

typealias ButtonAction = (_ sender:UIButton)->()

extension UIButton {
    
    /**
     ///快捷调用
     btn.add_Action {sender in}
     ///想咋用咋用
     btn.addTouchAction(action:{sender in}, for: .touchUpInside)
     ///链式调用
     btn.addTouchUpInSideButtonAction { sender in
     }.addTouchUpOutSideButtonAction { sender in}
     */
    ///给 button 添加一个属性 用于记录点击的 tag
    private struct AssociatedKeys{
        static var actionKey = "UIButton+LRS+ActionKey"
    }
    @objc dynamic var actionDic: NSMutableDictionary? {
        set{
            objc_setAssociatedObject(self,&AssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let dic = objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? NSDictionary{
                return NSMutableDictionary.init(dictionary: dic)
            }
            return nil
        }
    }
    ///添加对应状态下的点击事件
    @objc dynamic func addTouchAction(action:@escaping  ButtonAction ,for controlEvents: UIControl.Event) {
        
        let eventStr = NSString.init(string: String.init(describing: controlEvents.rawValue))
        if let actions = self.actionDic {
            actions.setObject(action, forKey: eventStr)
            self.actionDic = actions
        }else{
            self.actionDic = NSMutableDictionary.init(object: action, forKey: eventStr)
        }
        
        switch controlEvents {
        case .touchUpInside:
            
            self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
            
        case .touchUpOutside:
            
            self.addTarget(self, action: #selector(touchUpOutsideAction), for: .touchUpOutside)
            
        case .valueChanged:
            
            self.addTarget(self, action: #selector(valueChangedAction), for: .valueChanged)
            ///可以继续添加 其他状态下的点击事件……
        default:
            
            self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
        }
    }
    
    
    @objc fileprivate func touchUpInSideAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpInSideAction = actionDic.object(forKey: String.init(describing: UIControl.Event.touchUpInside.rawValue)) as? ButtonAction{
                touchUpInSideAction(self)
            }
        }
    }
    
    @objc fileprivate func touchUpOutsideAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpOutsideButtonAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.touchUpOutside.rawValue)) as? ButtonAction{
                touchUpOutsideButtonAction(self)
            }
        }
    }
    
    @objc fileprivate func valueChangedAction(btn: UIButton) {
        if let actionDic = self.actionDic  {
            if let touchUpOutsideButtonAction = actionDic.object(forKey:   String.init(describing: UIControl.Event.valueChanged.rawValue)) as? ButtonAction{
                touchUpOutsideButtonAction(self)
            }
        }
    }
    
    ///快捷调用 事件类型为 .touchUpInside
    @objc func add_Action(_ action:@escaping ButtonAction){
        self.addTouchAction(action: action, for: .touchUpInside)
    }
    
    
    ///这俩方法就比较的牛了 让每一个点击事件都返回自身，为链式调用做准备
    @discardableResult
    func addTouchUpInSideButtonAction(_ action:@escaping ButtonAction) -> UIButton{
        self.addTouchAction(action: action, for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func addTouchUpOutSideButtonAction(_ action:@escaping ButtonAction) -> UIButton{
        self.addTouchAction(action: action, for: .touchUpOutside)
        return self
    }
    
}


// MARK:- 二、链式调用
public extension UIButton {

    // MARK: 2.1、设置title
    /// 设置title
    /// - Parameters:
    ///   - text: 文字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func title(_ text: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }

    // MARK: 2.2、设置文字颜色
    /// 设置文字颜色
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func textColor(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }

    // MARK: 2.3、设置字体大小(UIFont)
    /// 设置字体大小
    /// - Parameter font: 字体 UIFont
    /// - Returns: 返回自身
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    // MARK: 2.4、设置字体大小(CGFloat)
    /// 设置字体大小(CGFloat)
    /// - Parameter fontSize: 字体的大小
    /// - Returns: 返回自身
    @discardableResult
    func font(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    // MARK: 2.5、设置字体粗体
    /// 设置粗体
    /// - Parameter fontSize: 设置字体粗体
    /// - Returns: 返回自身
    @discardableResult
    func boldFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    // MARK: 2.6、设置图片
    /// 设置图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }

    // MARK: 2.7、设置图片(通过Bundle加载)
    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle: Bundle
    ///   - imageName: 图片名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    // MARK: 2.8、设置图片(通过Bundle加载)
    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - aClass: className bundle所在的类的类名
    ///   - bundleName: bundle 的名字
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(forParent aClass: AnyClass, bundleName: String, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    // MARK: 2.9、设置图片(纯颜色的图片)
    /// 设置图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func image(_ color: UIColor, _ size: CGSize = CGSize(width: 20.0, height: 20.0), _ state: UIControl.State = .normal) -> Self {
        let image = UIImage.imgColor(color, size)
        setImage(image, for: state)
        return self
    }

    // MARK: 2.10、设置背景图片
    /// 设置背景图片
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }

    // MARK: 2.11、设置背景图片(通过Bundle加载)
    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - aClass: className bundle所在的类的类名
    ///   - bundleName: bundle 的名字
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(forParent aClass: AnyClass, bundleName: String, _ imageName: String, _: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    // MARK: 2.12、设置背景图片(通过Bundle加载)
    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - bundle: Bundle
    ///   - imageName: 图片的名字
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(in bundle: Bundle? = nil, _ imageName: String, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    // MARK: 2.13、设置背景图片(纯颜色的图片)
    /// 设置背景图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 背景色
    ///   - state: 状态
    /// - Returns: 返回自身
    @discardableResult
    func bgImage(_ color: UIColor, _ state: UIControl.State = .normal) -> Self {
        let image = UIImage.imgColor(color, CGSize(width: 1.0, height: 1.0))
        setBackgroundImage(image, for: state)
        return self
    }
}


// MARK:- 三、UIButton 图片 与 title 位置关系
public extension UIButton {

    /// 图片 和 title 的布局样式
    enum ImageTitleLayout {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }

    // MARK: 3.1、设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// 设置图片和 title 的位置关系(提示：title和image要在设置布局关系之前设置)
    /// - Parameters:
    ///   - layout: 布局
    ///   - spacing: 间距
    /// - Returns: 返回自身
    @discardableResult
    func setImageTitleLayout(_ layout: ImageTitleLayout, spacing: CGFloat = 0) -> Self {
        switch layout {
        case .imgLeft:
            alignHorizontal(spacing: spacing, imageFirst: true)
        case .imgRight:
            alignHorizontal(spacing: spacing, imageFirst: false)
        case .imgTop:
            alignVertical(spacing: spacing, imageTop: true)
        case .imgBottom:
            alignVertical(spacing: spacing, imageTop: false)
        }
        return self
    }

    /// 水平方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageFirst: 图片是否优先
    private func alignHorizontal(spacing: CGFloat, imageFirst: Bool) {
        let edgeOffset = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -edgeOffset,
                                       bottom: 0,
                                       right: edgeOffset)
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: edgeOffset,
                                       bottom: 0,
                                       right: -edgeOffset)
        if !imageFirst {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        contentEdgeInsets = UIEdgeInsets(top: 0, left: edgeOffset, bottom: 0, right: edgeOffset)
    }

    /// 垂直方向
    /// - Parameters:
    ///   - spacing: 间距
    ///   - imageTop: 图片是不是在顶部
    private func alignVertical(spacing: CGFloat, imageTop: Bool) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else {
                return
        }
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
    
        let imageVerticalOffset = (titleSize.height + spacing) / 2
        let titleVerticalOffset = (imageSize.height + spacing) / 2
        let imageHorizontalOffset = (titleSize.width) / 2
        let titleHorizontalOffset = (imageSize.width) / 2
        let sign: CGFloat = imageTop ? 1 : -1
    
        imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                       left: imageHorizontalOffset,
                                       bottom: imageVerticalOffset * sign,
                                       right: -imageHorizontalOffset)
        titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                       left: -titleHorizontalOffset,
                                       bottom: -titleVerticalOffset * sign,
                                       right: titleHorizontalOffset)
        // increase content height to avoid clipping
        let edgeOffset = (min(imageSize.height, titleSize.height) + spacing)/2
        contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0, bottom: edgeOffset, right: 0)
    }
}


// MARK:- 四、自带倒计时功能的 Button（有待改进）
/// 自带倒计时功能的Button
/// - 状态分为 [倒计时中，倒计时完成]，分别提供回调
/// - 需要和业务结合时，后期再考虑
public extension UIButton {

    // MARK: 4.1、设置 Button 倒计时
    /// 设置 Button 倒计时
    /// - Parameters:
    ///   - count: 最初的倒计时数字
    ///   - timering: 倒计时中的 Block
    ///   - complete: 倒计时完成的 Block
    ///   - timeringPrefix: 倒计时文字的：前缀
    ///   - completeText: 倒计时完成后的文字
    func countDown(_ count: Int, timering: TimeringBlock? = nil, complete: CompletionBlock? = nil, timeringPrefix: String = "再次获取", completeText: String = "重新获取") {
        isEnabled = false
        let begin = ProcessInfo().systemUptime
        let c_default = UIColor.hexColor("#2798fd")
        let c_default_disable = UIColor.hexColor("#999999")
    
        self.textColor(titleColor(for: .normal) ?? c_default)
        self.textColor(titleColor(for: .disabled) ?? c_default_disable, .disabled)
        var remainingCount: Int = count {
            willSet {
                setTitle(timeringPrefix + "(\(newValue)s)", for: .normal)
                if newValue <= 0 {
                    setTitle(completeText, for: .normal)
                }
            }
        }
        self.invalidate()
        self.timer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        self.timer?.schedule(deadline: .now(), repeating: .seconds(1))
        self.isTiming = true
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.async {
                remainingCount = count - Int(ProcessInfo().systemUptime - begin)
                if remainingCount <= 0 {
                    if let cb = complete {
                        cb()
                    }
                    // 计时结束后，enable的条件
                    self.isEnabled = self.reEnableCond ?? true
                    self.isTiming = false
                    self.invalidate()
                } else {
                    if let tb = timering {
                        tb(remainingCount)
                    }
                }
            }
        })
        self.timer?.resume()
    }

    // MARK: 4.2、是否可以点击
    /// 是否可以点击
    var reEnableCond: Bool? {
        get {
            if let value = objc_getAssociatedObject(self, &TimerKey.reEnableCond_key) {
                return value as? Bool
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &TimerKey.reEnableCond_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: 4.3、是否正在倒计时
    /// 是否正在倒计时
    var isTiming: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &TimerKey.running_key) {
                return value as! Bool
            }
            // 默认状态
            return false
        }
        set {
            objc_setAssociatedObject(self, &TimerKey.running_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: 4.3、处于倒计时时，前缀文案，如：「再次获取」 + (xxxs)
    /// 处于倒计时时，前缀文案，如：「再次获取」 + (xxxs)
    var timeringPrefix: String? {
        get {
            if let value = objc_getAssociatedObject(self, &TimerKey.timeringPrefix_key) {
                return value as? String
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &TimerKey.timeringPrefix_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: 销毁定时器
    /// 销毁定时器
    func invalidate() {
        if self.timer != nil {
            self.timer?.cancel()
            self.timer = nil
        }
    }

    // MARK: 时间对象
    /// 时间对象
    var timer: DispatchSourceTimer? {
        get {
            if let value = objc_getAssociatedObject(self, &TimerKey.timer_key) {
                return value as? DispatchSourceTimer
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &TimerKey.timer_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    typealias TimeringBlock = (Int) -> ()
    typealias CompletionBlock = () -> ()
    private struct TimerKey {
        static var timer_key = "timer_key"
        static var running_key = "running_key"
        static var timeringPrefix_key = "timering_prefix_key"
        static var reEnableCond_key = "re_enable_cond_key"
   }
}

//MARK: - 按钮点击区域
extension UIButton {
    
    private struct customEdgeInset {
        
        static var top: String = "topkey"
        static var left: String = "leftkey"
        static var bottom: String = "botkey"
        static var right: String = "rightkey"
    }
    
    func setClickEdge(_ inset: CGFloat) {
        self.setClickEdge(inset, inset, inset, inset)
    }
    
    func setClickEdge(_ top: CGFloat,_ bot: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        
        objc_setAssociatedObject(self, &customEdgeInset.top, top, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &customEdgeInset.left, left, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &customEdgeInset.right, right, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &customEdgeInset.bottom, bot, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    func returnRect() -> CGRect{
        let top: CGFloat = objc_getAssociatedObject(self, &customEdgeInset.top) as? CGFloat ?? 0
        let left: CGFloat = objc_getAssociatedObject(self, &customEdgeInset.left) as? CGFloat ?? 0
        let bot: CGFloat = objc_getAssociatedObject(self, &customEdgeInset.bottom) as? CGFloat ?? 0
        let right: CGFloat = objc_getAssociatedObject(self, &customEdgeInset.right) as? CGFloat ?? 0
        if top>0 || left>0 || bot>0 || right>0 {
            return CGRect(x: self.bounds.origin.x-left, y: self.bounds.origin.y-top, width: self.bounds.size.width+left+right, height: self.bounds.size.height+top+bot)
        }else {
            return self.bounds
        }
    }
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = returnRect()
        if rect.contains(point) {
            print("当前点击位置",point)
            return self
        }else {
            return nil
        }
    }
    //或使用point(inside point: CGPoint, with event: UIEvent?)
//    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let rect = returnRect()
//        return rect.contains(point)
//    }
}
