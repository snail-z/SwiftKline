//
//  SecondViewController.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/6.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa
import QuartzCore

class SecondViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var _dataArray: [String]!
    var _tableView: NSTableView! = nil
    
    var timeView: UTimeView!
    
    @objc func resizesd() {
        print("resizesd--> \(view.bounds)")
        timeView.drawChart()
    }
    
    func testDemo() {
        
        /**
         label: 表示队列标签
         qos: 表示设置队列的优先级
         attributes: 表示队列类型，默认串行队列
            iOS 10.0之后 attributes 新增.initiallyInactive属性表示当前队列是不活跃的，它需要调用DispatchQueue的activate方法来执行任务。
         autoreleaseFrequency: 表示自动释放频率，设置自动释放机制。
         参考：https://www.jianshu.com/p/47e45367e524
        */
    
        /// 创建一个串行队列
        let queue1 = DispatchQueue(label: "com.my.thread")
        let queue2 = DispatchQueue.init(label: "com.my.concurrent", qos: .default, attributes: .concurrent)
//
//        /// 1. 首先异步执行串行队列
//        queue1.async {
//
//            /// 2. 来到这里，同步执行串行队列（由于是串行队列该任务需要等待步骤1完成，而步骤1又需要等待步骤2完成）
//            queue1.sync {
//
//                /// 3. 这里不会执行，步骤2就直接死锁崩溃了
//                Thread.sleep(forTimeInterval: 2)
//                print("----current is: \(Thread.current)")
//            }
//        }
    
        
        for idx in 0...10 {
            queue2.sync {
                print("idx is: \(idx)")
                print("----current is: \(Thread.current)")
            }
        }
        
        var butt = NSButton()
        butt.addObserver(self, forKeyPath: "font", options: .new, context: nil)
        
        
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(resizesd), name: NSWindow.didResizeNotification, object: nil)
        
        
        view.wantsLayer = true
        view.window?.minSize = CGSize(width: 800, height: 800)
        
        _dataArray = [String]()
        for index in 0..<100 {
            _dataArray.append("HuHa\(index)")
        }
        
        let nsscrollView = NSScrollView.init()
        nsscrollView.hasVerticalRuler = true
//        nsscrollView.frame = view.bounds
//        nsscrollView.autoresizingMask = [.minXMargin, .height]
        view.addSubview(nsscrollView)
        
        nsscrollView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(100)
        }
        
