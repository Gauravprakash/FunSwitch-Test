//
//  ResultVC.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import UIKit
import WebKit
import UserNotifications

class ResultVC: UIViewController{
@IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var midView: UIView!
    
    var str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: str), url.isValidYouTube(), DefaultsManager.getBlockedStatus(), !DefaultsManager.getTimerStatus(){
                   midView.isHidden = false
                   webView.isHidden = true
                 }
               
               else{
                     midView.isHidden = true
                     webView.isHidden = false
                     setUpView()
               if let url = URL(string: str), url.isValidYouTube(){
                 setUpNotificationContent()
            }
                    
            }
          }
    
    func setUpNotificationContent(){
        let content = UNMutableNotificationContent()
        content.title = "YouTube starts"
        content.subtitle = "It is running"
        content.sound = UNNotificationSound.default

        // show this notification one seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification(){
    let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    func setUpView(){
        if let url = URL(string: str){
            self.webView.navigationDelegate = self
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 1.0)
            request.httpShouldHandleCookies = true
            request.cachePolicy = .reloadIgnoringLocalCacheData
            self.webView.load(request)
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ResultVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.request.url?.isValidYouTube() ?? true && DefaultsManager.getBlockedStatus() && !DefaultsManager.getTimerStatus()){
            webView.isHidden = true
            midView.isHidden = false
            decisionHandler(.cancel)
           
        }
        else{
             midView.isHidden = true
             webView.isHidden = false
             self.showLoader()
             decisionHandler(.allow)
        }
        
        }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
}

extension ResultVC: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
