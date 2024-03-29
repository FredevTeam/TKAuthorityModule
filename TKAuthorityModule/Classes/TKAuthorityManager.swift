//
//  TKAuthorityManager.swift
//  Pods-TKAuthorityModule_Example
//
//  Created by zhuamaodeyu on 01/24/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//
//

import Foundation

import AVFoundation
import Photos
import AssetsLibrary
import CoreLocation
import AddressBook
import Contacts
import EventKit
import UserNotifications
import CoreTelephony
import StoreKit
import SystemConfiguration
import HealthKit
import MediaPlayer
import Speech
import CoreBluetooth
import LocalAuthentication
import CoreNFC
import PassKit



/// 回调block
/**
 - Parameter result: 返回结果 True/ False
 - Parameter authority: 权限类型
 - Parameter error: 错误信息
 - Return :

 */
public typealias ReturnBlock = (_ result: Bool, _ authority: AuthorityProtocol?, _ error: Error?) -> Void
private let version = Float(UIDevice.current.systemVersion) ?? 0.0

/// Authority URL Type
///
/// - camera: 相册/相机
/// - music: 音乐
enum AuthorityURLType : String {
    case camera = "prefs:root=Photos"
    case music = "prefs:root=MUSIC"
}

class Auxiliary:NSObject {
    fileprivate var block:ReturnBlock?
    fileprivate weak var manager: AuthorityManager?

    deinit {
        debugPrint("对象释放了")
    }
}
private let messageString = "Please go to the Settings Center to open the permissions."
private let enterString = "Enter"
private let cancelString = "Cancel"


/// Authority Manager
public class AuthorityManager {
    fileprivate var message: String


    /// shared
    public static let shared = AuthorityManager(message: nil)

    private var localtionManager : CLLocationManager?
    private var  centralManager:CBCentralManager?

    private var auxiliary: Auxiliary = Auxiliary()


    /// init
    ///
    /// - Parameter message: show message to  alert view (alertView 显示的提示消息)
    public init(message: String? = nil) {
        self.message = message ?? messageString
        self.auxiliary.manager = self
    }

    deinit {
        debugPrint("对象释放了")
    }
}

// MARK: - 健康
extension AuthorityManager {

    /// 健康
    ///
    /// - Parameters:
    ///   - identifier: 健康类型 Identifier
    ///   - block: 回调block
    public func healthAuthority(identifier:HKQuantityTypeIdentifier,block: ReturnBlock?){
        if !HKHealthStore.isHealthDataAvailable() {
            block?(false, nil , NSError(domain: "is not available", code: 0, userInfo: nil))
            return
        }
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else {
            block?(false , nil , NSError.init(domain: "\(identifier) is not support", code: 0, userInfo: nil))
            return
        }
        let status = HKHealthStore.init().authorizationStatus(for: type)
        if status == .notDetermined {
            HKHealthStore.init().requestAuthorization(toShare: NSSet.init(array: [type]) as? Set<HKSampleType>, read: NSSet.init(array: [type]) as? Set<HKObjectType>) { (result, error) in
                 block?(result , nil , error)
            }
        }else {
            block?(status == .sharingAuthorized ? true : false, status , nil)
        }
    }


    /// 健康
    ///
    /// - Parameter block: 回调block
    public func healthAuthority(block: ReturnBlock?){
        if !HKHealthStore.isHealthDataAvailable() {
            block?(false, nil , NSError(domain: "is not available", code: 0, userInfo: nil))
            return
        }
        
        let read = NSSet(array:[
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth) as Any,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType) as Any,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex) as Any,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) as Any,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) as Any,
            HKObjectType.workoutType()
            ])
        
        let write = NSSet(array:[
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) as Any,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) as Any,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) as Any,
            HKQuantityType.workoutType()
            ])

        let store = HKHealthStore.init()
        store.requestAuthorization(toShare: read as? Set<HKSampleType>, read: write as? Set<HKObjectType>) { (result, error) in
            block?(result , nil , error)
        }
    }
}

// MARK: - 音乐
extension AuthorityManager {

    @available(iOS 9.3, *)

