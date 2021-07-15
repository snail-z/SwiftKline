//
//  UIAlertController+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/7/12.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

#if canImport(AudioToolbox)
import AudioToolbox
#endif

public extension PKViewControllerExtensions where Base: UIAlertController {
    
    /// 显示信息提示框
    static func show(message: String? = nil, vibrate: Bool = false) {
        let alertController = UIAlertController(title: nil, message: message ?? "null", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        UIApplication.pk.keyWindow?.rootViewController?.present(alertController, animated: true)
        
        if vibrate {
            #if canImport(AudioToolbox)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            #endif
        }
    }
}

#endif
