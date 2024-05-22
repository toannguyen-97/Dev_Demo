//
//  RequestCell.swift
//  GMA
//
//  Created by toan.nguyenq on 5/22/24.
//

import UIKit

class RequestCell: UITableViewCell {
    var kenticoDic: [String: Any]?
    // CMS String
    var cmsCancelledString = "Cancelled"


    @IBOutlet private var cardView: UIView!
    @IBOutlet private var shadowView: UIView!

    @IBOutlet private var categoryConainerView: UIView!
    @IBOutlet private var lblCategory: UILabel!

    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDetail: UILabel!

    @IBOutlet private var lblCanceled: UILabel!

    private var requestCategory: String?

    var isCloseStatus = false {
        didSet {
            if isCloseStatus {
                self.categoryConainerView.backgroundColor = Colors.caramel
                self.cardView.backgroundColor = Colors.creamBackground
                self.lblCategory.textColor = Colors.navigationBarTitle
                self.lblTitle.textColor = Colors.blueBackground
                self.lblDetail.textColor = Colors.headerTitle
            } else {
                self.categoryConainerView.backgroundColor = Colors.creamBackground
                self.cardView.backgroundColor = Colors.blueBackground
                self.lblCategory.textColor = Colors.blueBackground
                self.lblTitle.textColor = Colors.navigationBarTitle
                self.lblDetail.textColor = Colors.navigationBarButtonItemTitle
            }
        }
    }

//    var requestItem: RequestItem? {
//        didSet {
//            if let request = requestItem, let category = request.categoryName {
//                self.lblCanceled.isHidden = false
//                self.lblCanceled.text = ""
//                self.lblCanceled.textColor = Colors.navigationBarTitle
//                self.requestCategory = category
//                let cmsStr = self.getTextFromCMS()
//                self.lblCategory.text = "  \(cmsStr.category)  "
//                if category == limoCategory{
//                    self.lblTitle.text = cmsStr.limoOneWaytrip
//                }else{
//                    if let vendorName = request.vendorName, !vendorName.isEmpty {
//                        self.lblTitle.text = vendorName
//                    } else if let popularVendor = request.popularVendor, !popularVendor.isEmpty {
//                        self.lblTitle.text = popularVendor
//                    } else {
//                        self.lblTitle.text = ""
//                    }
//                }
//                
//
//                if let timeStr = request.eventStartDate {
//                    var guestStr = cmsStr.pluralGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(request.numberInParty)")
//                    if request.numberInParty <= 1 {
//                        guestStr = cmsStr.singularGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(request.numberInParty)")
//                    }
//                    if category == cruisesCategory || category == vacationPackagesCategory {
//                        let dateFormatter = DateFormatter()
////                        dateFormatter.locale = AppContants.localeLogic
//                        dateFormatter.dateFormat = AppContants.dayDateFormat
//                        let dateStr = dateFormatter.string(from: self.getRequestDateFromString(dateStr: timeStr) ?? Date())
//                        self.lblDetail.text = "\(dateStr) •‎ \(guestStr)"
//                        self.lblCanceled.text = request.paramlists?.region ?? ""
//                    } else {
//                        let startTime = self.requestDateToShow(date: self.getRequestDateFromString(dateStr: timeStr))
//                        if category == hotelCategory {
//                            if let endTimeStr = request.eventEndDate {
//                                let hotelDates = self.hotelCheckInCheckOutString(checkIn: self.getRequestDateFromString(dateStr: timeStr), checkOut: self.getRequestDateFromString(dateStr: endTimeStr))
//                                self.lblDetail.text = "\(hotelDates) •‎ \(guestStr)"
//                            }
//                        } else {
//                            if category == limoCategory {
//                                guestStr = cmsStr.pluralPassengerStr.replacingOccurrences(of: "[number of passengers]", with: "\(request.numberInParty)")
//                                if request.numberInParty <= 1 {
//                                    guestStr = cmsStr.singularPassengerStr.replacingOccurrences(of: "[number of passengers]", with: "\(request.numberInParty)")
//                                }
//                            }
//                            self.lblDetail.text = "\(startTime) •‎ \(guestStr)"
//                        }
//                        self.lblCanceled.text = request.paramlists?.city ?? request.eventCity ?? ""
//                    }
//                }
//                if let ouc = request.outcome, ouc.lowercased().contains("cancelled") {
//                    self.lblCanceled.textColor = Colors.redText
//                    self.lblCanceled.text = cmsCancelledString
//                    self.lblCanceled.isHidden = false
//                }
//            }
//        }
//    }

//    var createRequestData: CreateRequest? {
//        didSet {
//            if let request = createRequestData {
//                if let category = request.paramlists?.category {
//                    self.requestCategory = category
//                } else {
//                    self.requestCategory = RequestItem.requestTypeValue(requestType: request.requestType)
//                }
//                let cmsStr = self.getTextFromCMS()
//                self.lblCategory.text = "  \(cmsStr.category)  "
//                if let vendorName = request.restaurantName {
//                    self.lblTitle.text = vendorName.trim()
//                }
//                self.lblTitle.sizeToFit()
//                if let timeStr = request.bookingDate, let numberA = request.pax?.numberInParty() {
//                    var guestStr = cmsStr.pluralGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(numberA)")
//                    if numberA <= 1 {
//                        guestStr = cmsStr.singularGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(numberA)")
//                    }
//                    if self.requestCategory == cruisesCategory || self.requestCategory == vacationPackagesCategory || self.requestCategory == limoCategory {
//                        self.lblCanceled.text = request.paramlists?.region ?? ""
//                        let dateFormatter = DateFormatter()
////                        dateFormatter.locale = AppContants.localeLogic
//                        dateFormatter.dateFormat = AppContants.dayDateFormat
//                        let dateStr = dateFormatter.string(from: self.getRequestDateFromString(dateStr: timeStr) ?? Date())
//                        self.lblDetail.text = "\(dateStr) •‎ \(guestStr)"
//                    } else {
//                        if self.requestCategory == hotelCategory, let endDateString = request.bookingEndDate {
//                            let hotelDates = self.hotelCheckInCheckOutString(checkIn: self.getRequestDateFromString(dateStr: timeStr), checkOut: self.getRequestDateFromString(dateStr: endDateString))
//                            self.lblDetail.text = "\(hotelDates) •‎ \(guestStr)"
//                        } else {
//                            let startTime = self.requestDateToShow(date: self.getRequestDateFromString(dateStr: timeStr))
//                            self.lblDetail.text = "\(startTime) •‎ \(guestStr)"
//                        }
//                        self.lblCanceled.text = request.paramlists?.city ?? ""
//                    }
//                }
//                self.lblCanceled.isHidden = false
//                self.lblCanceled.textColor = Colors.navigationBarTitle
//            }
//        }
//    }
//
//    var diningBookingInfo: (date: String, time: String, pax: Int, diningData: DiningItem)? {
//        didSet {
//            self.lblCanceled.isHidden = false
//            self.requestCategory = diningCategory
//            let cmsStr = self.getTextFromCMS()
//            if let bookingInfo = diningBookingInfo {
//                self.lblCategory.text = "  \(cmsStr.category)  "
//                if let name = bookingInfo.diningData.name {
//                    self.lblTitle.text = name
//                }
//                let startTime = self.requestDateToShow(date: self.getRequestDateFromString(dateStr: bookingInfo.date + " " + bookingInfo.time))
//                var guestStr = cmsStr.pluralGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(bookingInfo.pax)")
//                if bookingInfo.pax <= 1 {
//                    guestStr = cmsStr.singularGuestStr.replacingOccurrences(of: "[number_of_guests]", with: "\(bookingInfo.pax)")
//                }
//                self.lblDetail.text = "\(startTime) •‎ \(guestStr)"
//                self.lblCanceled.textColor = Colors.navigationBarTitle
//                self.
//            }lblCanceled.text = bookingInfo.diningData.address?.city ?? (CurrentSession.share.citySelected?.name ?? "")
//            }
//    }
//
//    var limoBookingInfo: GetQuoteResponse? {
//        didSet {
//            self.lblCanceled.isHidden = false
//            self.requestCategory = limoCategory
//            let cmsStr = self.getTextFromCMS()
//            if let limoBookingInfo = limoBookingInfo {
//                self.lblCategory.text = "  \(cmsStr.category)  "
//                self.lblTitle.text = cmsStr.limoOneWaytrip
//                let startTime = self.requestDateToShow(date: self.getRequestDateFromString(dateStr: limoBookingInfo.pickup?.dateTime ?? ""))
//                var guestStr = cmsStr.pluralPassengerStr.replacingOccurrences(of: "[number_of_guests]", with: "\(LimoBookingManager.share.expectedPassengerCount ?? 0)")
//                if LimoBookingManager.share.expectedPassengerCount ?? 0 <= 1 {
//                    guestStr = cmsStr.singularPassengerStr
//                }
//                guestStr = cmsStr.pluralPassengerStr.replacingOccurrences(of: "[number of passengers]", with: "\(LimoBookingManager.share.expectedPassengerCount ?? 0)")
//                if LimoBookingManager.share.expectedPassengerCount ?? 0 <= 1 {
//                    guestStr = cmsStr.singularPassengerStr.replacingOccurrences(of: "[number of passengers]", with: "\(LimoBookingManager.share.expectedPassengerCount ?? 0)")
//                }
//                self.lblDetail.text = "\(startTime) •‎ \(guestStr)"
//                self.lblCanceled.textColor = Colors.navigationBarTitle
//                self.lblCanceled.text = limoBookingInfo.dropoff?.address?.city ?? ""
//            }
//        }
//    }
//    func getRequestDateFromString(dateStr: String) -> Date? {
//
//        return dateStr.yyyyMMddHHmmToDate()
//    }

//    func requestDateToShow(date: Date?) -> String {
//        let cmsStr = self.getTextFromCMS()
//        if let date = date {
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = AppContants.timeFormatToDisplay
//            let timeStr = timeFormatter.string(from: date)
//
//            let dateFormatter = DateFormatter()
////            dateFormatter.locale = AppContants.localeLogic
//            dateFormatter.dateFormat = AppContants.dayDateFormat
//            return cmsStr.dateTimeStr.withReplacedCharacters("[Date]", by: dateFormatter.string(from: date)).withReplacedCharacters("[Time]", by: timeStr)
//        }
//        return ""
//    }

//    func hotelCheckInCheckOutString(checkIn: Date?, checkOut: Date?) -> String {
//        if let cIn = checkIn, let cOut = checkOut {
//            let tFormatter = DateFormatter()
////            tFormatter.locale = AppContants.localeLogic
//            let calendar = Calendar.current
//            let inComponents = calendar.dateComponents([.day, .month, .year], from: cIn)
//            let outComponents = calendar.dateComponents([.day, .month, .year], from: cIn)
//            if inComponents.year == outComponents.year {
//                tFormatter.dateFormat = "dd MMM"
//            } else {
//                tFormatter.dateFormat = AppContants.dateFormatToDisplay
//            }
//            let cInString = tFormatter.string(from: cIn)
//            tFormatter.dateFormat = AppContants.dateFormatToDisplay
//            let cOutString = tFormatter.string(from: cOut)
//            return cInString + " - " + cOutString
//        }
//        return ""
//    }

