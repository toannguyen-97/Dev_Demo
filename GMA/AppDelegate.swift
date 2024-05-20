//
//  AppDelegate.swift
//  GMA
//

//
//  AppDelegate.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import UIKit
import AlamofireNetworkActivityLogger
import IQKeyboardManagerSwift
import ACProgressHUD_Swift
import CoreLocation
import GooglePlaces
import Firebase
import UserNotifications
import LPMessagingSDK
import Adyen

let KPUSH_MESSAGE_ARRIVED = "PUSH_MESSAGE_ARRIVED"

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var isPushMessageArrived = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        GMSPlacesClient.provideAPIKey(AppContants.GOOGLEAPI_KEY)
        FirebaseApp.configure()
        setupACProgressHUD()
        
        window = UIWindow()
        let rootVC = UINavigationController(rootViewController: SplashViewController())
        rootVC.setTranparent()
        rootVC.setTranparent()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        //Disable constrains log
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        #endif
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        [IQKeyboardManager.sharedManager.disabledTouchResignedClasses addObject:[VerificationCodeViewController class]];
        
        // Register for remote push notifications
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewcontroller =  UIApplication.shared.topMostViewController(),let _ = viewcontroller.tabBarController {
            requestLocation()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LPMessaging.instance.registerPushNotifications(token: deviceToken, notificationDelegate: self)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Filed to register for push notifications. error = \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        LPMessaging.instance.handlePush(userInfo)
        if UIApplication.shared.applicationState != .active {
            self.isPushMessageArrived = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KPUSH_MESSAGE_ARRIVED), object: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if UIApplication.shared.applicationState != .active {
            self.isPushMessageArrived = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KPUSH_MESSAGE_ARRIVED), object: nil)
        }
    }
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        return false
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        RedirectComponent.applicationDidOpen(from: url)
        return true
    }
    func requestLocation(){
        let status =  LocationManager.shared.getAuthorizationStatus()
        Task.detached {
            async let enabled = CLLocationManager.locationServicesEnabled()
            if await !enabled{
                let alertController = await UIAlertController(title: AppContants.shared.cmsLocationDisableString, message: AppContants.shared.cmsEnableLocationMessageString, preferredStyle: .alert)
                let openAlert = await UIAlertAction(title: AppContants.shared.cmsSettingSystemString, style: .default) { (alertAction) in
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    
                }
                await alertController.addAction(openAlert)
                let defaultAction = await UIAlertAction(title: AppContants.shared.cmsCancelSytemString, style: .default, handler: nil)
                await alertController.addAction(defaultAction)
                DispatchQueue.main.async {
                    openAlert.accessibilityIdentifier = "Location Service Open Setting"
                    defaultAction.accessibilityIdentifier = "Location Service Cancel"
                    UIApplication.shared.topMostViewController()?.present(alertController, animated: true, completion: nil)
                }
                return
            }else if status == .denied {
                return
            }
            LocationManager.shared.request()
        }
//        if !CLLocationManager.locationServicesEnabled() {
//            let alertController = UIAlertController(title: AppContants.shared.cmsLocationDisableString, message: AppContants.shared.cmsEnableLocationMessageString, preferredStyle: .alert)
//            let openAlert = UIAlertAction(title: AppContants.shared.cmsSettingSystemString, style: .default) { (alertAction) in
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//            }
//            alertController.addAction(openAlert)
//            let defaultAction = UIAlertAction(title: AppContants.shared.cmsCancelSytemString, style: .default, handler: nil)
//            alertController.addAction(defaultAction)
//            openAlert.accessibilityIdentifier = "Location Service Open Setting"
//            defaultAction.accessibilityIdentifier = "Location Service Cancel"
//            DispatchQueue.main.async {
//                UIApplication.shared.topMostViewController()?.present(alertController, animated: true, completion: nil)
//            }
//            return
//        }else if status == .denied {
//            return
//        }
//        LocationManager.shared.request()
    }
}

extension AppDelegate: LPMessagingSDKNotificationDelegate{
    
    func LPMessagingSDKNotification(shouldShowPushNotification notification: LPNotification) -> Bool {
        return true
    }
    
    //This reflects only on physical device because we are confirming this delegate in didRegisterForRemoteNotifications method.
//    func LPMessagingSDKNotification(customLocalPushNotificationView notification: LPNotification) -> UIView{
//        let view = MessageView(frame: CGRect(x: 10, y: 40, width: UIScreen.main.bounds.width - 20, height: 80))
//        view.set(with: notification)
//        return view
//    }
    
    func LPMessagingSDKNotification(didReceivePushNotification notification: LPNotification) {
        // ill handle this after recieve notification
        print("push notification received")
    }
    
    func LPMessagingSDKNotification(notificationTapped notification: LPNotification) {
        self.isPushMessageArrived = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KPUSH_MESSAGE_ARRIVED), object: nil)
    }
    
}


extension AppDelegate {
    func  setupACProgressHUD() {
        ACProgressHUD.shared.hudBackgroundColor = UIColor.clear
        ACProgressHUD.shared.progressText = ""
        ACProgressHUD.shared.progressTextFont =  UIFont(name: Fonts.regularFont, size: Sizes.titleText) ?? UIFont.systemFont(ofSize: Sizes.titleText)
        ACProgressHUD.shared.progressTextColor = Colors.navigationBarTitle
        ACProgressHUD.shared.indicatorColor = Colors.loadingIndicatorColor
    }
}
