//
//  ResultVC.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import UIKit
import WebKit

class ResultVC: UIViewController {
@IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var midView: UIView!
    
    var str = "https://www.google.com/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(str.validateUrl()){
            
        }
        
//        if str.validateURL(urlString: str) && str.isYouTubeUrl(urlString: str){
//          midView.isHidden = true
//          setUpView()
//        }
//        else{
//            midView.isHidden = false
//        }
        
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
        self.showLoader()
   
          decisionHandler(.allow)
        }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
}