    private func setAccessiblityIdentifier() {
        lblCategory.accessibilityIdentifier = "BookingRequestCardCategoryLabel"
        lblTitle.accessibilityIdentifier = "BookingRequestCardNameLabel"
        lblDetail.accessibilityIdentifier = "BookingRequestCardInfoLabel"
        lblCanceled.accessibilityIdentifier = "BookingRequestCardiSCancelLabel"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setAccessiblityIdentifier()
        self.setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblDetail.text = ""
        self.lblTitle.text = ""
        self.lblCategory.text = ""
        self.lblCanceled.text = cmsCancelledString
        self.lblCanceled.textColor = Colors.redText
        self.lblCanceled.isHidden = true
    }

    private func setupUI() {
        self.cardView.backgroundColor = Colors.blueBackground
        self.cardView.layer.cornerRadius = 12.0
        self.cardView.clipsToBounds = true
        // shadow
        self.shadowView.backgroundColor = Colors.navigationBarTitle
        self.shadowView.layer.shadowColor = Colors.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.shadowView.layer.shadowOpacity = 0.6
        self.shadowView.layer.shadowRadius = 5.0

        self.categoryConainerView.layer.cornerRadius = self.categoryConainerView.frame.size.height / 2
        self.categoryConainerView.backgroundColor = Colors.creamBackground
        self.lblTitle.font = UIFont(name: Fonts.mediumFont, size: Sizes.profileTitle)
        self.lblDetail.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)