    /// 音乐
    ///
    /// - Parameter block: 回调block
    public func musicAuthority(block: ReturnBlock?){
        let status = SKCloudServiceController.authorizationStatus()
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
                SKCloudServiceController.requestAuthorization { (status) in
                    block?(status == .authorized ? true : false, status, nil)
                }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}


// MARK: - AVFoundation
extension AuthorityManager {

    /// 相机
    ///
    /// - Parameter block: 回调
    public func cameraAuthority(block: ReturnBlock?) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (result) in
                block?(result, result == true ? AVAuthorizationStatus.authorized : .denied, nil)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
        
    }

    /// 麦克风
    ///
    /// - Parameter block: 回调
    public func microphoneAuthority(block: ReturnBlock?) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            block?(true, status,nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { (result) in
                block?(result, result == true ? AVAuthorizationStatus.authorized : .denied,nil)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}

// MARK: - 媒体库
extension AuthorityManager {
    @available(iOS 9.3, *)

    /// 相册/ 媒体库
    ///
    /// - Parameter block: 回调
    public func mediaAuthority(block: ReturnBlock?) {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            block?(true, status, nil )
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { (status) in
                block?(status == MPMediaLibraryAuthorizationStatus.authorized ? true : false , status, nil)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}

// MARK: - 相册权限
extension AuthorityManager {
    /// 相册权限
    ///
    /// - Parameter block: 回调
    @available(iOS, introduced: 4.0, deprecated: 9.0, message: "Use photoLibraryAuthority instead")
    public func assetsLibraryAuthority(block: ReturnBlock?) {
        let status = ALAssetsLibrary.authorizationStatus()
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        //提示用户授权
        case .notDetermined:
            let assetLibrary = ALAssetsLibrary.init()
            assetLibrary.enumerateGroups(withTypes: ALAssetsGroupType(ALAssetsGroupAlbum), using: { (group, _) in
            }) { (error) in
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
    

    @available(iOS 8.0, *)

    /// 相册
    ///
    /// - Parameter block: 回调
    public func photoLibraryAuthority(block: ReturnBlock?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        //提示用户授权
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                block?(status == .authorized ? true : false  , status, nil)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
        
    }
}
// MARK: - 通讯录
extension AuthorityManager {

    /// 通讯录
    ///
    /// - Parameter block: 回调
    public func addressBookAuthority(block: ReturnBlock?){
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .authorized:
            block?(true, status,nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            let bookRef = ABAddressBookCreate()
            ABAddressBookRequestAccessWithCompletion(bookRef as ABAddressBook){(result ,error) in
                block?(result, result == true ? ABAuthorizationStatus.authorized: ABAuthorizationStatus.denied, error)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
    
    @available(iOS 9.0, *)

    /// 通讯录
    ///
    /// - Parameter block: 回调
    public func contactAuthority(block: ReturnBlock?){
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (result, error) in
                block?(result, result == true ? CNAuthorizationStatus.authorized : .notDetermined, error)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}

// MARK: - 蓝牙
extension AuthorityManager {

    /// 蓝牙
    ///
    /// - Parameter block: 回调
    public func bluetoothAuthority(block: ReturnBlock?){
        self.centralManager = CBCentralManager.init(delegate: self.auxiliary, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:true])
        self.auxiliary.block = block
    }
}

extension Auxiliary : CBCentralManagerDelegate {

    /// 蓝牙代理
    ///
    /// - Parameter central: 控制中心
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            fallthrough
        case .resetting:
            fallthrough
        case .unsupported:
            fallthrough
        case .unauthorized:
            fallthrough
        case .poweredOff:
            showAlert(message: self.manager?.message ?? messageString, enterBlock: { (_) in
                openUrl(type: nil)
            }) { (_) in
                self.block?(false,central.state, nil)
            }
            break
        case .poweredOn:
            self.block?(true, central.state, nil)
        }
    }
}


// MARK: - 语音识别
extension AuthorityManager {
    @available(iOS 10.0, *)

    /// 语音识别
    ///
    /// - Parameter block: 回调
    public func speechRecognitionAuthority(block: ReturnBlock?){
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .authorized:
            block?(true, status,nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { (status) in
                block?(status == .authorized ? true : false , status , nil)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}

// MARK: - Notification
extension AuthorityManager {
//    @available(iOS 8, *)
//    public func notificationRomateAuthority(block: ReturnBlock?) {
//        if !UIApplication.shared.isRegisteredForRemoteNotifications {
//            let type = UIApplication.shared.currentUserNotificationSettings?.types
//            if  type == UIUserNotificationType.init(rawValue: 0) {
//
//                enterSetting {
//                    block?(false,type, nil)
//                }
//            }else {
//                block?(true, type, nil)
//            }
//        }
//    }
//
    @available(iOS 10.0, *)

    /// 通知
    ///
    /// - Parameters:
    ///   - options: UNAuthorizationOptions 枚举
    ///   - block: 回调
    public func notificationCenterAuthority(options: UNAuthorizationOptions,block: ReturnBlock?){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                block?(true, UNAuthorizationStatus.authorized, nil)
                break
            case .denied:
                DispatchQueue.main.async {
                    self.enterSetting {
                        block?(false, settings.authorizationStatus, nil)
                    }
                }
                break
            case .notDetermined:
                center.requestAuthorization(options: options) { (result , error) in
                    block?(result, result == true ? UNAuthorizationStatus.authorized : .notDetermined, error)
                }
                break
            case .provisional:
                if #available(iOS 12.0, *) {
                    block?(true, UNAuthorizationStatus.provisional, nil)
                } else {
                    // Fallback on earlier versions
                }
                break
            }
        }
    }
}
// MARK: - Face Id / Touch Id
extension AuthorityManager {

    /// Touch ID error Type

    public enum TouchIDAuthority:Error {

        /// 不支持
        case notSupport

        /// localizedDescription 描述
        public var localizedDescription: String {
            return "not support Touch ID or Face ID"
        }
    }
    /// 是否支持
    ///
    /// - Parameter block:
    public func faceOrTouchIDAuthority(block: ReturnBlock?){
        let context = LAContext()
        var error:NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if let e = error {
                block?(false, nil,e)
            }else {
                block?(true, nil, nil)
            }
        }else {
            block?(false,nil,TouchIDAuthority.notSupport)
        }
    }
    //                switch Int32(e.code) {
    //                // 未设置密码
    //                case kLAErrorPasscodeNotSet:
    //                    block?(false, LAError.passcodeNotSet, error)
    //                    return
    //                // 不可用 未打开
    //                case kLAErrorTouchIDNotAvailable:
    //                    block?(false, LAError.touchIDNotAvailable, error)
    //                    return
    //                // 用户未录入
    //                case kLAErrorTouchIDNotEnrolled:
    //                    block?(false, LAError.touchIDNotEnrolled, error)
    //                    return
    //                default:
    //                    break
    //                }
}

// MARK: - 定位权限
extension AuthorityManager {

    /// 定位枚举
    ///
    /// - Always: 一直允许
    /// - WhenInUse: 只有使用时允许
    public enum LocaltionType {

        /// 一直允许
        case Always
        
        /// 使用时允许
        case WhenInUse
    }
    
    /// 定位权限
    ///
    /// - Parameters:
    ///   - type: 类型枚举 默认 一直允许
    ///   - block: 回调
    public func locationAuthority(type:LocaltionType = .Always,block: ReturnBlock?){
        if !CLLocationManager.locationServicesEnabled() {
            block?(false, nil, NSError(domain: "service is not open", code: 0, userInfo: nil))
            return
        }
        
        localtionManager = CLLocationManager.init()
        localtionManager?.delegate = self.auxiliary
        self.auxiliary.block = block
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            if type == .Always {
                localtionManager?.requestAlwaysAuthorization()
            }else {
                localtionManager?.requestWhenInUseAuthorization()
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .authorizedAlways:
            block?(true, status, nil)
            break
        case .authorizedWhenInUse:
            block?(true, status, nil)
            break
        }
    }
}
extension Auxiliary: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.block?(status == .authorizedAlways || status == .authorizedWhenInUse ? true : false , status , nil)
    }
}



// MARK: - 日历提醒事件
extension AuthorityManager {

    /// 日历
    ///
    /// - Parameter block: 回调
    public func calendarAuthority(block: ReturnBlock?){
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            block?(true, status, nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            EKEventStore.init().requestAccess(to: .reminder) { (result, error) in
                block?(result, result == true ? EKAuthorizationStatus.authorized : .notDetermined, error)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }

    /// 提醒事件
    ///
    /// - Parameter block: 回调
    public func remindEventAuthority(block: ReturnBlock?){
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            block?(true, status,nil)
            break
        case .denied:
            enterSetting {
                block?(false, status, nil)
            }
            break
        case .notDetermined:
            EKEventStore.init().requestAccess(to: .event) { (result, error) in
                block?(result, result == true ? EKAuthorizationStatus.authorized : .notDetermined, error)
            }
            break
        case .restricted:
            enterSetting {
                block?(false, status, nil)
            }
            break
        }
    }
}



// MARK: - NFC
extension AuthorityManager {
    @available(iOS 11.0, *)

    /// NFC
    ///
    /// - Parameter block: 回调
    public func nfcAuthority(block: ReturnBlock?){
        let _ = NFCNDEFReaderSession(delegate: self.auxiliary, queue: nil, invalidateAfterFirstRead: true)
        if !NFCNDEFReaderSession.readingAvailable {
            block?(false , nil , NSError(domain: "is not support NFC or not work", code: 0, userInfo: nil))
            return
        }
        block?(true, nil, nil)
    }
}

extension Auxiliary: NFCNDEFReaderSessionDelegate {
    @available(iOS 11.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    @available(iOS 11.0, *)
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
}

// MARK: - Wallet
extension AuthorityManager {

    /// Wallet
    ///
    /// - Parameter block: 回调
    public func walletAuthority(block: ReturnBlock?){
        if !PKPassLibrary.isPassLibraryAvailable() {
            block?(false, nil , NSError(domain: "is not support wallet", code: 0, userInfo: nil))
            return
        }
        if !PKAddPassesViewController.canAddPasses() {
            block?(false, nil , NSError(domain: "is not support wallet", code: 0, userInfo: nil))
            return
        }
        block?(true, nil, nil)
    }
}


// MARK: - Apple Pay
extension AuthorityManager {
    @available(iOS 10.0, *)

    /// Apple Pay
    ///
    /// - Parameter block: 回调
    public func applePayAuthority(block: ReturnBlock?){
        if !PKPaymentAuthorizationController.canMakePayments() {
            block?(false, nil , NSError(domain: "is not support apple pay,pleace upload system", code: 0, userInfo: nil))
            return
        }
        block?(true, nil, nil)
    }
}

extension AuthorityManager {
    /// 网络权限
    ///
    /// - Parameter block: 权限回调
    @available(iOS 9.0, *)

    /// 网络
    ///
    /// - Parameter block: 回调
    public func coreTelephonyAuthority(block: ReturnBlock?) {
        
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = {(state) in
            switch state {
            case .restrictedStateUnknown:
                self.enterSetting {
                    block?(false, nil, nil)
                }
                break
            case .restricted:
                self.enterSetting {
                    block?(false, nil, nil)
                }
                break
            case .notRestricted:
                block?(true, nil, nil)
                break
            }
        }
    }
}



// MARK: - private method
extension AuthorityManager {
    private func enterSetting(block:@escaping() -> Void) {
        showAlert(message: message, enterBlock: { (_) in
            openUrl(type: nil)
        }) { (_) in
            block()
        }
    }
}



fileprivate func openUrl(type: AuthorityURLType?) {
    if #available(iOS 10.0, *) {
        let url = URL(string: UIApplicationOpenSettingsURLString) ?? URL.init(string: "")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }else {
        let url = URL(string: type?.rawValue ?? UIApplicationOpenSettingsURLString) ?? URL(string: "")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

fileprivate func showAlert(title: String? = nil, message: String,cancelTitle:String? = cancelString, enterTitle: String = enterString, enterBlock: @escaping ((_ action: UIAlertAction)-> Void),cancelBlock: ((_ action: UIAlertAction)-> Void)?) {
    let alertVC =  UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let cancel = cancelTitle {
        alertVC.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelBlock))
    }
    alertVC.addAction(UIAlertAction(title: enterTitle, style: .default, handler: enterBlock))
    let vc = UIApplication.shared.keyWindow?.rootViewController
    vc?.present(alertVC, animated: true, completion: nil)
}


