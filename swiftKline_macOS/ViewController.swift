//
//  ViewController.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/6.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {

//    var _aView1: NSView!
//    
//    var _button: NSButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        _aView1 = NSView()
//        // wantsLayer - 调用该方法来开启layer支持. 必须写在前面？？ 否则不显示
//        _aView1.wantsLayer = true
//        _aView1.layer?.backgroundColor = NSColor.orange.cgColor
//        view.addSubview(_aView1)
//                
//        _aView1.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-20)
//            make.width.equalTo(300)
//            make.height.equalTo(200)
//            make.top.equalTo(100)
//        }
//        
//        _button = NSButton.init()
//        _button.layer?.backgroundColor = NSColor.purple.cgColor
//        _button.target = self
//        _button.action = #selector(next2)
//        view.addSubview(_button)
//        _button.layer?.borderColor = NSColor.cyan.cgColor
//        
//        _button.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-100)
//            make.width.equalTo(100)
//            make.height.equalTo(50)
//            make.top.equalTo(100)
//        }
//    }
//    
//    @objc func next2() {
//        _legal.makeKeyAndOrderFront(self)
//    }
//    
////    var oneVC: U1ViewController!
//    
//    lazy var _legal: NSWindow = {
//        let _window: NSWindow
//        let mask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
//        let rect = CGRect(x: 0, y: 0, width: 600, height: 400)
//        _window = NSWindow.init(contentRect: rect, styleMask: mask, backing: .buffered, defer: true)
//        _window.center()
//        _window.appearance = NSAppearance.init(named: .vibrantLight)
//        _window.titleVisibility = .hidden
//        _window.titlebarAppearsTransparent = true
//        _window.minSize = CGSize(width: 400, height: 200)
//        _window.maxSize = CGSize(width: 800, height: 600)
//        _window.isReleasedWhenClosed = false
////                _window.delegate = self
//        //        _window.frameAutosaveName = .
//        _window.collectionBehavior = .fullScreenPrimary
////        self.oneVC = U1ViewController.init()
////        self.oneVC.view = self.oneVC.u1View
////        _window.contentViewController = self.oneVC
//        return _window
//    }()
//
//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
}

