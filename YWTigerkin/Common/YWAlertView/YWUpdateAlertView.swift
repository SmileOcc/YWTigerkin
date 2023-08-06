//
//  YWUpdateAlertView.swift
//  YWTigerkin
//
//  Created by odd on 8/5/23.
//

import UIKit
import SnapKit

@objcMembers public class YWUpdateAlertAction: NSObject {
    
    @objc public enum YWUpdateAlertActionStyle: Int {
        case `default`, cancel, destructive, fullDefault, fullCancel, fullDestructive
    }
    
    fileprivate var title: String?
    fileprivate var style: YWUpdateAlertActionStyle = .default
    fileprivate var handler: ((YWUpdateAlertAction) -> Void)?

    @objc public class func action(title: String, style: YWUpdateAlertActionStyle, handler: @escaping ((YWUpdateAlertAction) -> Void)) -> YWUpdateAlertAction {
        return YWUpdateAlertAction(title: title, style: style, handler: handler)
    }

    public convenience init(title: String?, style: YWUpdateAlertActionStyle, handler: @escaping ((YWUpdateAlertAction) -> Void)) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class YWUpdateAlertView: UIView {

    let horizontalMargin = 16
    let verticalMargin = 16
    let buttonContentHeight = 48
    let messageTextViewMaxHeight = 120.0
    let defaultWidth = Int(uniHorLength(315)) //285
    
    let buttonTagOffset = 1000
    
    //let disposeBag = DisposeBag()
    
    @objc public var defaultTextColor = UIColor.hexColor("#2F79FF")
    @objc public var defaultTintColor = UIColor.hexColor("#0D50D8")
    @objc public var disableColor = UIColor.hexColor("#191919").withAlphaComponent(0.2)
    @objc public var textColorLevel1 = UIColor.hexColor("#2A2A34")
    @objc public var textColorLevel2 = UIColor.hexColor( "#191919").withAlphaComponent(0.5)
    @objc public var separatorLineColor = UIColor.hexColor("#191919").withAlphaComponent(0.05)
    
    @objc public var clickedAutoHide: Bool = true
    
    
    lazy var contentView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.layer(radius: 8, borderWidth: 0, borderColor: UIColor.clear)
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = textColorLevel1
        label.font = .systemFont(ofSize: uniHorLength(18), weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    @objc public lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_update")
        return imageView
    }()
    
    fileprivate lazy var buttons: [UIButton] = {
        let buttons = [UIButton]()
        return buttons
    }()
    
    fileprivate lazy var actions: [YWUpdateAlertAction] = {
        let actions = [YWUpdateAlertAction]()
        return actions
    }()
    
    fileprivate lazy var textContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var buttonContentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    
    @objc public convenience init(title: String? = nil, message: String, prompt: String? = nil) {
        self.init(frame: .zero)
        
        titleLabel.text = (title ?? "") + (prompt ?? "")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = uniHorLength(8)
        let attStr = NSMutableAttributedString(string: message, attributes: [.foregroundColor: textColorLevel1, .font: UIFont.systemFont(ofSize: 14,weight: .regular), .paragraphStyle: paragraphStyle])
        messageTextView.attributedText = attStr
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.yw_setOnlyLightStyle()
        
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textContentView)
        contentView.addSubview(buttonContentView)
        
        textContentView.addSubview(messageTextView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: Add Content
extension YWUpdateAlertView {

    @objc public func addAction(_ action: YWUpdateAlertAction) {
        if buttons.count >= 2 {
            return
        }
        
        let button = actionButton(with: action)
        buttonContentView.addSubview(button)
        buttons.append(button)
        actions.append(action)
    }
    
    @objc func layoutUIViews() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(defaultWidth)
            make.center.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(uniHorLength(40))
            make.right.equalTo(uniHorLength(-40))
            make.top.equalTo(imageView.snp.bottom).offset(uniHorLength(8))
        }
        
        textContentView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(horizontalMargin)
            make.right.equalTo(contentView.snp.right).offset(-horizontalMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
           
        }
        
//        var messageHeight = Int(messageTextView.attributedText.boundingRect(with: CGSize(width: defaultWidth - horizontalMargin * 2, height:Int.max), options: .usesLineFragmentOrigin, context: nil).size.height)
        
        let size = CGSize(width: CGFloat(defaultWidth) - CGFloat(horizontalMargin * 2), height: CGFloat.greatestFiniteMagnitude)
        var messageHeight = messageTextView.sizeThatFits(size).height
        if messageHeight > messageTextViewMaxHeight{
            messageHeight = messageTextViewMaxHeight
        }
        messageTextView.snp.makeConstraints { (make) in
            make.left.equalTo(textContentView).offset(horizontalMargin)
            make.right.equalTo(textContentView).offset(-horizontalMargin)
            make.top.equalTo(textContentView)
            make.bottom.equalTo(textContentView.snp.bottom)
            make.height.equalTo(messageHeight)
        }
        
        
        buttonContentView.snp.makeConstraints { (make) in
            make.top.equalTo(textContentView.snp.bottom).offset(14)
            make.left.right.equalTo(contentView)
            make.height.equalTo(0)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }
        
//        buttonContentView.translatesAutoresizingMaskIntoConstraints = false
        
        if (buttons.count > 0) {
            buttonContentView.snp.updateConstraints({ (make) in
                make.height.equalTo(buttonContentHeight + 15)
            })
            
            if buttons.count == 2 {
                buttons.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: CGFloat(horizontalMargin), leadSpacing: CGFloat(horizontalMargin), tailSpacing: CGFloat(horizontalMargin))
                buttons.snp.makeConstraints { (make) in
                    make.top.equalTo(buttonContentView)
                    make.height.equalTo(buttonContentHeight)
                }
                
            } else if buttons.count == 1 {
                let button = buttons.first
                button?.snp.makeConstraints({ (make) in
                    make.left.equalTo(buttonContentView).offset(horizontalMargin)
                    make.right.equalTo(buttonContentView).offset(-horizontalMargin)
                    make.top.equalTo(buttonContentView)
                    make.height.equalTo(buttonContentHeight)
                })
            }
        }
    }
}

