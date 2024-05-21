//
//  FirebaseTracking.swift
//  GMA
//
//  Created by Hoan Nguyen on 18/03/2022.
//

import Foundation
import Firebase


let platformName = "iOS"
class FirebaseTracking {
    static let share = FirebaseTracking()
    
    func setUserProperty(){
        Analytics.setUserProperty(UserPropertyName.customer_id.trackingValue.MD5, forName: UserPropertyName.customer_id.stringValue)
        Analytics.setUserProperty(UserPropertyName.country.trackingValue, forName: UserPropertyName.country.stringValue)
        Analytics.setUserProperty(UserPropertyName.city.trackingValue, forName: UserPropertyName.city.stringValue)
        Analytics.setUserProperty(UserPropertyName.language_selected.trackingValue, forName: UserPropertyName.language_selected.stringValue)
        Analytics.setUserProperty(UserPropertyName.membership_type.trackingValue, forName: UserPropertyName.membership_type.stringValue)
        Analytics.setUserProperty(UserPropertyName.login_status.trackingValue, forName: UserPropertyName.login_status.stringValue)
    }
    
    
//    func logScreen(viewController: UIViewController) {
//        var screenName = ""
//        if let webScreen = viewController as? WebViewController {
//            screenName = webScreen.getContentType().title + " Screen"
//        }else {
//            let className = String(describing: type(of: viewController.self))
//            if let sn = FirebaseScreenWithNameDics[className]{
//                screenName = sn
//            }
//        }
//        if !screenName.isEmpty {
//            Analytics.logEvent(AnalyticsEventScreenView, parameters: ["platform_name": platformName, "screen_name": screenName])
//        }
//    }
    
//    func logEvent(event: FirebaseEvent, viewController: UIViewController?, parameter: [String: Any]) {
//        let dic = NSMutableDictionary(dictionary: parameter)
//        var screenName = ""
//        if let webScreen = viewController as? WebViewController {
//            screenName = webScreen.getContentType().title + " Screen"
//        }else if let screen = viewController{
//            let className = String(describing: type(of: screen.self))
//            if let sn = FirebaseScreenWithNameDics[className]{
//                screenName = sn
//            }
//        }
//        dic.addEntries(from: ["platform_name": platformName, "screen_name": screenName])
//        
//        let updateEventNames:[FirebaseEvent] = [.category_listing_screen_view, .category_listing_place_request, .category_detail_screen_view, .category_detail_make_reservation , .booking_detail_screen_view, . booking_detail_make_reservation, .booking_confirmation_screen_view]
//        var eventName = event.stringValue.withReplacedCharacters("_screen_view", by: "")
//        if updateEventNames.contains(event), let category = parameter["category"] as? String{
//            eventName = category.lowercased() + "_" + eventName
//        }
//        if !screenName.isEmpty {
//            Analytics.logEvent(eventName, parameters: (dic as! [String : Any]))
//        }
//    }
    
//    func logEventScreenError(errorType: ErrorType, errorCode: Int, errorURL: String?) {
//        let viewController = UIApplication.shared.topMostViewController()
//        var screenName = ""
//        if let webScreen = viewController as? WebViewController {
//            screenName = webScreen.getContentType().title + " Screen"
//        }else {
//            let className = String(describing: type(of: viewController.self))
//            if let sn = FirebaseScreenWithNameDics[className]{
//                screenName = sn
//            }
//        }
//        let parameter =  ["platform_name": platformName,
//                          "screen_name": screenName,
//                          UserPropertyName.login_status.stringValue: UserPropertyName.login_status.trackingValue,
//                          "error_type": errorType.stringValue,
//                          "error_code": errorCode,
//                          "error_screen": ((errorURL == nil) ? "" : errorURL)!] as [String : Any]
//        if !screenName.isEmpty {
//            Analytics.logEvent("error_screen_view", parameters: parameter)
//        }
//    }
    
    
//    let FirebaseScreenWithNameDics = [
//        String(describing: SplashViewController.self): "Splash Screen",
//        String(describing: SignInViewController.self): "SignIn Screen",
//        String(describing: VerifyAccessCodeViewController.self):"Verify AccessCode Screen",
//        String(describing: VerifyEmailViewController.self):"Verify Email Screen",
//        String(describing: CreatePasswordViewController.self): "Create Password Screen",
//        String(describing: AccessCodeExpiredViewController.self): "Access Code Expired Screen",
//        String(describing: AccountBlockOutViewController.self): "Account BlockOut Screen",
//        String(describing: VerifyViaSMSViewController.self): "Choose Method Verify Account Screen",
//        String(describing: VerifyViaEmailViewController.self): "Choose Method Verify Account Screen",
//        String(describing: ForgotPasswordViewController.self): "Forgot Password Screen",
//        String(describing: CreateNewPasswordViewController.self): "Create New Password Screen",
//        String(describing: NewPasswordCreatedViewController.self): "Create New Password Finish Screen",
//        String(describing: ValidateOTPViewController.self): "Verify OTP Screen",
//        String(describing: personalInfoViewController.self): "Personal Info Screen",
//        String(describing: HomeViewController.self): "Home Screen",
//        String(describing: LocationSearchViewController.self): "Location Search Screen",
//        String(describing: ChangePasswordViewController.self): "Change Password Screen",
//        String(describing: EditProfileInfoViewController.self): "Edit Profile Screen",
//        String(describing: SettingsViewController.self): "Setting Screen",
//        String(describing: ExploreListViewController.self): "Category Listing Screen",
//        String(describing: ExploreSearchViewController.self): "Category Listing Search Screen",
//        String(describing: ExploreDetailsViewController.self): "Category Listing Detail Screen",
//        String(describing: CreateRequestViewController.self): "Booking Detail Screen",
//        String(describing: ConfirmRequestViewController.self): "Booking Confirmation Screen",
//        String(describing: DiningBookingViewController.self): "Booking Detail Screen",
//        String(describing: DiningBookingConfirmViewController.self): "Booking Confirmation Screen",
//        String(describing: ExplorerFilterViewController.self): "Category Listing Filter Screen",
//        String(describing: CreateRequestSuccessfullViewController.self): "Booking Successfull Screen",
//        String(describing: SelectLocationViewController.self): "Choose City Screen",
//        String(describing: SelectCategoryViewController.self): "Choose Category Screen",
//        String(describing: PreferencesViewController.self): "Preferences Screen",
//        String(describing: SettingsLanguageViewController.self): "Setting Language Screen",
//        String(describing: RequestFilterViewController.self): "History Request Filter Screen",
//        String(describing: RequestDetailViewController.self): "History Request Detail Screen",
//        String(describing: RequestSearchViewController.self): "History Request Search Screen",
//        String(describing: RequestViewController.self): "History Request Screen",
//        String(describing: SeeWhatWeCanDoScreen.self): "SeeWhatWeCanDo Screen",
//        String(describing: UpdateLocationCategoryViewController.self): "Update Location/Category Screen",
//        String(describing: ChatViewController.self): "Chat Screen",
//        
//        String(describing: LimoViewController.self): "Limo main screen",
//        String(describing: FlightInfoViewController.self): "Flight infor screen",
//        String(describing: LimoBookingTripDetailViewController.self): "Limo Booking Trip Detail",
//        String(describing: LimoBookingVehicleDetailViewController.self): "LimoBookingVehicleDetailViewController",
//        String(describing: LimoBookingSummaryViewController.self): "LimoBookingSummaryViewController",
//        String(describing: LimoBookingPassengerViewController.self): "LimoBookingPassengerViewController",
//        String(describing: LimoBookingPaymentViewController.self): "LimoBookingPaymentViewController",
//        String(describing: LimoTripSummaryDetailViewController.self): "LimoTripSummaryDetailViewController",
//        String(describing: LimoTripQuotationDetailViewController.self): "LimoTripQuotationDetailViewController",
//        String(describing: LimoInputFlightNumberViewController.self): "LimoInputFlightNumberViewController",
//        String(describing: LimoBookingFailedViewController.self): "LimoBookingFailedViewController",
//        
//        // about, privacy, term of use
//        String(describing: WebViewController.self): "About, Privacy, Term Of Use"
//        
//    ]
}

