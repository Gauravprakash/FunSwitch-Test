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
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "ic_more_vert_white")?.withTintColor(.white), style: .plain, target: self, action: #selector(navigateToResult(button:)))
        self.navigationItem.rightBarButtonItem = rightItem
    
    }
    
    @objc func navigateToResult(button: UIBarButtonItem){
       
    }

    @IBAction func hitUrl(_ sender: UIButton) {
         let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC{
        vc.str = textField.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
