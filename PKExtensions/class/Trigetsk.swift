//
//  Trigetsk.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/26.
//  Copyright © 2020 zhanghao. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

public typealias NSUIEdgeInsets = UIEdgeInsets

#endif

#if os(OSX)

import Cocoa

public typealias NSUIEdgeInsets = NSEdgeInsets

#endif

#if os(iOS) || os(tvOS)
import UIKit

public typealias NSUIFont = UIFont
public typealias NSUIColor = UIColor
#endif

#if os(OSX)
import Cocoa

public typealias NSUIFont = NSFont
public typealias NSUIColor = NSColor
#endif
