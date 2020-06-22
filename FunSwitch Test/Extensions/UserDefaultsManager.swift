//
//  UserDefaultsManager.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let blockingKey = "BlockingKey"
    static let timerKey = "TimerKey"
    static let defaults = UserDefaults.standard
    static let sharedInstance = DefaultsManager()
    
  class func setBlockStatus(value:Bool){
         DefaultsManager.defaults.set(value, forKey: blockingKey)
     }
     
   class func getBlockedStatus() -> Bool {
        return DefaultsManager.defaults.bool(forKey: blockingKey)
     }
    class func setTimerStatus(value:Bool){
           DefaultsManager.defaults.set(value, forKey: timerKey)
       }
       
     class func getTimerStatus() -> Bool {
          return DefaultsManager.defaults.bool(forKey: timerKey)
       }
}
