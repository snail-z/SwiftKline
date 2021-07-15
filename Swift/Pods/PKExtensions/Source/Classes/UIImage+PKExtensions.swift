//
//  UIImage+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKImageExtensions {
    
    /// 图像宽度与高度的比值
    var ratioOfWidthToHeight: CGFloat {
        return base.size.width / base.size.height
    }
    
    /// 图像高度与宽度的比值
    var ratioOfHeightToWidth: CGFloat {
        return base.size.height / base.size.width
    }
    
    /// 根据指定的宽度获取与原图等比例大小的size
    func sizeOfScaled(width: CGFloat) -> CGSize {
        guard width > 0, !base.size.equalTo(.zero) else { return .zero }
        let factor = base.size.height / base.size.width
        return CGSize(width: width, height: width * factor)
    }
    
    /// 根据指定的高度获取与原图等比例大小的size
    func sizeOfScaled(height: CGFloat) -> CGSize {
        guard height > 0, !base.size.equalTo(.zero) else { return .zero }
        let factor = base.size.width / base.size.height
        return CGSize(width: height * factor, height: height)
    }
    
    /// 根据颜色返回一个纯色的图像
    static func image(with color: UIColor?, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        guard let cgColor = color?.cgColor, size.width > 0, size.height > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 压缩图像质量(默认值为0.5)
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /// 裁剪图像中的指定区域并返回新图像
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.width <= base.size.width && rect.height <= base.size.height else { return base }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: base.scale, y: base.scale))
        guard let image = base.cgImage?.cropping(to: scaledRect) else { return base }
        return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
    }
    
    /// 根据指定的高度将图像等比例缩放
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据指定的宽度将图像等比例缩放
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据给定的角度测量模型旋转图像
    ///
    ///     // 将图像旋转180度
    ///     image.pk.rotated(by: Measurement<UnitAngle>(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: 旋转图像的角度
    /// - Returns: 返回按给定角度旋转后的图像
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)
        return rotated(by: radians)
    }
    
    /// 根据给定的角度(以弧度为单位)旋转图像
    ///
    ///     // 将图像旋转180度
    ///     image.pk.rotated(by: .pi)
    ///
    /// - Parameter radians: 以弧度表示的旋转角度
    /// - Returns: 返回按给定角度旋转后的图像
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, base.scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        let origin = CGPoint(x: -base.size.width / 2, y: -base.size.height / 2)
        base.draw(in: CGRect(origin: origin, size: base.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据指定的颜色填充图像并返回新图像
    func filled(withColor color: UIColor?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        color?.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return base }

        context.translateBy(x: 0, y: base.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        guard let mask = base.cgImage else { return base }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据指定的颜色对图像线条轮廓上色
    ///
    /// - Parameters:
    ///   - color: 给图像着色用的颜色
    ///   - blendMode: 混合模式
    /// - Returns: 返回着色后的图像
    func tinted(_ color: UIColor?, blendMode: CGBlendMode = .normal, alpha: CGFloat = 1.0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let drawRect = CGRect(origin: .zero, size: base.size)
        let context = UIGraphicsGetCurrentContext()
        color?.setFill()
        context?.fill(drawRect)
        base.draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /// 根据给定的半径返回圆角图像 (默认nil为图像自身半径)
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(base.size.width, base.size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        let rect = CGRect(origin: .zero, size: base.size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        base.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 根据图片名称生成不同尺寸的占位图
    static func placeholderImage(with name: String, size: CGSize, backgroundColor: UIColor? = UIColor.pk.rgb(same: 245)) -> UIImage? {
        guard let logo = UIImage(named: name) else { return nil }
        return placeholderImage(with: logo, size: size, backgroundColor: backgroundColor)
    }
    
    /// 根据给定图片生成不同尺寸的占位图
    ///
    /// - Parameters:
    ///   - image: LOGO图片
    ///   - contentSize: 需要生成的占位图尺寸
    ///   - backgroundColor: 背景色
    ///
    /// - Returns: 占位图
    static func placeholderImage(with image: UIImage, size: CGSize, backgroundColor: UIColor? = UIColor.pk.rgb(same: 245)) -> UIImage? {
        guard !image.size.equalTo(.zero), size.pk.isValid else { return nil }
       
        /**
        * - image的物理尺寸大小等于 image.size * image.scale
        * - image.scale表示缩小因子，屏幕的scale表示放大因子
        * - image.scale这个值的获取就是简单的通过@2x这个后缀的数字获得的，
        *   比如把一个@3x图片的@3x的后缀删掉，则输出image.scale是1，而不是3，
        *   因此图片命名需要以@2x/@3x结尾，得到的image.scale才是正确的，
        *   这样可以保证在不同分辨率的机型上读取适合的image以节省内存
        */
        let pathURL = URL(fileURLWithPath: NSHomeDirectory() + "/Library/Caches/MakePlaceholder")
        let fileName = String(format: "pk_image_w%.0f_h%.0f@%@x.png", size.width, size.height, UIScreen.main.scale)
        let fileURL = pathURL.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(data: try! Data(contentsOf: fileURL)) // read cache
        }
        
        var width = image.size.width
        var height = image.size.height
        let scale = image.size.width / image.size.height
        if image.size.width > size.width, image.size.height > size.height {
            if image.size.width > image.size.height {
                width = size.width
                height = size.width / scale
            } else {
                width = size.height * scale
                height = size.height
            }
        } else if image.size.width > size.width {
            width = size.width
            height = size.width / scale
        } else if image.size.height >  size.height {
            width = size.height * scale
            height = size.height
        } else {
            // image的宽高同时小于指定宽高时，不做任何处理，保持原图
        }
        width = floor(width)
        height = floor(height)
        
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        let origin = CGPoint(x: center.x - width * 0.5, y: center.y - height * 0.5)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        backgroundColor?.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        image.draw(in: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        let placeholderImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        do { // cache image
            try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
            // https://programmingwithswift.com/save-images-locally-with-swift-5
            let pngRepresentation = placeholderImage!.pngData()
            try? pngRepresentation?.write(to: fileURL, options: .atomic)
        } catch let error {
            print("-TakePlaceholder- create directory error: \(error)")
        }
        return placeholderImage
    }
    
    /// 线性渐变方向
    enum GradientDirection {
        /// 从左到右渐变
        case leftToRight
        /// 从右到左渐变
        case rightToLeft
        /// 从上到下渐变
        case topToBottom
        /// 从下到上渐变
        case bottomToTop
        /// 从左上到右下渐变
        case leftTopToRightBottom
        /// 从左下到右上渐变
        case leftBottomToRightTop
        /// 从右上到左下渐变
        case rightTopToLeftBottom
        /// 从右下到左上渐变
        case rightBottomToLeftTop
    }
    
    /// 根据颜色和方向返回渐变色图像，`[Any]` 为十六进制字符串或十六进制数值
    static func gradientImage(with hexValues: [Any], size: CGSize, direction: GradientDirection = .leftToRight) -> UIImage? {
        if let ints = hexValues as? [Int] {
            let values = ints.map({ UIColor.pk.hex($0) })
            return gradientImage(with: values, size: size, direction: direction)
        } else if let strings = hexValues as? [String] {
            let values = strings.map({ (UIColor.pk.hex($0) ?? .clear) })
            return gradientImage(with: values, size: size, direction: direction)
        } else {
            return nil
        }
    }
    
    /// 根据颜色和方向返回渐变色图像
    static func gradientImage(with colors: [UIColor?], size: CGSize, direction: GradientDirection = .leftToRight) -> UIImage? {
        guard !colors.isEmpty, size.pk.isValid else { return nil }
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
        switch direction {
        case .leftToRight:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: size.width, y: 0)
        case .rightToLeft:
            startPoint = CGPoint(x: size.width, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        case .topToBottom:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: size.height)
        case .bottomToTop:
            startPoint = CGPoint(x: 0, y: size.height)
            endPoint = CGPoint(x: 0, y: 0)
        case .leftTopToRightBottom:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: size.width, y: size.height)
        case .leftBottomToRightTop:
            startPoint = CGPoint(x: 0, y: size.height)
            endPoint = CGPoint(x: size.width, y: 0)
        case .rightTopToLeftBottom:
            startPoint = CGPoint(x: size.width, y: 0)
            endPoint = CGPoint(x: 0, y: size.height)
        case .rightBottomToLeftTop:
            startPoint = CGPoint(x: size.width, y: size.height)
            endPoint = CGPoint(x: 0, y: 0)
        }
        
        let cgColors: [CGColor] = colors.map({ $0?.cgColor ?? UIColor.black.cgColor })
        let path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil)
        context?.saveGState()
        context?.addPath(path)
        context?.clip()
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        context?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 绘制单个文字并生成图像
    static func characterImage(with string: String, side length: CGFloat, margin: CGFloat) -> UIImage? {
        guard let chars = string.trimmingCharacters(in: .whitespacesAndNewlines).first else { return nil }
        let colors = [0x3A91F3, 0x74CFDE, 0xF14E7D, 0x5585A5, 0xF9CB4F, 0xF56B2F]
        let longValue = chars.unicodeScalars.first!.value // http://www.unicode.org/glossary
        let index = Int(longValue) % colors.count
        let backgroundColor = UIColor.pk.hex(colors[index])
    
        let size = CGSize(width: length, height: length)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(backgroundColor.cgColor)
        context?.setFillColor(backgroundColor.cgColor)
        context?.addRect(CGRect(origin: .zero, size: size))
        context?.drawPath(using: .fillStroke)
                
        let fsize = length - margin
        let attriText = NSMutableAttributedString(string: String(chars))
        attriText.pk.font(UIFont.pk.fontName(.alNile, size: fsize))
        attriText.pk.foregroundColor(.white)
        let textWidth = attriText.size().width
        let left = (size.width - textWidth) / 2
        let top = (size.height - fsize) / 2
        attriText.draw(in: CGRect(x: left, y: top, width: textWidth, height: fsize))
                
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 合成两张图片并添加文字
    func synthesis(with otherImage: UIImage?, title: String? = nil, contentSize: CGSize) -> UIImage {
        guard otherImage != nil || title != nil else { return base }
        
        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)
        base.draw(in: CGRect(origin: .zero, size: contentSize))
        let padding: CGFloat = 5
        if let image = otherImage {
            /// contentSize must be greater than image.size
            let x = contentSize.width - image.size.width - padding
            let y = contentSize.height - image.size.height - padding
            let rect = CGRect(x: x, y: y, width: image.size.width, height: image.size.height)
            image.draw(in: rect, blendMode: .normal, alpha: 0.8)
        }
        
        if let text = title {
            let range: NSRange = NSRange(location: 0, length: text.count)
            let attrib = NSMutableAttributedString(string: text)
            attrib.addAttribute(.font, value: UIFont.systemFont(ofSize: UIFont.systemFontSize), range: range)
            attrib.addAttribute(.foregroundColor, value: UIColor.white, range: range)
            let size = attrib.boundingRect(with: .zero, options: .usesLineFragmentOrigin, context: nil).size
            let x = contentSize.width - size.width - padding
            let y = contentSize.height - size.height - padding
            attrib.draw(at: CGPoint(x: x, y: y))
        }
        let resImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resImage!
    }
}

public extension PKImageExtensions {
    // Original Source: https://github.com/hucool/WXImageCompress
    
    enum WechatCompressType {
        case session
        case timeline
    }
    
    /**
     wechat image compress
     
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
    func wxCompress(type: WechatCompressType = .timeline) -> UIImage {
        let size = wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)!
        return UIImage(data: data)!
    }
    
    /**
     get wechat compress image size
     
     - parameter type: session  / timeline
     
     - returns: size
     */
    func wxImageSize(type: WechatCompressType) -> CGSize {
        var width = base.size.width
        var height = base.size.height
        
        var boundary: CGFloat = 1280
        
        // width, height <= 1280, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1280
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: base.cgImage!, scale: 1, orientation: base.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

public struct PKImageExtensions {
    fileprivate static var Base: UIImage.Type { UIImage.self }
    fileprivate var base: UIImage
    fileprivate init(_ base: UIImage) { self.base = base }
}

public extension UIImage {
    var pk: PKImageExtensions { PKImageExtensions(self) }
    static var pk: PKImageExtensions.Type { PKImageExtensions.self }
}
