//
//  ViewController.swift
//  TKAuthorityModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit
import TKAuthorityModule

class ViewController: UIViewController {

    private var dataSource:[String] = [
        "健康",
        "网络",
        "音乐"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "UITableViewCell_ID"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: id)
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AuthorityManager.shared.healthAuthority { (reuslt, status, error) in
                
            }
            break
        case 1:
            break
        case 2:
            AuthorityManager.shared.musicAuthority { (reuslt, stauts, error) in
                if reuslt {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
            break
        default:
            break
        }
    }
}


