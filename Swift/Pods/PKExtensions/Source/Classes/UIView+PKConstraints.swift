//
//  UIView+PKConstraints.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/7/18.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UIView {
    
    /// 视图添加约束
    func makeConstraints(_ closure: (_ make: PKConstraintMaker) -> Void) {
        PKConstraintMaker.makeConstraints(item: base, closure: closure)
    }
    
    /// 更新视图约束
    func updateConstraints(_ closure: (_ make: PKConstraintMaker) -> Void) {
        PKConstraintMaker.updateConstraints(item: base, closure: closure)
    }
    
    /// 重建视图约束
    func remakeConstraints(_ closure: (_ make: PKConstraintMaker) -> Void) {
        PKConstraintMaker.remakeConstraints(item: base, closure: closure)
    }
    
    /// 删除视图约束
    func removeConstraints() {
        PKConstraintMaker.removeConstraints(item: base)
    }
}

public extension PKViewExtensions where Base: UIView {
    
    var top: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .top)
    }
    
    var left: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .left)
    }
    
    var bottom: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .bottom)
    }
    
    var right: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .right)
    }
    
    var width: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .width)
    }
    
    var height: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .height)
    }
    
    var centerX: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .centerX)
    }
    
    var centerY: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .centerY)
    }
    
    var edges: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .edges)
    }
    
    var size: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .size)
    }
    
    var center: PKConstraintItem {
        return PKConstraintItem(target: base, attribute: .center)
    }
}

public final class PKConstraintItem {
    
    internal weak var target: UIView?
    internal let attribute: PKLayoutConstraintAttribute
    
    internal init(target: UIView?, attribute: PKLayoutConstraintAttribute) {
        self.target = target
        self.attribute = attribute
    }
    
    internal var view: UIView? {
        return self.target
    }
    
    internal var superview: UIView? {
        return self.target?.superview
    }
}

public class PKConstraintMaker {
    
    public var left: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .left)
    }
    
    public var top: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .top)
    }
    
    public var bottom: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .bottom)
    }
    
    public var right: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .right)
    }
    
    public var width: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .width)
    }
    
    public var height: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .height)
    }
    
    public var centerX: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .centerX)
    }
    
    public var centerY: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .centerY)
    }
    
    public var edges: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .edges)
    }
    
    public var size: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .size)
    }
    
    public var center: PKConstraintMakerRelatable {
        return addConstraintDescription(with: .center)
    }
    
    private func addConstraintDescription(with layoutAttribute: PKLayoutConstraintAttribute) -> PKConstraintMakerRelatable {
        let description = PKConstraintDescription(item: PKConstraintItem(target: self.layoutView, attribute: layoutAttribute))
        descriptions.append(description)
        return PKConstraintMakerRelatable(description)
    }
    
    private var descriptions = [PKConstraintDescription]()
    private let layoutView: UIView
    
    internal init(target: UIView) {
        self.layoutView = target
        self.layoutView.prepare()
    }
    
    internal static func prepareConstraints(item: UIView, closure: (_ make: PKConstraintMaker) -> Void) -> [NSLayoutConstraints] {
        let maker = PKConstraintMaker(target: item)
        closure(maker)
        var constraints: [NSLayoutConstraints] = []
        for description in maker.descriptions {
            guard let constraint = description.layoutConstraints else {
                continue
            }
            constraints.append(constraint)
        }
        return constraints
    }
    
    internal static func makeConstraints(item: UIView, closure: (_ make: PKConstraintMaker) -> Void) {
        let constraints = prepareConstraints(item: item, closure: closure)
        for alias in constraints {
            NSLayoutConstraint.activate(alias)
            item.add(layoutConstraints: [alias])
        }
    }
    
    internal static func remakeConstraints(item: UIView, closure: (_ make: PKConstraintMaker) -> Void) {
        removeConstraints(item: item)
        makeConstraints(item: item, closure: closure)
    }
    
    internal static func updateConstraints(item: UIView, closure: (_ make: PKConstraintMaker) -> Void) {
        guard item.layoutConstraints.count > 0 else {
            makeConstraints(item: item, closure: closure)
            return
        }
        
        let constraints = prepareConstraints(item: item, closure: closure)
        for alias in constraints {
            var existingLayoutConstraints: NSLayoutConstraints = []
            for constraint in item.layoutConstraints {
                existingLayoutConstraints += constraint
            }

            for a in alias {
                let existingLayoutConstraint = existingLayoutConstraints.first { $0.isEequivalent(a) }
                guard let updateLayoutConstraint = existingLayoutConstraint else {
                    fatalError("视图现有约束无法匹配到将要更新的约束:\(a)")
                }
                updateLayoutConstraint.constant = a.constantValue
            }
        }
    }
    
    internal static func removeConstraints(item: UIView) {
        let constraints = item.layoutConstraints
        for alias in constraints {
            NSLayoutConstraint.deactivate(alias)
            item.remove(layoutConstraints: [alias])
        }
    }
}

