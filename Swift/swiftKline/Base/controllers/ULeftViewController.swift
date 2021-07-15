
//
//  ULeftViewController.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/30.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit
import PKExtensions


class ULeftViewController: UIViewController {

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 108
        tableView.contentInset = .zero
        tableView.pk.eatAutomaticallyAdjustsInsets()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        view.addSubview(tableView)
        tableView.pk.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.pk.insetTopBackgroundColor(UIColor.red, offset: 1)
        
        DispatchQueue.pk.asyncAfter(delay: 2) {
            self.tableView.pk.insetTopBackgroundColor(.orange)
        }
    }
}

extension ULeftViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ULeftTableViewCell.pk.cellForTableView(tableView)
        cell.aView.text = "U-\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ULeftHeaderView.pk.headerFooterViewForTableView(tableView)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension ULeftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LandscapeChartVC()
//        let vc = TestViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


class ULeftTableViewCell: UBaseTableViewCell {
    
    var aView: UILabel!
    
    override func commonInitialization() {
        aView = UILabel()
        aView.font = UIFont.systemFont(ofSize: 15)
        aView.textColor = .black
        contentView.addSubview(aView)
    }
    
    override func layoutInitialization() {
        aView.pk.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
    }
}


class ULeftHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.pk.random()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
