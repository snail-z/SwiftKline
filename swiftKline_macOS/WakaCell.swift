//
//  WakaCell.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/10.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

class WakaCell: NSTableCellView {
    
    //    let kakView: NSTextField!
    init() {
        super.init(frame: .zero)
        
        let kakView = NSTextField.init(string: "TextField")
        addSubview(kakView)
        
        kakView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        // 是否绘制背景，设置为NO则不绘制背景色
        kakView.drawsBackground = true
        kakView.backgroundColor = .orange
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
