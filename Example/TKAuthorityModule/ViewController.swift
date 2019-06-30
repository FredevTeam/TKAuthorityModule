//
//  ViewController.swift
//  TKAuthorityModule
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit
import TKAuthorityModule
import HealthKit
import NotificationCenter

class ViewController: UIViewController {

    private var dataSource:[String] = [
        "健康",
        "健康2",
        "音乐",
        "AVFoundation_相机",
        "AVFoundation_麦克风",
        "媒体库",
        "相册",
        "相册2",
        "通讯录",
        "通信录2",
        "蓝牙",
        "语音识别",
        "通知",
        "通知2",
        "face ID/touch Id",
        "定位",
        "日历",
        "提醒事件",
        "NFC",
        "Wallet",
        "Apple Pay",
        "网络"
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
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AuthorityManager.shared.healthAuthority { (reuslt, status, error) in
                if reuslt {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
            break
        case 1:
            AuthorityManager.shared.healthAuthority(identifier:
            .bodyMassIndex
            ) { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
            break
        case 2:
            if #available(iOS 9.3, *) {
                AuthorityManager.shared.musicAuthority { (result, stauts, error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            break
        case 3:
            AuthorityManager.shared.cameraAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 4:
            AuthorityManager.shared.microphoneAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 5:
            if #available(iOS 9.3, *) {
                AuthorityManager.shared.mediaAuthority { (result, status, error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 6:
            AuthorityManager.shared.assetsLibraryAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 7:
            AuthorityManager.shared.photoLibraryAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 8:
            AuthorityManager.shared.addressBookAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 9:
            if #available(iOS 9.0, *) {
                AuthorityManager.shared.contactAuthority { (result, status, error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 10:
            AuthorityManager.shared.bluetoothAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 11:
            if #available(iOS 10.0, *) {
                AuthorityManager.shared.speechRecognitionAuthority { (result, status, error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 12:
//            AuthorityManager.shared.notificationRomateAuthority { (result, status, error) in
//                if result {
//                    print("获取到权限")
//                }else {
//                    print("没有获取到权限")
//                }
//            }
            break
        case 13:
            if #available(iOS 10.0, *) {
                AuthorityManager.shared.notificationCenterAuthority(options: .badge) { (result, status, error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 14:
            AuthorityManager.shared.faceOrTouchIDAuthority { (result , status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 15:
            AuthorityManager.shared.locationAuthority { (result, status , error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 16:
            AuthorityManager.shared.calendarAuthority { (result, status, error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 17:
            AuthorityManager.shared.remindEventAuthority { (result, status , error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 18:
            if #available(iOS 11.0, *) {
                AuthorityManager.shared.nfcAuthority { (result , status , error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 19:
            AuthorityManager.shared.walletAuthority { (result, status , error) in
                if result {
                    print("获取到权限")
                }else {
                    print("没有获取到权限")
                }
            }
        case 20:
            if #available(iOS 10.0, *) {
                AuthorityManager.shared.applePayAuthority { (result , status , erro) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        case 21:
            if #available(iOS 9.0, *) {
                AuthorityManager.shared.coreTelephonyAuthority { (result , status , error) in
                    if result {
                        print("获取到权限")
                    }else {
                        print("没有获取到权限")
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        default:
            break
        }
    }
}


