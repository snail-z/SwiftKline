//
//  UITableView+PKExtensions.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/21.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UITableView {
    
    /// 返回tableView所有section中的所有行数
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < base.numberOfSections {
            rowCount += base.numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    /// 刷新数据完成处理回调
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.base.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 删除TableHeaderView
    func removeTableHeaderView() {
        base.tableHeaderView = nil
    }
    
    /// 删除TableFooterView
    func removeTableFooterView() {
        base.tableFooterView = nil
    }
    
    /// 使用类名出列可重用的UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用类名及indexPath出列可重用的UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用类名出列可重用的UITableViewHeaderFooterView
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
    
    /// 使用类名注册UITableViewHeaderFooterView
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册UITableViewCell
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    /// 安全滚动到目标位置 (检查IndexPath在TableView中是否有效)
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < base.numberOfSections else { return }
        guard indexPath.row < base.numberOfRows(inSection: indexPath.section) else { return }
        base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
