//
//  UIViewExt.swift
//  Uberish
//
//  Created by Miguel Santos on 09/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { 
            self.alpha = alphaValue
        }
    }
    

    func bindToKeybord() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: { 
            self.frame.origin.y += deltaY
        }, completion: nil)
    }

}
