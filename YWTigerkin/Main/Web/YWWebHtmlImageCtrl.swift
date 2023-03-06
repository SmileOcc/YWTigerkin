//
//  YWWebHtmlImageCtrl.swift
//  YWTigerkin
//
//  Created by odd on 2/26/23.
//

import UIKit
import WebKit
import SnapKit

class YWWebHtmlImageCtrl: YWBaseViewController, WKNavigationDelegate {

    var completeBlock: ((CGFloat,Bool)->Void)?

    var imgUrlArray:[String] = []
    
    lazy var webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero)
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        
        var thmConte2 = """
            <h3 style="text-align: left;"><strong>隐私政策</strong></h3><p><img src="https://zshc-web-fe.oss-cn-shenzhen.aliyuncs.com/test/pc_admin/version/app_remark/images/777_c59f68e5-48f1-4c29-b9a1-0b307531c630.png" alt="777_c59f68e5-48f1-4c29-b9a1-0b307531c630.png" data-href="" style=""/></p><p><img src="https://zshc-web-fe.oss-cn-shenzhen.aliyuncs.com/test/pc_admin/version/app_remark/images/user_logo.png" alt="user_logo.png" data-href="" style="width: 241.00px;height: 213.00px;"/>加点文字在这里</p><p style="text-align: left;">更新日期：{{ today }}</p><p style="text-align: left;">生效日期：{{ today }}</p>
            """

            //图片宽度限制
            let widet = 320

            let htmString = """
            <html> \n
            <head> \n
            <style type=\"text/css\"> \n
            body {font-size:15px;}\n
            </style> \n
            </head> \n
            <body>
            <script type='text/javascript'>
            window.onload = function(){\n
            var $img = document.getElementsByTagName('img');\n
            var maxWidth = \(widet);\n
            for(var k in $img){\n
            if($img[k].width> maxWidth){\n
             $img[k].style.width = maxWidth;\n
            }\n
            $img[k].style.height ='auto'\n
            }\n
            }
            </script>
            \(thmConte2)
            </body>
            </html>
            """
    
        self.webView.loadHTMLString(htmString, baseURL: nil)
    }
    

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let requestString = navigationAction.request.url?.absoluteString
        if (requestString?.hasPrefix("image-preview"))!{
          let imgUrl = NSString.init(string: requestString!).substring(from: "image-preview:".count )
          let index = imgUrlArray.index(of: imgUrl)
          //    present(browser, animated: true, completion: {})
          //
        }

        decisionHandler(.allow)

      }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        // 禁用长按弹出框
        webView.evaluateJavaScript(
          "document.documentElement.style.webkitTouchCallout='none';",
          completionHandler: nil)

        /// 禁止缩放
    //    let injectionJSString = """
    //            var script = document.createElement('meta');\
    //            script.name = 'viewport';\
    //            script.content="width=device-width, user-scalable=no";\
    //            document.getElementsByTagName('head')[0].appendChild(script);
    //            """
    //    webView.evaluateJavaScript(injectionJSString, completionHandler: nil)



        // 禁止放大缩小

        let injectionJSString1 =
        "var script = document.createElement('meta');" +
        "script.name = 'viewport';" +
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";" +
        "document.getElementsByTagName('head')[0].appendChild(script);"

        webView.evaluateJavaScript(injectionJSString1, completionHandler: nil)

        //调整图片大小
            //objs[i].setAttribute('width', '100%') //图片适应宽度
            //$img[k].style.width ='100%'
            let updateImageSizeJS = """
            function ResizeImages(){
            var $img = document.getElementsByTagName('img');
            var maxWidth = \(100);
            for(var k in $img){
              if($img[k].width> maxWidth){
                $img[k].style.width = maxWidth;
                $img[k].style.height ='auto';
              }
            }
            };
            """
            //拦截网页图片 并修改图片大小
        self.webView.evaluateJavaScript(updateImageSizeJS, completionHandler: nil)
        self.webView.evaluateJavaScript("ResizeImages();") { (data, err) in
              print(data)
              print(err)
            }


    //    //js方法遍历图片添加点击事件 返回图片个数
    //    let jsGetImages = """
    //      function getImages(){
    //      var objs = document.getElementsByTagName(\"img\");
    //      for(var i=0;i<objs.length;i++){
    //      objs[i].onclick=function(){
    //      document.location=\"myweb:imageClick:\"+this.src;
    //      };
    //      };
    //      return objs.length;
    //      };
    //      """
    //    self.evaluateJavaScript(jsGetImages)
        print("加载完成")

        let jsGetImages = """
        function getImages(){
        var objs = document.getElementsByTagName(\"img\");
        var imgScr = '';
        for(var i=0;i<objs.length;i++){
        imgScr = imgScr + objs[i].src + '+';
        };
        return imgScr;
        };
        """

        self.webView.evaluateJavaScript(jsGetImages, completionHandler: nil)

        webView.evaluateJavaScript("getImages()") { (data, err) in

          if let imageUrl = data as? String {

            var urlArry = imageUrl.components(separatedBy: "+")

            urlArry.removeLast()

//            self.imgUrlArray.addObjects(from: urlArry)
              self.imgUrlArray = urlArry

            for url in self.imgUrlArray{
              // elf.images.append(photo)


            }
            print("图片：\(self.imgUrlArray)")
          }
        }

        // 点击图片
       var jsClickImage:String
       jsClickImage =
        "function registerImageClickAction(){" +
        "var imgs=document.getElementsByTagName('img');" +
        "var length=imgs.length;" +
        "for(var i=0;i<length;i++){" +
        "img=imgs[i];" +
        "img.tIndex=i;" +
        "img.onclick=function(){" +
        "window.location.href='image-preview:'+this.src}" +
        "}" +
        "};"
       webView.evaluateJavaScript(jsClickImage, completionHandler: nil)
       webView.evaluateJavaScript("registerImageClickAction()", completionHandler: nil)




        //添加图片点击的回调
    //    webView.evaluateJavaScript("""
    //                function registerImageClickAction(){\
    //                   var imgs = document.getElementsByTagName('img');\
    //                   for(var i=0;i<imgs.length;i++){\
    //                     imgs[i].customIndex = i;\
    //                     imgs[i].onclick=function(){\
    //                      window.location.href='image-preview-index:'+this.customIndex;\
    //                     }\
    //                   }\
    //                 }
    //          """, completionHandler: nil)

    //    webView.evaluateJavaScript("registerImageClickAction();", completionHandler: nil)


        print("不准确的：heigth0: \(webView.scrollView.contentSize.height)")

        //网页高度
        webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)") {[weak self] (result, error) in

          guard let `self` = self else { return }

          if let heigth = result as? CGFloat {
            if let comBlock = self.completeBlock {
              comBlock(heigth,true)
            }
          }
          //self.frame.size.height = CGFloat(height)
        }

      }

}
