//
//  ViewController.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let rightItem = UIBarButtonItem(image: UIImage(named: "ic_more_vert_white")?.withTintColor(.white), style: .plain, target: self, action: #selector(openSetting(button:)))
        self.navigationItem.rightBarButtonItem = rightItem
    
    }
    
    @objc func openSetting(button: UIBarButtonItem){
       let setting: SettingVC = SettingVC()
                  setting.providesPresentationContextTransitionStyle = true
                  setting.modalPresentationStyle = .overCurrentContext
                  self.present(setting, animated: true, completion: nil)
    }

    @IBAction func hitUrl(_ sender: UIButton) {
        if(textField.text?.validateUrl() ?? false && !(textField.text?.isEmpty ?? true)){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC{
        vc.str = textField.text ?? ""
        textField.text = ""
        self.navigationController?.pushViewController(vc, animated: true)
        }
        }
        else{
             self.view.makeToast("Not a valid url")
        }
    
}
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
