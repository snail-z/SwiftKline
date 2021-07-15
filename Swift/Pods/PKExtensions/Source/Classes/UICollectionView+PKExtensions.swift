//
//  UICollectionView+PKExtensions.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/21.
//  Copyright © 2020 Pink Koala. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UICollectionView {

    /// 返回collectionView所有section中的所有条数
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < base.numberOfSections {
            itemsCount += base.numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }
    
    /// 刷新数据完成处理回调
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.base.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 使用类名出列可重用的UICollectionViewCell
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
    
    enum ElementKind  { case sectionHeader, sectionFooter }

    /// 使用类名出列可重用的UICollectionReusableView
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: ElementKind, withClass name: T.Type, for indexPath: IndexPath) -> T {
        let elementKind: String
        switch kind {
        case .sectionHeader:
            elementKind = UICollectionView.elementKindSectionHeader
        case .sectionFooter:
            elementKind = UICollectionView.elementKindSectionFooter
        }
        guard let cell = base.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }
    
    /// 使用类名注册UICollectionReusableView
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: ElementKind, withClass name: T.Type) {
        let elementKind: String
        switch kind {
        case .sectionHeader:
            elementKind = UICollectionView.elementKindSectionHeader
        case .sectionFooter:
            elementKind = UICollectionView.elementKindSectionFooter
        }
        base.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: String(describing: name))
    }
    
    /// 使用类名注册UICollectionViewCell
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    /// 安全滚动到目标位置 (检查IndexPath在CollectionView中是否有效)
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0 &&
            indexPath.section >= 0 &&
            indexPath.section < base.numberOfSections &&
            indexPath.item < base.numberOfItems(inSection: indexPath.section) else {
                return
        }
        base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}
