//
//  YWNativeWebCtrl.swift
//  YWTigerkin
//
//  Created by 欧冬冬 on 2025/4/4.
//

import UIKit
@preconcurrency import WebKit


//web同层组件
class YWNativeWebCtrl: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gst = UITapGestureRecognizer()
        gst.addTarget(self, action: #selector(handleGestrues))
        return gst
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        webView.configuration.userContentController.add(self, name: "nativeViewHandler")
        


        if let path = Bundle.main.path(forResource: "aaa", ofType: "html") {
            do {
                let html = try String(contentsOfFile: path, encoding: .utf8)
                webView.loadHTMLString(html, baseURL: nil)
            } catch {
                print("Error loading HTML file: \(error)")
            }
        }
    }
    
    @objc func testAction() {
        print("========aaa")
        
        let alertController = UIAlertController(title: "", message: "message", preferredStyle: .alert)
        let okAciton = UIAlertAction(title: "确定", style: .default) { _ in
            
        }
        alertController.addAction(okAciton)
        present(alertController, animated: true, completion: nil)

    }
    @objc func handleGestrues() {

        
        if let viewClass = NSClassFromString("WKScrollView"), webView.scrollView.isKind(of: viewClass) {
            guard let _WKContentView = webView.scrollView.subviews.first else {
                return
            }
            guard let viewClass = NSClassFromString("WKContentView"), _WKContentView.isKind(of: viewClass) else {
                return
            }
            
            if let gestures = _WKContentView.gestureRecognizers {
                for gesture in gestures {
                    gesture.cancelsTouchesInView = false
                    gesture.delaysTouchesBegan = false
                    gesture.delaysTouchesEnded = false
                }
            }
        }
    }

}

// 实现 WKScriptMessageHandler 协议
extension YWNativeWebCtrl: WKScriptMessageHandler, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {


        decisionHandler(.allow)

      }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.addGestureRecognizer(self.tapGesture)
        
        handleGestrues()
        
    
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativeViewHandler" {
            print("Received message from JavaScript: \(message.body)")
            // 处理 JavaScript 发送的消息
            insertNativeView(message)
        }
        
    }
    
    func insertNativeView(_ message: WKScriptMessage) {
        
        print(message.body)

        guard let body = message.body as? [String: Any],
              let args = body["args"] as? [String: Any],
              let id = args["id"] as? String else {
            print("Invalid message format \(message.body)")
            return
        }
        
        print(args)
        // Create a UILabel for demonstration
        
        guard let v = findView(webView, str: "", ids: id) else {
            print("Target view not found")
            return
        }
        
        
        
        let c = YWNativeWebCommponent(frame: v.bounds)
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: v.frame.width, height: 100))
        l.backgroundColor = .orange
        l.font = UIFont.systemFont(ofSize: 40)
        l.text = "组件ID为：\(id)的原生同层组件"
        l.textAlignment = .center
        c.addSubview(l)
        
        let button = UIButton(type: .system)
        button.setTitle("按钮", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 200, width: v.frame.width, height: 100)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.addTarget(self, action: #selector(testAction), for: .touchUpInside)
        c.addSubview(button)
        
        // Find target container
        for sub in v.subviews {
            if sub.isKind(of: NSClassFromString("WKChildScrollView")!) {
                c.frame = sub.bounds
                sub.addSubview(c)
                // 同层组件区域会滑动，需要禁止
                if let scrollV = sub as? UIScrollView {
                    scrollV.isScrollEnabled = false
                }
            }
        }
    }
    
    // -  -  -  -  -  -  -  -  - WKCompositingView,RenderBlock 0x1350052f0 DIV 0x1350044b0 id='aa222' class='native'
    func findView(_ root: UIView?, str pre: String, ids: String) -> UIView? {
        guard let root = root else {
            return nil
        }
        
        print("\(pre)\(type(of: root)),\(root.layer.name ?? "")")
        
        if let layerName = root.layer.name, layerName.contains("id='\(ids)'") {
            return root
        }
        
        for v in root.subviews {
            if let res = findView(v, str: "\(pre) - ", ids: ids) {
                return res
            }
        }
        
        return nil
    }
}


//数据
//{
//    args =     {
//        frame =         {
//            height = "466.65625";
//            width = "771.1875";
//            x = "104.40625";
//            y = "1087.84375";
//        };
//        id = "common_222";
//        navType = navType;
//    };
//    command = nativeViewInsert;
//}
//["id": common_222, "frame": {
//    height = "466.65625";
//    width = "771.1875";
//    x = "104.40625";
//    y = "1087.84375";
//}, "navType": navType]
//WKWebView,
// - WKScrollView,
// -  - WKContentView,
// -  -  - UIView,FixedClipping
// -  -  -  - UIView,RootContent
// -  -  -  -  - WKCompositingView,drawing area root 6-1
// -  -  -  -  -  - WKCompositingView,content root
// -  -  -  -  -  -  - WKCompositingView,RenderView 0x133002cd0
// -  -  -  -  -  -  -  - WKCompositingView,TileGrid container
// -  -  -  -  -  -  -  - WKCompositingView,Page TiledBacking containment
// -  -  -  -  -  -  -  -  - WKCompositingView,RenderBlock 0x1330054f0 DIV 0x1330044b0 id='common_222' class='native'


//
//不过发现，当把一个 DOM 节点的 CSS 属性设置为 overflow: scroll （低版本需同时设置 -webkit-overflow-scrolling: touch）之后，WKWebView 会为其生成一个 WKChildScrollView，与 DOM 节点存在映射关系，这是一个原生的 UIScrollView 的子类，也就是说 WebView 里的滚动实际上是由真正的原生滚动组件来承载的。WKWebView 这么做是为了可以让 iOS 上的 WebView 滚动有更流畅的体验。虽说 WKChildScrollView 也是原生组件，但 WebKit 内核已经处理了它与其他 DOM 节点之间的层级关系，因此你可以直接使用 WXSS 控制层级而不必担心遮挡的问题。

//WKWebView 在内部采用的是分层的方式进行渲染，它会将 WebKit 内核生成的 Compositing Layer（合成层）渲染成 iOS 上的一个 WKCompositingView，这是一个客户端原生的 View，不过可惜的是，内核一般会将多个 DOM 节点渲染到一个 Compositing Layer 上，因此合成层与 DOM 节点之间不存在一对一的映射关系。
//但是当我们把一个 DOM 节点的 CSS 属性设置为 overflow: scroll （低版本需同时设置 -webkit-overflow-scrolling: touch）之后，并且该 DOM 下有一个高度超过该 DOM 节点高度的子节点，WKWebView 会为该 DOM 节点生成一个 WKChildScrollView，与 DOM 节点存在映射关系。这是一个原生的 UIScrollView 的子类，也就是说 WebView 里的滚动实际上是由真正的原生滚动组件来承载的，WKWebView 这么做是为了可以让 iOS 上的 WebView 滚动有更流畅的体验。
