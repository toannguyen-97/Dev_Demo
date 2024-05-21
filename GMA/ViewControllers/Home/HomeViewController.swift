//
//  HomeViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/17/24.
//
import Foundation
import UIKit
import CoreLocation
import ACProgressHUD_Swift

class HomeViewController: BaseViewController {

    var homeCity: ASCity? {
        didSet {
            self.loadData()
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var topView: HomeTopView!
    @IBOutlet private var phoneVerification: HomePhoneVerification!
    @IBOutlet private var upcomingView: HomeUpcomingView!
    @IBOutlet private var cardsView : HomeCardsView!
    @IBOutlet private var specialOfferView: HomeSpecialOfferView!
    @IBOutlet private var topCitiesListView: HomeCityView!
    @IBOutlet private var thingToDoView: HomeThingToDoView!
    @IBOutlet private var suggestionView: HomeSuggestionView!
    @IBOutlet private var trendingView: HomeTrendingView!
    @IBOutlet private var morePicksForYouView: HomeMorePicksForYouView!
    @IBOutlet private var youMightAlsoLikeView: HomeYouMightAlsoLikeView!
    @IBOutlet private var bottomView: HomeBottomView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = Colors.navigationBarTitle
        self.view.backgroundColor = Colors.navigationBarTitle
        // TopView
        self.topView.parrentVC = self
//        self.phoneVerification.parrentVC = self
        
//        upcomingView.parrentVC = self
//        upcomingView.delegate = self
//        topView.parrentVC = self
//        phoneVerification.parrentVC = self
//        cardsView.parrentVC = self
//        cardsView.delegate = self
//        specialOfferView.parrentVC = self
//        specialOfferView.delegate = self
//        topCitiesListView.parrentVC = self
//        topCitiesListView.delegate = self
//        thingToDoView.parrentVC = self
//        suggestionView.parrentVC = self
//        trendingView.parrentVC = self
//        morePicksForYouView.parrentVC = self
//        youMightAlsoLikeView.parrentVC = self
    }
    private func loadData() {
        self.topView.locationCity = self.homeCity
        self.specialOfferView.locationCity = self.homeCity
        self.topCitiesListView.locationCity = self.homeCity
        self.thingToDoView.locationCity = self.homeCity
        self.suggestionView.locationCity = self.homeCity
        self.trendingView.locationCity = self.homeCity
        self.morePicksForYouView.locationCity = self.homeCity
        self.youMightAlsoLikeView.locationCity = self.homeCity
    }
    func chooseLocation() {
        self.gotoLocationSearchScreen { locationCity in
            if CurrentSession.share.citySelected?.name != locationCity.name {
                CurrentSession.share.citySelected = locationCity
                self.homeCity = CurrentSession.share.citySelected
            }
        }
    }

}
extension HomeViewController: HomeUpcomingDelegate, HomeSpecialOfferDelegate, HomeCardsDelegate, HomeTopCityDelegate {
    func upcomingSeeAllRequestDidTapped(upcomingView: HomeUpcomingView) {
        MainTabbarController.shared.switchToRequestScreen()
    }
    
    func upcomingTapOnCard(upcomingView: HomeUpcomingView, requestItem: RequestItem) {
        
    }
    
    func homeSpecialOfferShowMore() {
        CurrentSession.share.categorySelected = offerCategoryName
        MainTabbarController.shared.switchToExploreScreen()
    }
    
    func homeSpecialOfferItemClicked(item: ContentTopic) {
        // show offer detail
        self.openTopicDetail(topicID: item.topicID, contentTopic: item)
    }
    
    func homeCardDidSelected(homeCardView: HomeCardsView) {
        MainTabbarController.shared.switchToExploreScreen()
    }
    
    
    func HomeCityChooseDidSelected() {
       
    }
    
    func HomeCityDidSelectedItem(city: TrendCity) {
        
    }
}

extension HomeViewController: SelectLocationDelegate {
    func locationDidSelected(city: ASCity) {
       
    }
}


extension HomeViewController {
    
    func openTopicDetail(topicID: String, isDining: Bool = false, contentTopic: ContentTopic? = nil) {
        
    }
    
    func selectCategoryAction(categoryItem: CategoryItem) {
       
    }
    
    private func gotoLocationSearchScreen(changeLocationHanler:@escaping (_ locationName:ASCity)-> Void) {
       
    }
    
    // Upcoming
    func getUpcomingReservation() {
       
    }
    
    private func filterRequestWithStatus(items: [RequestItem]) {
       
      
    }
}

