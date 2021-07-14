//
//  UBaseTableViewCell.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/30.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

class Classs1: NSObject {
    
    let cell = Classs2()
    func text() {
        cell.haha = { s in
            print(s)
        }
    }
}

class Classs2: NSObject {
    
    var haha: ((_ name: String) -> Void)? = nil
    
}

open class UBaseTableViewCell: UITableViewCell {

    var hah: ((_ name: String) -> Void)? = nil
    
    public class func cellWithTableView(_ tableView: UITableView) -> Self {
        let identifier = String(describing: self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = _makeSelf(identifier)
        }
        return cell as! Self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        commonInitialization()
        layoutInitialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func commonInitialization() {
        
        // Initialize subviews
    }
    
    func layoutInitialization() {
        
        // Configure the view layout
    }
}

fileprivate extension UITableViewCell {
    
    class func _makeSelf(_ identifier: String) -> Self {
        return Self.init(style: .default, reuseIdentifier: identifier)
    }
}
