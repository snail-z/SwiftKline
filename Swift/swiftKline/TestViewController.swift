
//
//  TestViewController.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/30.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    var textView: PKUITextView!
    
    func setup3() {
        textView = PKUITextView()
        textView.placeholder = "请输入"
        textView.placeholderColor = .white
        textView.backgroundColor = .gray
        textView.font = .systemFont(ofSize: 22)
        textView.placeholderInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 10)
        textView.textContainerInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 10)
        textView.adjustsToFitContentHeightAutomatically = true
        textView.automaticallyMaxNumberOfLines = 6
        view.addSubview(textView)
        
        DispatchQueue.pk.asyncAfter(delay: 5) {
            self.textView.automaticallyMaxNumberOfLines = 8
        }
        
            
//            textView.pk.makeConstraints { (make) in
//                make.left.equalTo(20)
//                make.width.equalTo(300)
//                make.bottom.equalTo(-450)
////                make.height.equalTo(50)
//            }
            
        let _size = textView.intrinsicContentSize

        let iframe = CGRect(x: 20, y: 300-_size.height, width: 300, height: _size.height)
            textView.frame = iframe
            
        textView.didContentSizeChanged = { [unowned self] (oldValue, newValue) in
        
            func setfr() {
                
                func func2() {
                    
                }
                
                let _frma = CGRect(x: 20, y: 300-newValue.height, width: 300, height: newValue.height)
                self.textView.frame = _frma;
                
                func2()
            }
            
            let setFrmaeClo = {
                let _frma = CGRect(x: 20, y: 300-newValue.height, width: 300, height: newValue.height)
                self.textView.frame = _frma;
            }
//            let _frma = CGRect(x: 20, y: 300-newValue.height, width: 300, height: newValue.height)
            UIView.animate(withDuration: 0.25) {
//                self.textView.frame = _frma;
                setFrmaeClo()
            }
            setfr()
            
            setFrmaeClo()
            
            let ttt = self.textView.pk.trimmedWhitespacesText
            print("ttt is: \(String(describing: ttt))")
            
            let ttt22 = self.textView.pk.trimmedWhitespacesAndNewlinesText
            print("ttt22 is: \(String(describing: ttt22))")

            self.view.pk.showToast(message: "哈哈哈哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈哈", position: .center(offset: -50))
        }
    }

    deinit {
        print("没有循环引用")
    }
    
    var timeView: UTimeView!
    
    
    func demo1() {
        /**
         UIGraphicsPushContext()
         UIGraphicsPopContext()
         
         */
        
        
        let bounds = UIScreen.main.bounds
        print("bounds is: \(bounds)");
        
        if UIDevice.pk.isIphone12mini {
            print("isIphone12mini");
        } else {
            print("no 12mini");
        }
        
        
//        let s = "哈哈哈哈哈圣诞节福利卡"
//        let go = s[safe: 0...5]
//        print("go is: \(String(describing: go))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        demo1()
//        setup3()
        zhangLoad()
        
       // SwiftUI、Widgets、RxSwift
//        timeView = UTimeView()
//        timeView.backgroundColor = .lightGray
//        view.addSubview(timeView)
//
//        timeView.frame = CGRect(x: 10, y: 100, width: view.bounds.width-20, height: 300)
        
        
        
        
        
        
        
//        let textLayer = UTextLayer()
//        textLayer.contentsScale = UIScreen.main.scale
//        textLayer.backgroundColor = UIColor.systemPink.cgColor
//        textLayer.frame = CGRect(x: 20, y: 100, width:300, height: 100)
//        timeView.layer.addSublayer(textLayer)
//        
//        var ren1 = UTextRender()
//        ren1.text = "成交量"
//        ren1.color = .white
//        ren1.font = UIFont.systemFont(ofSize: 22)
//        ren1.backgroundColor = .orange
//        ren1.cornerRadius = 5
//        ren1.borderColor = UIColor.yellow
//        ren1.borderWidth = 2
//        ren1.textEdgePadding = (20, 10)
//        ren1.position = CGPoint(x: 11, y: 50)
//        ren1.positionOffset = CGPoint(x: 0, y: 0.5)
//    
//        let width = "成交量".pk.boundingWidth(with: .greatestFiniteMagnitude, font: ren1.font)
//        let px = width + ren1.position.x + ren1.textEdgePadding.horizontal + 5
//
//        var ren2 = UTextRender()
//        ren2.text = "5888.62万"
//        ren2.color = .white
//        ren2.font = UIFont.systemFont(ofSize: 22)
//        ren2.backgroundColor = .orange
//        ren2.cornerRadius = 5
//        ren2.borderColor = UIColor.yellow
//        ren2.borderWidth = 2
//        ren2.textEdgePadding = (20, 10)
//        ren2.position = CGPoint(x: px, y: 50)
//        ren2.positionOffset = CGPoint(x: 0, y: 0.5)
//        
//        textLayer.renders = [ren1, ren2]
        
        
//        let path = Bundle.main.path(forResource: "times_data", ofType: "plist")
//        let value = NSMutableDictionary(contentsOfFile: path!)
//        if let object = UStockItem.deserialize(from: value) {
//            timeView.dataList = object.times
//
//            let preference = UTimePreferences()
//            preference.dateBarPosition = .bottom
//            preference.contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)
//            preference.shapeWidth = 1
//            timeView.preference = preference
//
//            timeView.drawChart()
//        }
        
        
//        DispatchQueue.pk.asyncAfter(delay: 2) {
//            let atts = NSMutableAttributedString.init(string: "哈哈")
//            atts.pk.foregroundColor(.red).font(UIFont.systemFont(ofSize: 17))
//
//            let atts2 = NSMutableAttributedString.init(string: "8927")
//            atts2.pk.foregroundColor(.white).font(UIFont.systemFont(ofSize: 11))
//            atts2.pk.backgroundColor(.cyan)
//            atts.append(atts2)
//            ren1.text = atts
//            textLayer.renders = [ren1]
//        }
        
        
    }
    
    
    // MARK: zhangLoad
    
    func zhangLoad() {
        print("哈哈")
        
        var field = PKUITextField()
        field.pk.setPlaceholder("请输入", color: .white)
        field.pk.textType = .generic
        field.font = .systemFont(ofSize: 15)
        field.textColor = .black
        field.returnKeyType = .search
        field.clearButtonMode = .whileEditing
        field.backgroundColor = UIColor.pk.random()
        view.addSubview(field)
        
        field.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(250);
            make.height.equalTo(70);
        }
        
        let nameValid = field.rx.text.orEmpty.map { (s) in
            s.count >= 5
        }
    }
    
    func hah() {
        
    }
}
