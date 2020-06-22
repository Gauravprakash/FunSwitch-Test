//
//  UserDefaultsManager.swift
//  Travolution
//
//  Created by Hemant Singh on 04/07/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let tokenKey = "DeviceToken"
    static let baseUrlKey = "BaseURLKey"
    static let cookiesKey = "cookies"
    static let sessionIdKey = "sessionid"
    static let loggedInKey = "IsLoggedIn"
    static let userDataKey = "loginData"
    static let notificationCountKey = "notificationCountKey"
    static let PendingApprovalObjectCount = "PendingApprovalObjectCount"
    static let ApprovalObjectCount = "ApprovalObjectCount"
    static let TotalSavingsKey = "TotalSavings"
    static let defaults = UserDefaults.standard
    static let sharedInstance = DefaultsManager()
    
    var deviceToken: String {
        get{
            return DefaultsManager.defaults.string(forKey: DefaultsManager.tokenKey) ?? "" }
        set{
            DefaultsManager.defaults.set(newValue, forKey: DefaultsManager.tokenKey)
            DefaultsManager.defaults.synchronize()
        }
    }
    
    var notificationCount: Int {
        get{
            return DefaultsManager.defaults.integer(forKey: DefaultsManager.notificationCountKey) 
        }
        set{
            DefaultsManager.defaults.set(newValue, forKey: DefaultsManager.notificationCountKey)
            DefaultsManager.defaults.synchronize()
        }
    }
    var baseUrl: String  {
        get{
            return DefaultsManager.defaults.string(forKey: DefaultsManager.baseUrlKey) ?? Config.baseUrl }
        set{
            if newValue.contains("https://"){
            DefaultsManager.defaults.set(newValue, forKey: DefaultsManager.baseUrlKey)
            }
            else{
               DefaultsManager.defaults.set("https://" + newValue, forKey: DefaultsManager.baseUrlKey)
            }
               DefaultsManager.defaults.synchronize()
        }
    }
    
    var loginData: SWLoginData?
    var repriceData: AirRepriceData?
    
    class func setCookies(value: String){
        DefaultsManager.defaults.set(value, forKey: DefaultsManager.cookiesKey)
        DefaultsManager.defaults.synchronize()
    }
    class func getCookies() -> String {
        return DefaultsManager.defaults.string(forKey: DefaultsManager.cookiesKey) ?? ""
    }
    class func setSessionId(value: String){
        DefaultsManager.defaults.set(value, forKey: DefaultsManager.sessionIdKey)
        DefaultsManager.defaults.synchronize()
    }
    class func getSessionId() -> String {
        return DefaultsManager.defaults.string(forKey: DefaultsManager.sessionIdKey) ?? ""
    }
    class func setUserData(value: SWLoginData){
         let loginData = NSKeyedArchiver.archivedData(withRootObject: value) 
            DefaultsManager.defaults.set(loginData, forKey: userDataKey)
            DefaultsManager.defaults.synchronize()
            DefaultsManager.sharedInstance.loginData = value
    }
    func getUserdata() -> SWLoginData {
        if loginData != nil {
            return  loginData!
        }
        else{
            loginData = NSKeyedUnarchiver.unarchiveObject(with: DefaultsManager.defaults.data(forKey: DefaultsManager.userDataKey)!) as? SWLoginData
            return loginData!
        }
    }
    
     class func setLogged(value:Bool){
        DefaultsManager.defaults.set(value, forKey: loggedInKey)
    }
    
    class func setIsLogged(value: Bool){
        DefaultsManager.defaults.set(value, forKey: loggedInKey)
        DefaultsManager.defaults.synchronize()
    }
    
    class func getIsLoggedIn() -> Bool {
       return DefaultsManager.defaults.bool(forKey: loggedInKey)
    }
    
    class func setPendingApprovalObjectCount(value: Any){
        DefaultsManager.defaults.set(value, forKey: PendingApprovalObjectCount)
        DefaultsManager.defaults.synchronize()
    }
    
    class func setApprovalObjectCount(value: Any){
        DefaultsManager.defaults.set(value, forKey: ApprovalObjectCount)
        DefaultsManager.defaults.synchronize()
    }
    class func setToatalSavings(value: Any){
        DefaultsManager.defaults.set(value, forKey: TotalSavingsKey)
        DefaultsManager.defaults.synchronize()
    }
    class func getToatalSavings() -> Any {
        return DefaultsManager.defaults.value(forKey: TotalSavingsKey) ?? 0
    }
    class func getPendingApprovalObjectCount() -> Any {
        return DefaultsManager.defaults.value(forKey: PendingApprovalObjectCount) ?? 0
    }
    class func getApprovalObjectCount() -> Any {
        return DefaultsManager.defaults.value(forKey: ApprovalObjectCount) ?? 0
    }
    
    
}