public protocol PKConstraintRelatableTarget {}

extension PKConstraintRelatableTarget {
    
    internal func constantTargetValue(for layoutAttribute: NSLayoutConstraint.Attribute) -> CGFloat {

        if let value = self as? Int { return CGFloat(value) }
        
        if let value = self as? UInt { return CGFloat(value) }
        
        if let value = self as? Double { return CGFloat(value) }
        
        if let value = self as? Float { return CGFloat(value) }
        
        if let value = self as? CGFloat { return value }
        
        if let value = self as? CGSize {
            switch layoutAttribute {
            case .width: return value.width
            case .height: return value.height
            default: return 0
            }
        }
        
        if let value = self as? CGPoint {
            switch layoutAttribute {
            case .left, .right, .centerX: return value.x
            case .top, .bottom, .centerY: return value.y
            default: return 0
            }
        }
        
        return 0
    }
}

extension Int: PKConstraintRelatableTarget {}

extension UInt: PKConstraintRelatableTarget {}

extension Double: PKConstraintRelatableTarget {}

extension Float: PKConstraintRelatableTarget {}

extension CGFloat: PKConstraintRelatableTarget {}

extension CGSize: PKConstraintRelatableTarget {}

extension CGPoint: PKConstraintRelatableTarget {}

extension PKConstraintItem: PKConstraintRelatableTarget {}

extension UIView: PKConstraintRelatableTarget {}

public class PKConstraintMakerRelatable {
    
    @discardableResult
    public func equalTo(_ other: PKConstraintRelatableTarget) -> PKConstraintMakerEditable {
        return relatedTo(other, relation: .equal)
    }
    
    @discardableResult
    public func equalToSuperview() -> PKConstraintMakerEditable {
        guard let other = self.description.layoutFromItem.superview else {
            fatalError("使用约束`equalToSuperview()`时未找到父视图")
        }
        return relatedTo(other, relation: .equal)
    }
    
