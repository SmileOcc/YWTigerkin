//
//  YWLottieView.swift
//  YWTigerkin
//
//  Created by odd on 8/22/23.
//

import UIKit
import Lottie

class YWLottieView: UIView {

    let lottieView = AnimationView()
    
    init(frame:CGRect, name:String!) {
        super.init(frame: frame)
        
        lottieView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        self.addSubview(lottieView)

        lottieView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        lottieView.animation = Animation.named(name)//绑定Lottie动画(替换成你自己的 json 动画)

        lottieView.loopMode = .playOnce//动画效果 执行单次、多次

        lottieView.contentMode = .scaleAspectFit

        lottieView.backgroundBehavior = .pauseAndRestore//设置进入后台是否暂停动画
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func play(completion:@escaping LottieCompletionBlock) {
        lottieView.play(completion: completion)
    }
    
    func play() {
        lottieView.play(completion: nil)
    }
    func stop() {
        lottieView.stop()
    }
    
    func play(progress:CGFloat) {
        lottieView.play(fromProgress: 1, toProgress: 1, loopMode: .playOnce, completion: nil)
    }


}
