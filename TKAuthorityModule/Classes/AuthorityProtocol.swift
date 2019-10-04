//
//  AuthorityProtocol.swift
//  TKAuthorityModule
//
//  Created by 聂子 on 2019/1/10.
//

import Foundation
import AVFoundation
import StoreKit
import HealthKit
import MediaPlayer
import LocalAuthentication
import CoreLocation
import CoreBluetooth
import NotificationCenter
import EventKit
import CoreTelephony
import UserNotifications
import Contacts
import AddressBook
import AssetsLibrary
import Photos
import Speech


/// Authority Protocol
public protocol AuthorityProtocol {}


extension PHAuthorizationStatus: AuthorityProtocol{}
extension ABAuthorizationStatus: AuthorityProtocol{}
extension CTCellularDataRestrictedState: AuthorityProtocol{}
extension AVAuthorizationStatus: AuthorityProtocol{}


extension EKAuthorizationStatus : AuthorityProtocol{}

@available(iOS 10.0, *)
extension UNAuthorizationStatus : AuthorityProtocol {}

extension LAError.Code : AuthorityProtocol{}

extension CLAuthorizationStatus : AuthorityProtocol{}

@available(iOS 10.0, *)
extension CBManagerState : AuthorityProtocol {}


@available(iOS 9.3, *)
extension MPMediaLibraryAuthorizationStatus : AuthorityProtocol {}

extension HKAuthorizationStatus : AuthorityProtocol{}

@available(iOS 9.3, *)
extension SKCloudServiceAuthorizationStatus : AuthorityProtocol{}

extension ALAuthorizationStatus: AuthorityProtocol{}
@available(iOS 9.0, *)
extension CNAuthorizationStatus : AuthorityProtocol{}

extension CBPeripheralManagerAuthorizationStatus : AuthorityProtocol{}
@available(iOS 10.0, *)
extension SFSpeechRecognizerAuthorizationStatus : AuthorityProtocol{}

extension UIUserNotificationType : AuthorityProtocol {}
