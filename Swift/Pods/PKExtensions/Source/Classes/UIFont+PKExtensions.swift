//
//  UIFont+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/23.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKFontExtensions {
    
    /// 系统字体族所有字体名称
    enum FontName: String {
        case academyEngravedLetPlain
        case alNile
        case americanTypewriter
        case appleColorEmoji
        case appleSDGothicNeo
        case arial
        case arialHebrew
        case arialMT
        case arialRoundedMTBold
        case avenir
        case avenirNext
        case avenirNextCondensed
        case baskerville
        case bodoniOrnamentsITCTT
        case bodoniSvtyTwoITCTT
        case bradleyHandITCTT
        case chalkboardSE
        case chalkduster
        case charter
        case cochin
        case copperplate
        case courier
        case courierNewPS
        case courierNewPSMT
        case dINAlternate
        case dINCondensed
        case damascus
        case devanagariSangamMN
        case didot
        case diwanMishafi
        case euphemiaUCAS
        case farah
        case geezaPro
        case georgia
        case gillSans
        case gujaratiSangamMN
        case gurmukhiMN
        case helvetica
        case helveticaNeue
        case hiraMaruProNW4
        case hiraMinProNW3
        case hiraMinProNW6
        case hiraginoSansW3
        case hiraginoSansW6
        case hoeflerText
        case kailasa
        case kannadaSangamMN
        case kefa
        case khmerSangamMN
        case kohinoorBangla
        case kohinoorDevanagari
        case kohinoorTelugu
        case laoSangamMN
        case malayalamSangamMN
        case markerFelt
        case menlo
        case myanmarSangamMN
        case noteworthy
        case notoNastaliqUrdu
        case notoSansChakma
        case optima
        case oriyaSangamMN
        case palatino
        case papyrus
        case partyLetPlain
        case pingFangHK
        case pingFangSC
        case pingFangTC
        case rockwell
        case savoyeLetPlain
        case sinhalaSangamMN
        case snellRoundhand
        case symbol
        case tamilSangamMN
        case thonburi
        case timesNewRomanPS
        case timesNewRomanPSMT
        case trebuchet
        case trebuchetMS
        case verdana
        case zapfDingbatsITC
        case zapfino
    }

    /// 系统字体族所有字体样式
    enum FontStyle: String {
        case none = ""
        case bold
        case boldItalic
        case boldOblique
        case italic
        case regular
        case oblique
        case roman
        case thin
        case wide
        case demiBold
        case demiBoldItalic
        case semiBold
        case semiBoldItalic
        case black
        case blackOblique
        case book
        case bookIt
        case bookIta
        case bookOblique
        case heavy
        case heavyItalic
        case heavyOblique
        case medium
        case mediumItalic
        case mediumOblique
        case boldMT
        case italicMT
        case boldItalicMT
        case condensed
        case condensedBold
        case condensedLight
        case light
        case lightOblique
        case ultraLight
        case ultraLightItalic
        case condensedMedium
        case condensedExtraBold
    }
    
    /// 返回对应名称及样式的字体，字体不存在则返回nil(可选值)
    ///
    /// - Parameters:
    ///   - name: 字体名称
    ///   - style: 字体样式
    ///   - size: 字号大小
    /// - Returns: UIFont
    static func name(_ name: FontName, style: FontStyle = .none, size: CGFloat = UIFont.systemFontSize) -> UIFont? {
        let fontName = name.rawValue + "-" + style.rawValue
        if let font = UIFont(name: fontName, size: size) { return font }
        if let font = UIFont(name: name.rawValue, size: size) { return font }
        return UIFont(name: name.rawValue + "-" + FontStyle.regular.rawValue, size: size)
    }
    
    /// 返回对应名称及样式的字体，字体不存在则返回系统默认字体
    static func fontName(_ fontName: FontName, style: FontStyle = .none, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return name(fontName, style: style, size: size) ?? Base.systemFont(ofSize: size)
    }
    
    /// 返回像素值对应的字体大小
    static func pointsByPixel(_ pixel: CGFloat) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return pixel * (8.0 / 15.0)
        default:
            return pixel * 0.5
        }
    }
    
    /// 返回当前字体，并根据像素值调整字体大小
    func fontWithPixel(_ pixel: CGFloat) -> UIFont {
        return base.withSize(UIFont.pk.pointsByPixel(pixel))
    }
    
    /// 获取字体族所有字体名称
    static var entireFamilyNames: [String] {
        var names = [String]()
        for family in Base.familyNames {
            for name in Base.fontNames(forFamilyName: family) { names.append(name) }
        }
        return names.sorted(by: {$0 < $1})
    }
}

public struct PKFontExtensions {
    fileprivate static var Base: UIFont.Type { UIFont.self }
    fileprivate var base: UIFont
    fileprivate init(_ base: UIFont) { self.base = base }
}

public extension UIFont {
    var pk: PKFontExtensions { PKFontExtensions(self) }
    static var pk: PKFontExtensions.Type { PKFontExtensions.self }
}
