//
//  YWTestDownFileCtrl.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import UIKit

class YWTestDownFileCtrl: YWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testBtn.isHidden = false
    }
    
    override func testAction() {
        super.testAction()
        
//        self.testSessionDownFile()
        
        YWAlamofireDownFile.download()
        
        self.testMessageLab.isHidden = false
        self.testMessageLab.text = "开始下载"
    }
    
    func testSessionDownFile() {
        let filePath = NSTemporaryDirectory() + "best.mlmodelBB"
        let url = URL(string: "https://v3-web.douyinvod.com/9331a6add701fd91f298c8b589315ee6/6726108c/video/tos/cn/tos-cn-ve-15/okLBBgPz5o84j0e1f7gpAC3BjzmAiEF2AKNaeH/?a=6383&ch=26&cr=3&dr=0&lr=all&cd=0%7C0%7C0%7C3&cv=1&br=535&bt=535&cs=0&ds=3&ft=pEaFx4hZffPdqK~-I1jNvAq-antLjrKUeMBNRkaVX0U9UjVhWL6&mime_type=video_mp4&qs=1&rc=PGZnOzwzZDY4ODdnOTY4ZkBpanltOWg6Zmk5bzMzNGkzM0AyNDZhMi8wXy0xMF4tNC1fYSNmYW5icjQwZDBgLS1kLS9zcw%3D%3D&btag=c0000e00038000&cquery=100o_100w_100B_100x_100z&dy_q=1730536362&feature_id=46a7bb47b4fd1280f3d3825bf2b29388&l=20241102163242A387AF267D29B48B2409&__vid=7297636753177890111")!
        
    
        
        YWSessionDownFile.downloadFile(from: url, toPath: filePath)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