//        nsscrollView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        
        _tableView = NSTableView.init(frame: nsscrollView.bounds)
        let column1 = NSTableColumn.init(identifier: NSUserInterfaceItemIdentifier.init("column1"))
        _tableView.addTableColumn(column1)
        
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.reloadData()
        _tableView.backgroundColor = .brown
        _tableView.headerView = nil
        nsscrollView.contentView.documentView = _tableView
        
        _tableView.backgroundColor = .brown
        
        
        timeView = UTimeView()
        timeView.backgroundColor = .white
        view.addSubview(timeView)
        
        timeView.snp.makeConstraints { (make) in
            make.left.equalTo(_tableView.snp.right)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(500)
        }
        
    
        timeView.layoutSubtreeIfNeeded()
        timeView.needsLayout = true
        
        
        let nowDate = Date.init()
        let nm = nowDate.toNumberOfMinutes()
        print("nm is: \(nm)")
        
        let ms1 = Date.minuteStringFrom(numberOfMinutes:65)
        print("======================> ms1 is: \(ms1)")
        
        let ms2 = Date.minuteStringFrom(numberOfMinutes: 834)
        print("======================> ms2 is: \(ms2)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
    
            /*
             NSRect imgRect = NSMakeRect（0.0，0.0， 100.0，100.0）;
             NSSize imgSize = imgRect.size;
             
             NSBitmapImageRep * offscreenRep = [[[NSBitmapImageRep alloc]
             initWithBitmapDataPlanes：NULL
             pixelsWide：imgSize.width
             pixelsHigh：imgSize.height
             bitsPerSample：8
             samplesPerPixel：4
             hasAlpha：YES
             isPlanar：NO
             colorSpaceName：NSDeviceRGBColorSpace
             bitmapFormat：NSAlphaFirstBitmapFormat
             bytesPerRow：0
             bitsPerPixel：0] autorelease];
             
             //设置屏幕上下文
             NSGraphicsContext * g = [NSGraphicsContext graphicsContextWithBitmapImageRep：offscreenRep];
             [NSGraphicsContext saveGraphicsState];
             [NSGraphicsContext setCurrentContext：g];
             
             //用Cocoa绘制第一个笔划
             NSPoint p1 = NSMakePoint（NSMaxX（imgRect），NSMinY（imgRect））;
             NSPoint p2 = NSMakePoint（NSMinX（imgRect），NSMaxY（imgRect））;
             [NSBezierPath strokeLineFromPoint：p1 toPoint：p2];
             
             //使用Core Graphics绘制第二行程
             CGContextRef ctx = [g graphicsPort];
             CGContextBeginPath（ctx）;
             CGContextMoveToPoint（ctx，0.0，0.0）;
             CGContextAddLineToPoint（ctx，imgSize.width，imgSize.height）;
             CGContextClosePath（ctx）;
             CGContextStrokePath（ctx）;
             
             //做绘图，所以设置当前上下文回到它是什么
             [NSGraphicsContext restoreGraphicsState];
             
             //创建一个NSImage并将其添加到它
             NSImage * img = [[[NSImage alloc] initWithSize：imgSize] autorelease];
             [img addRepresentation：offscreenRep];
             
             //然后继续保存或查看NSImage
              //            let imddg = NSImage()
              //            let ctx = NSGraphicsContext.current?.cgContext
              ////            ctx?.addRect(<#T##rect: CGRect##CGRect#>)
              //            ctx?.setFillColor(NSColor.orange.cgColor)
              //            ctx?.makeImage()
              //            UIGraphicsGetImageFromCurrentImageContext
             */
            
            let path = Bundle.main.path(forResource: "time_chart_data", ofType: "json")

            guard let result = path?.pk.toJSONData() as? [Any] else {
                return
            }
            
//            let url = URL.init(fileURLWithPath: path!)
//            let data = try! Data(contentsOf: url)
//            let jsonData:Any = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//            let jsonArr = jsonData as! NSArray
            
            
                if let objectItems = Array<UTimeItem>.deserialize(from: result) {
                    if let vis = objectItems as? [UTimeItem] {
                        self.timeView.dataList = vis
                        for it in vis {
                            print("date is: \(it.date)")
                            print("price is : \(it.price)")
                        }
                    }
                    
                    
                    let preference = UTimePreferences()
                    preference.maximumNumberOfEntries = 242
                    preference.dateBarPosition = .bottom
                    preference.contentEdgeInsets = NSEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                    preference.shapeSpacing = 0.5
                    self.timeView.preference = preference
                    
                    print("time viewis: \(self.timeView.frame)")
                    self.timeView.drawChart()
                }
        
        })

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return _dataArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return _dataArray[row]
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//========================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testDemo()
        // Do view setup here.
//        print("view is: \(view)")
//        nameView = WakaView.init()
//        nameView.wantsLayer = true
//        nameView.backgroundColor = .cyan
//        view.addSubview(nameView)
//        nameView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.top.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalTo(100)
//        }
//        setupBackgroundColor()
        
        
//        NSButtonTest()
//        NSTextFieldTest()
//        NSTextViewTest()
//        NSTextViewTest()
//        NSTableViewTest()
    }
    
//    var nameView: WakaView!
//    var dataArray: [String]!
    