        self.lblCanceled.textColor = Colors.redText
        self.lblCanceled.text = cmsCancelledString
        self.lblCanceled.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)

        self.lblCategory.font = UIFont(name: Fonts.regularFont, size: Sizes.headerText)
    }

    private func getTextFromCMS() -> (category: String, tomorrowStr: String, dateTimeStr: String, pluralGuestStr: String, singularGuestStr: String, pluralPassengerStr: String, singularPassengerStr: String, limoOneWaytrip: String) {
        var categoryStr = self.requestCategory ?? ""
        var tomorrowStr = "Tomorrow"
        var dateTimeStr = "[Date] at [Time]"
        var pluralGuestStr = "For [number_of_guests] guests"
        var singularGuestStr = "For 1 guest"
        var pluralPassengerStr = "For [number_of_guests] passengers"
        var singularPassengerStr = "For 1 passenger"
        var limoOneWayTrip = "Limo One-Way Trip"
        if let category = self.requestCategory?.lowercased(), let categoryName = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.item_\(category).elements.text.value") as? String {
            categoryStr = categoryName
        }

        if let tom = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___tomorrow.elements.text.value") as? String {
            tomorrowStr = tom
        }
        if let dateT = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_date.elements.watermark_message.value") as? String {
            dateTimeStr = dateT
        }
        if let pluralGuest = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_guests.elements.watermark_message.value") as? String {
            pluralGuestStr = pluralGuest
        }
        if let singularGuest = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_guests.elements.additional_information.value") as? String {
            singularGuestStr = singularGuest
        }
        if let str = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___status_cancelled.elements.text.value") as? String {
            cmsCancelledString = str
        }
        if let singularPassenger = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_passengers.elements.additional_information.value") as? String {
            singularPassengerStr = singularPassenger
        }
        if let pluralPasenger = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_passengers.elements.watermark_message.value") as? String {
            pluralPassengerStr = pluralPasenger
        }
        if let limoOneWay = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.app___form_limo_title.elements.label.value") as? String {
            limoOneWayTrip = limoOneWay
        }
        return (categoryStr, tomorrowStr, dateTimeStr, pluralGuestStr, singularGuestStr, pluralPassengerStr, singularPassengerStr, limoOneWayTrip)

    }
}


