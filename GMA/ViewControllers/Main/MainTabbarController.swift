//
//  MainTabbarController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

//
//  MainTabbarController.swift
//  GMA
//
//  Created by Hoan Nguyen on 22/02/2022.
//

import Foundation
import UIKit
import ACProgressHUD_Swift
import CoreLocation
import FirebaseCrashlytics

class MainTabbarController: UITabBarController, UITabBarControllerDelegate {


    static var shared: MainTabbarController!

    var kenticoDic: [String: Any]?
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name(k_LANGUAGE_CHANGE), object: nil)
        MainTabbarController.shared = self
        super.viewDidLoad()
        self.loadTextFromCMS()
        self.delegate = self
        Crashlytics.crashlytics().setUserID(CurrentSession.share.oktaProfile?.id ?? "")
        if let tabbar = self.tabBar as? CustomTabbar {
            tabbar.prominentButtonCallback =  {
                self.showContactScreen()
                print("")
            }
        }
    }
    
    @objc func updateLanguage() {
        self.loadTextFromCMS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        CurrentSession.share.removeDataToChangeLanguage()
    }
    
    private func loadTextFromCMS() {
        KenticoServices().getContent(codeName: "app_footer_menu", depth: 1) { result in
            switch result{
            case .success(let dic):
                self.kenticoDic = dic
                DispatchQueue.main.async {
                    self.setText()
                }
            case .failure(let failure):
                Crashlytics.crashlytics().record(error: failure)
                break
            }
        }
    }
    
    private func setText() {
        if let kenDic = self.kenticoDic {
            if let homeTitle = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app_footer_menu_home.elements.label.value") as? String {
                self.tabBar.items?[0].title = homeTitle
                self.tabBar.items?[0].accessibilityIdentifier = homeTitle
            }
            if let exploreTitle = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app_footer_menu_explore.elements.label.value") as? String {
                self.tabBar.items?[1].title = exploreTitle
                self.tabBar.items?[1].accessibilityIdentifier = exploreTitle
            }
            if let contactTitle = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___footer_menu_contact_us.elements.label.value") as? String {
                self.tabBar.items?[2].title = contactTitle
                self.tabBar.items?[2].accessibilityIdentifier = contactTitle
            }
            if let requestTitle = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app_footer_menu_request.elements.label.value") as? String {
                self.tabBar.items?[3].title = requestTitle
                self.tabBar.items?[3].accessibilityIdentifier = requestTitle
            }
            if let moreTitle = KenticoServices.getKenticoValue(dict: kenDic, path: "modular_content.app___footer_menu_more.elements.label.value") as? String {
                self.tabBar.items?[4].title = moreTitle
                self.tabBar.items?[4].accessibilityIdentifier = moreTitle
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if self.updatePhoneNumberIfNeeded() {
//            return
//        }
        if let appdeledate = UIApplication.shared.delegate as? AppDelegate {
            NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification), name: NSNotification.Name(KPUSH_MESSAGE_ARRIVED), object: nil)
            if appdeledate.isPushMessageArrived {
                self.showChatConversation()
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = self.tabBar.items else {
            Crashlytics.crashlytics().log("\(self.classForCoder): items tabBar is nil")
            return
        }
        let index = items.firstIndex(of: item)
        if (index == 2){
            self.showContactScreen()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = self.viewControllers?.firstIndex(of: viewController)
        if index == TABBAR.CONTACT_US.rawValue {
            return false
        }
//        if index == TABBAR.EXPLORE.rawValue {
//            if let currentScreen = UIApplication.shared.topMostViewController() as? BaseViewController{
//                if let _ = CurrentSession.share.citySelected {
//                    if let _ = CurrentSession.share.categorySelected {
//                       return true
//                    }else {
//                        let categoryScreen = SelectCategoryViewController()
//                        categoryScreen.hidesBottomBarWhenPushed = true
//                        currentScreen.navigationController?.pushViewController(categoryScreen, animated: true)
//                        return false
//                    }
//                }else {
//                    let locationScreen = SelectLocationViewController()
//                    locationScreen.hidesBottomBarWhenPushed = true
//                    currentScreen.navigationController?.pushViewController(locationScreen, animated: true)
//                    return false
//                }
//            }
//        }
        return true
    }

    func switchToExploreScreen() {
//        if let currentScreen = UIApplication.shared.topMostViewController() as? BaseViewController {
//            if let _ = CurrentSession.share.citySelected {
//                if let _ = CurrentSession.share.categorySelected {
//                    currentScreen.navigationController?.popToRootViewController(animated: false)
//                    self.selectedIndex = TABBAR.EXPLORE.rawValue
//                } else {
//                    let categoryScreen = SelectCategoryViewController()
//                    categoryScreen.hidesBottomBarWhenPushed = true
//                    currentScreen.navigationController?.pushViewController(categoryScreen, animated: true)
//                }
//            } else {
//                let locationScreen = SelectLocationViewController()
//                locationScreen.hidesBottomBarWhenPushed = true
//                currentScreen.navigationController?.pushViewController(locationScreen, animated: true)
//            }
//        }
    }

    func switchToExploreLimoScreen(bookingResponse:GetBookingResponse) {
        if let currentScreen = UIApplication.shared.topMostViewController() as? BaseViewController {
            CurrentSession.share.categorySelected = limoCategory
            currentScreen.navigationController?.popToRootViewController(animated: false)
            Task.init {
                do{
                    let pickupCity = try await LocationManager.shared.getPlace(for: CLLocation(latitude: bookingResponse.first?.pickup?.address?.latitude ?? 0.0, longitude: bookingResponse.first?.pickup?.address?.longitude ?? 0.0))
                    
                    let dropOffCity = try await LocationManager.shared.getPlace(for: CLLocation(latitude: bookingResponse.first?.dropoff?.address?.latitude ?? 0.0, longitude: bookingResponse.first?.dropoff?.address?.longitude ?? 0.0))
                    
                    let pickUpLocation = LocationSearch(placeId: "", attributedPrimaryText: bookingResponse.first?.pickup?.address?.addressLine1 ?? "", attributedSecondaryText: bookingResponse.first?.pickup?.address?.addressLine2 ?? "", type: [], countryCode: pickupCity?.countryCode, city: pickupCity?.city, coordinate: pickupCity?.coordinate)
                    let dropOffLocation = LocationSearch(placeId: "", attributedPrimaryText: bookingResponse.first?.dropoff?.address?.addressLine1 ?? "", attributedSecondaryText: bookingResponse.first?.dropoff?.address?.addressLine2 ?? "", type: [], countryCode: dropOffCity?.countryCode, city: dropOffCity?.city, coordinate: dropOffCity?.coordinate)
//                    LimoBookingManager.share.pickupLocation = pickUpLocation
//                    LimoBookingManager.share.dropoffLocation = dropOffLocation
                    self.selectedIndex = TABBAR.EXPLORE.rawValue
                }catch{
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
        }
    }
    func switchToRequestScreen() {
        self.selectedIndex = TABBAR.REQUEST.rawValue
    }

    func switchToHomeScreen() {
        self.selectedIndex = TABBAR.HOME.rawValue
    }

    // show chat, call option
    func showContactScreen(isBookingViaConcierge: Bool = false) {
        let contactVC = ContactViewController()
        contactVC.isBookingViaConcierge = isBookingViaConcierge
        contactVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(contactVC, animated: true, completion: nil)
    }
    

    func showChatConversation() {
//        FirebaseTracking.share.logEvent(event: FirebaseEvent.chat_click, viewController: self, parameter: [:])
//        if let appdeledate = UIApplication.shared.delegate as? AppDelegate {
//            appdeledate.isPushMessageArrived = false
//        }
//        if let currentScreen = UIApplication.shared.topMostViewController(),  !currentScreen.isKind(of: ChatViewController.self) {
//            if let currentNavigationController = self.viewControllers?[self.selectedIndex] as? UINavigationController {
//                currentNavigationController.setCommomNavigationBar()
//              let chatScreen = ChatViewController()
//              chatScreen.hidesBottomBarWhenPushed = true
//              currentNavigationController.navigationBar.isHidden = false
//              currentNavigationController.pushViewController(chatScreen, animated: true)
//            }
//        }
    }
    
    @objc func handlePushNotification() {
        if let appdeledate = UIApplication.shared.delegate as? AppDelegate {
            if appdeledate.isPushMessageArrived {
                self.showChatConversation()
            }
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    private func updatePhoneNumberIfNeeded()-> Bool {
        guard let countryHomeCode = CurrentSession.share.aspireProfile?.phones?.first?.phoneCountryCode, !countryHomeCode.isEmpty else{
            let forceVC = ForceUpdatePhoneViewController()
            let navController = UINavigationController(rootViewController: forceVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            return true
        }
        return false
    }
}


enum TABBAR: Int {
    case HOME = 0
    case EXPLORE = 1
    case CONTACT_US = 2
    case REQUEST = 3
    case MORE = 4
}
