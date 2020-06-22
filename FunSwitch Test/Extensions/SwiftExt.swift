//
//  SwiftExt.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


extension UIViewController {
var activityIndicatorTag: Int { return 999999 }
func showLoader(message: String = "Loading...", completion: @escaping (() -> ())){
    DispatchQueue.main.async {

        let loader: DialogLoaderViewController = DialogLoaderViewController()
        loader.providesPresentationContextTransitionStyle = true
        loader.modalPresentationStyle = .overCurrentContext
        self.present(loader, animated: true, completion: {
            completion()
        })
    }
}
func showLoader(message: String = "Loading..."){
    DispatchQueue.main.async {
    let loader: DialogLoaderViewController = DialogLoaderViewController()
    loader.providesPresentationContextTransitionStyle = true
    loader.definesPresentationContext = true
    loader.modalPresentationStyle = .overCurrentContext
    self.present(loader, animated: false, completion: {
            loader.loderMessage.text = message
        })
}
}
func hideLoader(){
    DispatchQueue.main.async {
    self.dismiss(animated: true, completion: nil)
    }
}

func hideLoader(completion: @escaping (() -> ())){
    DispatchQueue.main.async {
        self.dismiss(animated: true, completion: {
            completion()
        })
    }
}
}


extension URL {
     func secured() -> URL {
        if self.scheme == "http", let securedURL = URL(string: self.absoluteString.replacingOccurrences(of: "http:", with: "https:")) {
            return securedURL
        }
        return self
    }
    func isValidYouTube() -> Bool{
        if self.absoluteString.contains("youtube.com") ||  self.absoluteString.contains("youTube.com") || self.absoluteString.contains("YouTube.com"){
            return true
        }
     return false
    }
}

extension String {
    func validateUrl () -> Bool {
            let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
        }
    }

