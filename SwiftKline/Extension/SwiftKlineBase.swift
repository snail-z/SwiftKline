//
//  SwiftKlineBase.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/12.
//  Copyright © 2020 zhanghao. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public typealias NSUIFont = UIFont
public typealias NSUIColor = UIColor
#endif

#if os(OSX)
import Cocoa

public typealias SwiftFont = NSFont
public typealias SwiftColor = NSColor

#endif

