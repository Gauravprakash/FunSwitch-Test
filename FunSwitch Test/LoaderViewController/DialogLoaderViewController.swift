//
//  DialogLoaderViewController.swift
//  FunSwitch Test
//
//  Created by gaurav on 22/06/20.
//  Copyright © 2020 mackbook. All rights reserved.
//


import UIKit

class DialogLoaderViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loderMessage: UILabel!
    var message = ""
    
    override func loadView() {
        Bundle.main.loadNibNamed("DialogLoaderViewController", owner: self, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            // Do any additional setup after loading the view.
        }
    
    override func viewWillDisappear(_ animated: Bool) {
    if animated {view.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
   func displayMessage(message: String = "Loading.."){
      loderMessage.text = message
    }
}