enum FirebaseEvent{
    case login
    case logout
    case registration_initiated
    case registration_step1_card_details
    case registration_step2_email
    case registration_step3_password
    case registration_step4_two_factor_authentication
    case registration_journey_step5_for_success_registration
    case registration_journey_account_blocked
    case home_page_screen_View
    case login_blocked
    case chat_click
    case category_selection
    case category_listing_screen_view
    case search_term
    case category_detail_screen_view
    case category_detail_make_reservation
    case booking_detail_screen_view
    case booking_detail_make_reservation
    case booking_confirmation_screen_view
    case concierge_service
    case category_listing_place_request
    
    var stringValue:  String  {
        return String(describing: self)
    }
}

enum UserPropertyName{
    case customer_id
    case country
    case city
    case language_selected
    case membership_type
    case login_status

    
    var stringValue:  String  {
        return String(describing: self)
    }
    
    var trackingValue: String {
        switch self {
        case .customer_id:
            if let profileID = CurrentSession.share.aspireProfile?.partyID {
                return profileID
            }else {
                return ""
            }
        case .country:
            if let country = CurrentSession.share.aspireProfile?.homeCountry {
                return country
            }else {
                return ""
            }
        case .city:
//            if let city = CurrentSession.share.citySelected?.name {
//                return city
//            }else {
//                return ""
//            }
            return ""
        case .language_selected:
            return CurrentSession.share.currentLanguage
        case .membership_type:
            if let mebershipType = CurrentSession.share.programDetail?.tier {
                return mebershipType
            }else {
                return ""
            }
        case .login_status:
            if let _ = CurrentSession.share.aspireProfile {
                return LoginStatus.logged_in.stringValue
            }else {
                return LoginStatus.non_logged_in.stringValue
            }
        }
    }
}

enum ErrorType {
    case system_error
    case server_error
    case server_down
    
    var stringValue: String{
        switch self {
        case .server_error:
            return "server error"
        case .system_error:
            return "system error"
        case .server_down:
            return "API Down"
        }
    }
}

enum LoginStatus {
    case logged_in
    case non_logged_in
    
    var stringValue:  String  {
        return String(describing: self)
    }
}