    @discardableResult
    public func lessThanOrEqualTo(_ other: PKConstraintRelatableTarget) -> PKConstraintMakerEditable {
        return relatedTo(other, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func lessThanOrEqualToSuperview() -> PKConstraintMakerEditable {
        guard let other = self.description.layoutFromItem.superview else {
            fatalError("使用约束`lessThanOrEqualToSuperview()`时未找到父视图")
        }
        return self.relatedTo(other, relation: .lessThanOrEqual)
    }
    
    @discardableResult
    public func greaterThanOrEqualTo(_ other: PKConstraintRelatableTarget) -> PKConstraintMakerEditable {
        return self.relatedTo(other, relation: .greaterThanOrEqual)
    }
    
    @discardableResult
    public func greaterThanOrEqualToSuperview() -> PKConstraintMakerEditable {
        guard let other = self.description.layoutFromItem.superview else {
            fatalError("使用约束`greaterThanOrEqualToSuperview()`时未找到父视图")
        }
        return self.relatedTo(other, relation: .greaterThanOrEqual)
    }
    
    private func relatedTo(_ other: PKConstraintRelatableTarget, relation: NSLayoutConstraint.Relation) -> PKConstraintMakerEditable {
        let editable = PKConstraintMakerEditable(self.description)
        editable.description.relation = relation
        editable.description.constantTarget = other
        return editable
    }
    
    internal let description: PKConstraintDescription
    
    internal init(_ description: PKConstraintDescription) {
        self.description = description
    }
}

public class PKConstraintMakerEditable {
    
    @discardableResult
    public func offset(_ amount: CGFloat) -> Self {
        self.description.offset = amount
        return self
    }
    
    @discardableResult
    public func multipliedBy(_ amount: CGFloat) -> Self {
        self.description.multiplier = amount
        return self
    }
    
    public func priority(_ layoutPriority: UILayoutPriority) {
        self.description.priority = layoutPriority
    }
    
    internal let description: PKConstraintDescription
    
    internal init(_ description: PKConstraintDescription) {
        self.description = description
    }
}

internal class PKConstraintDescription {
    
    internal let layoutFromItem: PKConstraintItem
    internal var relation: NSLayoutConstraint.Relation?
    internal var constantTarget: PKConstraintRelatableTarget = 0.0
    internal var multiplier: CGFloat = 1.0
    internal var offset: CGFloat = 0.0
    internal var priority: UILayoutPriority = .required
    
    internal init(item: PKConstraintItem) {
        layoutFromItem = item
    }
    
    internal lazy var layoutConstraints: NSLayoutConstraints? = {
        return makeConstraints()
    }()
    
    private func makeConstraints() -> NSLayoutConstraints? {
        guard let layoutRelation = self.relation else { return nil }
        
        let fromItem: UIView = self.layoutFromItem.view!
        let fromAttribute = self.layoutFromItem.attribute
        
        var toItem: UIView?
        let toAttribute: PKLayoutConstraintAttribute

        if let item = constantTarget as? PKConstraintItem {
            toItem = item.view
            toAttribute = item.attribute
        } else if let view = constantTarget as? UIView {
            toItem = view
            toAttribute = fromAttribute
        } else {
            toItem = nil
            toAttribute = fromAttribute
        }
        
        var layoutConstraints = NSLayoutConstraints()
        
        for layoutFromAttribute in fromAttribute.layoutAttributes {
            
            let layoutToAttribute: NSLayoutConstraint.Attribute
            if toAttribute == .edges {
                switch layoutFromAttribute {
                case .left:
                    layoutToAttribute = .left
                case .right:
                    layoutToAttribute = .right
                case .top:
                    layoutToAttribute = .top
                case .bottom:
                    layoutToAttribute = .bottom
                default:
                    fatalError()
                }
            } else if toAttribute == .size {
                switch layoutFromAttribute {
                case .width:
                    layoutToAttribute = .width
                case .height:
                    layoutToAttribute = .height
                default:
                    fatalError()
                }
            } else if toAttribute == .center {
                switch layoutFromAttribute {
                case .centerX:
                    layoutToAttribute = .centerX
                case .centerY:
                    layoutToAttribute = .centerY
                default:
                    fatalError()
                }
            } else {
                layoutToAttribute = toAttribute.layoutAttributes.first!
            }
            
            if toItem == nil && layoutFromAttribute != .width && layoutFromAttribute != .height {
                toItem = self.layoutFromItem.superview
            }
            
            let constantValue = constantTarget.constantTargetValue(for: layoutToAttribute) + offset

            let layoutConstraint = PKLayoutConstraint(item: fromItem,
                                                      attribute: layoutFromAttribute,
                                                      relatedBy: layoutRelation,
                                                      toItem: toItem,
                                                      attribute: layoutToAttribute,
                                                      multiplier: multiplier,
                                                      constant: constantValue)
            layoutConstraint.priority = priority
            layoutConstraint.constantValue = constantValue
            layoutConstraints.append(layoutConstraint)
        }
        
        return layoutConstraints
    }
}

internal typealias NSLayoutConstraints = [PKLayoutConstraint]

internal class PKLayoutConstraint : NSLayoutConstraint {
    
    var constantValue: CGFloat = 0
    
    func isEequivalent(_ rhs: PKLayoutConstraint) -> Bool {
        guard self.firstAttribute == rhs.firstAttribute &&
              self.secondAttribute == rhs.secondAttribute &&
              self.relation == rhs.relation &&
              self.priority == rhs.priority &&
              self.multiplier == rhs.multiplier &&
              self.secondItem === rhs.secondItem &&
              self.firstItem === rhs.firstItem else {
            return false
        }
        return true
    }
}

internal enum PKLayoutConstraintAttribute: Int {
    
    case none
    case left
    case right
    case top
    case bottom
    case width
    case height
    case centerX
    case centerY
    case edges
    case size
    case center
    
    var layoutAttributes: [NSLayoutConstraint.Attribute] {
        switch self {
        case .none:
            return []
        case .left:
            return [.left]
        case .right:
            return [.right]
        case .top:
            return [.top]
        case .bottom:
            return [.bottom]
        case .width:
            return [.width]
        case .height:
            return [.height]
        case .centerX:
            return [.centerX]
        case .centerY:
            return [.centerY]
        case .edges:
            return [.top, .left, .bottom, .right]
        case .size:
            return [.width, .height]
        case .center:
            return [.centerX, .centerY]
        }
    }
}

extension UIView: PKLayoutConstraintItem {}

internal protocol PKLayoutConstraintItem: class {}

internal extension PKLayoutConstraintItem {
    
    func prepare() {
        if let view = self as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var layoutConstraints: [NSLayoutConstraints] {
        return self.constraintsSet.allObjects as! [NSLayoutConstraints]
    }
    
    func add(layoutConstraints: [NSLayoutConstraints]) {
        let constraintsSet = self.constraintsSet
        for constraint in layoutConstraints {
            constraintsSet.add(constraint)
        }
    }
    
    func remove(layoutConstraints: [NSLayoutConstraints]) {
        let constraintsSet = self.constraintsSet
        for constraint in layoutConstraints {
            constraintsSet.remove(constraint)
        }
    }
    
    private var constraintsSet: NSMutableSet {
        let constraintsSet: NSMutableSet
        if let existing = objc_getAssociatedObject(self, &UIViewAssociatedconstraintsKey) as? NSMutableSet {
            constraintsSet = existing
        } else {
            constraintsSet = NSMutableSet()
            objc_setAssociatedObject(self, &UIViewAssociatedconstraintsKey, constraintsSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return constraintsSet
    }
}

private var UIViewAssociatedconstraintsKey: Void?
