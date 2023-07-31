//
//  YWThemeCollectionView.swift
//  YWTigerkin
//
//  Created by odd on 3/26/23.
//

import UIKit

class YWThemeCollectionView: UICollectionView {

   var isRecognizeSimultaneously = false

    
}

// SHFullscreenPopGesture  与这个重复了
//extension YWThemeCollectionView: UIGestureRecognizerDelegate {
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        print("inView:\(String(describing: otherGestureRecognizer.view ?? nil))")
//        if otherGestureRecognizer.view is TestScorllView || self.isRecognizeSimultaneously {//添加不支持
//            return false
//        }
//        return true
//    }
//}

class TestScorllView: UIScrollView {
    
}