//
//    func NSTableViewTest() {
//        dataArray = [String]()
//        for index in 0..<60 {
//            dataArray.append("a-\(index)")
//        }
//
//        let scrollView = NSScrollView.init()
//        scrollView.hasVerticalRuler = true
//        scrollView.backgroundColor = .orange
//        scrollView.drawsBackground = true
//        view.addSubview(scrollView)
//
//        scrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(50)
//            make.left.equalTo(20)
//            make.width.equalTo(300)
//            make.height.equalTo(300)
//        }
//
//
//        _tableView = NSTableView.init()
//        _tableView.rowHeight = 90
////        _tableView.register(nil, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cusum"))
//        _tableView.register(NSNib.init(nibNamed: "AKViewcell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cusum"))
//        _tableView.dataSource = self
//        _tableView.delegate = self
//        _tableView.focusRingType = .none
//        _tableView.headerView = nil
//        scrollView.contentView.documentView = _tableView
//        scrollView.hasVerticalRuler = true
//        scrollView.autohidesScrollers = true
//
//        view.addSubview(_tableView)
//        /* NSTableColume简单理解就是一列，其中可以进行此列样式的相关设置
//
//         */
//        let colu2 = NSTableColumn.init(identifier: NSUserInterfaceItemIdentifier.init("col2"))
//        _tableView.addTableColumn(colu2)
//
//        _tableView.reloadData()
//        _tableView.snp.makeConstraints { (make) in
//            make.top.equalTo(10)
//            make.left.equalTo(20)
//            make.width.equalTo(300)
//            make.height.equalTo(200)
//        }
//
//
////        let tableView = NSTableView()
////        tableView.dataSource = self
//////        tableView.delegate = self
////        tableView.backgroundColor = .brown
////        view.addSubview(tableView)
////        tableView.snp.makeConstraints { (make) in
////            make.left.equalTo(100)
////            make.width.equalTo(200)
////            make.top.equalToSuperview().offset(20)
////            make.height.equalTo(200)
////        }
////
////        tableView.reloadData()
//    }
//
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return dataArray.count
//    }
//
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//
////        var cell: NSTableCellView? = nil
////        let ids = NSUserInterfaceItemIdentifier.init("hah")
////        cell = tableView.makeView(withIdentifier: ids, owner: nil) as? NSTableCellView
////        return cell
//
//        return dataArray[row]
//    }
//
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        var cellView =
//            tableView
//            .makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cusum"), owner: self) as? WakaCell
//
//
//        print("cellView is: \(cellView)")
//
//        if cellView == nil {
//            cellView = WakaCell.init()
//        }
//
//        return cellView
//    }
//
//
////    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
////
////    }
//
//    func NSTextViewTest() {
//        let scrollvew: NSScrollView!
//        let textView: NSTextView
//        if #available(OSX 10.14, *) {
//            // 可以滚动的textView
//            scrollvew = NSTextView.scrollableTextView()
//            textView = scrollvew.documentView as! NSTextView
//        } else {
//            // Fallback on earlier versions
//            textView = NSTextView.init()
//            scrollvew = NSScrollView.init()
//        }
//        view.addSubview(scrollvew!)
//        scrollvew.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.width.equalTo(200)
//            make.top.equalToSuperview().offset(20)
//            make.height.equalTo(70)
//        }
////        view.addSubview(textView)
////        textView.snp.makeConstraints { (make) in
////            make.left.equalTo(100)
////            make.width.equalTo(200)
////            make.top.equalToSuperview().offset(20)
////            make.height.equalTo(70)
////        }
//
////        textView.textContainer?.containerSize = CGSize(width: 200, height: 1000)
////        textView.isEditable = false
////        textView.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//
////        textView.size
//
//        textView.backgroundColor = .brown
////        textView.drawsBackground = true
//
//        textView.font = NSFont.boldSystemFont(ofSize: 17)
//        textView.textColor = .white
//
//
//    }
//
//    func NSTextFieldTest() {
//        // NSTextField用来接收用户文本输入，其可以接收键盘事件
//
//        let textField = NSTextField.init(string: "TextField")
//        view.addSubview(textField)
//        textField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
////            make.right.equalTo(-200)
//            make.width.equalTo(200)
//            make.top.equalToSuperview().offset(20)
//            make.height.equalTo(70)
//        }
//
//        textField.placeholderString = "请输入"
//
//        // 是否绘制背景，设置为NO则不绘制背景色
//        textField.drawsBackground = true
//        textField.backgroundColor = .orange
//
//        textField.textColor = .white
//        textField.font = NSFont.boldSystemFont(ofSize: 17)
//
//        // 文本框是否可以选中
//        textField.isSelectable = true
//
//        // 是否允许用户向文本框中拖拽图片
//        textField.importsGraphics = false
//
////        NSTextField
////        NSText
////        NSTextView
////        NSCell
////        NSTextFieldCell
//
//
//        /// ???
////        textField.cell?.usesSingleLineMode = false
////        // 超出行数是否隐藏
////        textField.cell?.truncatesLastVisibleLine = true
//
//
//        // 预定的最大宽度 ???
////        textField.preferredMaxLayoutWidth = 100
//
//        // 最大行数
//        textField.maximumNumberOfLines = 5
//
//        // 判断文本框是否接受了黑边框
//        textField.isBordered = false
//        // 设置是否绘制贝塞尔风格的边框
//        textField.isBezeled = false
//        // 边框风格
////        textField.bezelStyle = .squareBezel
//    }
//
//    func NSButtonTest() {
//        let button = NSButton()
//        view.addSubview(button)
//
//        // 添加点击事件
//        button.target = self
//        button.action = #selector(next)
//
//        // 设置文本
//        button.title = "标题"
//
//        // 使用属性文字改变颜色等
//        let muattrib = NSMutableAttributedString.init(string: "23pOP的")
//        muattrib.pk.foregroundColor(.yellow)
//        muattrib.pk.backgroundColor(.darkGray)
//        let nsfont = NSFont.systemFont(ofSize: 22)
//        muattrib.pk.font(nsfont)
//        button.attributedTitle = muattrib
//
//        // 图片位置
//        button.imagePosition = .imageBelow
//
//        // 设置背景色
//        button.wantsLayer = true
//        button.layer?.backgroundColor = NSColor.brown.cgColor
//
//        // 点击不高亮
//        button.isHighlighted = false
//
//        //
//        button.setButtonType(.toggle)
//
//        // 鼠标悬停在按钮上出现提示文字
//        button.toolTip = "哈哈"
//
//        //
//        button.alternateImage = NSImage.init(named: "advisory_plain")
//        button.image = NSImage.init(named: "advisory_plain")
//
//        // 是否需要边框
//        button.isBordered = true
//
//        // 边框样式
//        button.bezelStyle = .regularSquare
//
//        // 布局
//        button.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(10)
//            make.width.equalTo(100)
//            make.height.equalTo(90)
//            make.top.equalTo(100)
//        }
//    }
//
//    fileprivate func setupBackgroundColor(){
//
//        // 1 方式: 创建layer图层
//        let blueView = NSView(frame: NSMakeRect(100, 100, 30, 30))
//
//        let layer = CALayer()
//        layer.backgroundColor = NSColor.blue.cgColor
//
//        layer.frame = blueView.bounds
//
//        //
//        blueView.layer = layer
//
//        /*
//
//
//
//
//         */
//
//        view.addSubview(blueView)
//
//        // 方式2 : 自定义view
//
//        let  colorVeiw = ColorView(frame: NSMakeRect(150, 50, 59, 59))
//        view.addSubview(colorVeiw)
//
//    }
//
//    @objc func next() {
//        print("next2")
////        let svc = SecondViewController.init(nibName: nil, bundle: nil)
////        self.view = svc.view
//    }
//
//}
//
//class ColorView: NSView {
//
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//
//        // 设置颜色填充
//        NSColor.orange.set()
//
//        NSBezierPath.fill(dirtyRect)
//    }
    
    
}