//MARK: Method
extension YWUpdateAlertView {
    fileprivate func actionButton(with action: YWUpdateAlertAction) -> UIButton{
        let button = UIButton(type: .custom)
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tag = buttonTagOffset + buttons.count
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.3

        let style = action.style
        switch style {
        case .default:
            button.setTitleColor(defaultTextColor, for: .normal)
            break;
        case .cancel:
            button.setTitleColor(textColorLevel2, for: .normal)
            break;
        case .destructive:
            button.setTitleColor(.red, for: .normal)
            break;
        case .fullDefault:
            button.setTitleColor(.white, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = 4
            button.backgroundColor = UIColor.hexColor("#414FFF")
            break;
        case .fullCancel:
            button.clipsToBounds = true
            button.layer.cornerRadius = 6
            button.backgroundColor = disableColor
            button.setTitleColor(.white, for: .normal)
            break;
        case .fullDestructive:
            button.clipsToBounds = true
            button.layer.cornerRadius = 6
            button.backgroundColor = .red
            button.setTitleColor(.white, for: .normal)
            break;
        default:
            break;
        }
        button.addTarget(self, action: #selector(self.actionButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc fileprivate func actionButtonClicked(_ button: UIButton) {
        let action = actions[button.tag - buttonTagOffset];
        
        if (clickedAutoHide) {
            self.dismiss()

        }
        
        if let handler = action.handler {
            handler(action);
        }
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func showAlert() {
        self.frame = CGRect.init(x: 0, y: 0, width: YWConstant.screenWidth, height: YWConstant.screenHeight)
        self.alpha = 0.0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        self.layoutUIViews()

        if let kWindow = YWConstant.kKeyWindow() {
            kWindow.endEditing(true)
            kWindow.addSubview(self)
            
            UIView.animate(withDuration: 0.15) {
                self.alpha = 1
            } completion: { _ in
                
            }
        }
    
    }
}


