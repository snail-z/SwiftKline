//
//  AppDelegate.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/6.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var _window: NSWindow!
    var _windowVC: HomeWindowCotroller!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: Bundle.main)
        let homeVC = SecondViewController.init()
        
//        let aView = WakaView.init()
//        aView.wantsLayer = true
//        aView.backgroundColor = .orange
//        homeVC.view = aView
//        homeVC.viewDidLoad()
    
        
        let mask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        let rect = CGRect(x: 0, y: 0, width: 800, height: 600)
        _window = NSWindow.init(contentRect: rect, styleMask: mask, backing: .buffered, defer: true)
        _window.center()
        _window.appearance = NSAppearance.init(named: .vibrantLight)
        _window.titleVisibility = .hidden
        _window.titlebarAppearsTransparent = true
        _window.minSize = CGSize(width: 400, height: 200)
        _window.maxSize = CGSize(width: 1000, height: 600)
        _window.isReleasedWhenClosed = false
        _window.contentViewController = homeVC
//        _window.makeKey()
       
        /// 将window与APP绑定，如果不绑定，无法显示Window
//        NSApp.beginModalSession(for: _window)
        
        _windowVC = HomeWindowCotroller.init(window: _window)
        _windowVC.window?.center()
        _windowVC.window?.orderFront(nil)
//        _windowVC.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
//            _window.makeKeyAndOrderFront(self)
//            _windowVC.showWindow(nil)
        }
        return true
    }
    
    /// ??
//    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
//        return dockMenu
//    }
    
    @objc func likeTrack(_ sender: Any?) {
        print("likeTrack")
//        mainWindowController?.window?.contentViewController?
//            .performSelector(onMainThread: #selector(ViewController.likeTrack), with: nil, waitUntilDone: true)
    }
}

extension AppDelegate: NSWindowDelegate {
    
    func windowDidResize(_ notification: Notification) {
        print("windowDidResize")
    }
}

