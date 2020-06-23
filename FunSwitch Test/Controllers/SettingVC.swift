//
//  SettingVC.swift
//  FunSwitch Test
//
//  Created by gaurav on 23/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var blockSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.7)
        blockSwitch.setOn(DefaultsManager.getBlockedStatus(), animated: true)
        timerSwitch.setOn(DefaultsManager.getTimerStatus(), animated: true)
    }


    @IBAction func popBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchHandler(_ sender: UISwitch) {
  
          DefaultsManager.setBlockStatus(value: sender.isOn)
        
        
    }
    
    @IBAction func timeHandler(_ sender: UISwitch) {
        DefaultsManager.setTimerStatus(value: sender.isOn)
        if(sender.isOn){
         blockSwitch.isUserInteractionEnabled = false
         blockSwitch.setOn(false, animated: true)
         DefaultsManager.setBlockStatus(value: false)
        }
        else{
            blockSwitch.isUserInteractionEnabled = true
        }
        
    }
}
