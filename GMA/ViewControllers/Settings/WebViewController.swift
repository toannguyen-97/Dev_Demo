//
//  WebViewController.swift
//  GMA
//
//  Created by toan.nguyenq on 5/16/24.
//

import Foundation
import UIKit
import WebKit
import ACProgressHUD_Swift

class WebViewController: BaseViewController, WKNavigationDelegate{
    
    private var webView: WKWebView!
    private var contentType: contentType!
    private var registrationFlow: Bool!
    var scrollToContactUs = false

    convenience init(type: contentType, forRregistrationFlow: Bool){
        self.init()
        self.contentType = type
        self.registrationFlow = forRregistrationFlow
    }
    
    func getContentType()->contentType {
        return self.contentType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if registrationFlow{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.blueBackground]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if registrationFlow{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationBarTitle]
        }
    }
   
    override func viewDidLoad() {
        ACProgressHUD.shared.showHUD()
        self.kenticoCodeName = contentType.codeName
        super.viewDidLoad()
        view.backgroundColor = Colors.navigationBarTitle
    }
    
    override func setupUI() {
        super.setupUI()
        createBlueBackBarButton()
        webView = {
            let view = WKWebView()
            view.navigationDelegate = self
            return view
        }()
        view.addSubview(webView)
        webView.setupConstraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, withPadding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    override func loadCMSTextFinish() {
        ACProgressHUD.shared.hideHUD()
    }
    
    override func setText() {
        super.setText()
        if let description =  KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.\(contentType.path).elements.description.value") as? String {
            DispatchQueue.main.async { [weak self] in
                if let self = self{
                    self.webView.loadHTMLString(description, baseURL: nil)
                }
            }
        }
        if let title = KenticoServices.getKenticoValue(dict: self.kenticoDic, path: "modular_content.\(contentType.path).elements.title.value") as? String{
            self.title = title
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.scrollToContactUs {
            webView.evaluateJavaScript("document.getElementById('contact-us').scrollIntoView(true);")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let urlStr = navigationAction.request.url?.absoluteString, urlStr.contains("mailto:") {
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}
