//
//  ApprovalController.swift
//  Zillious
//
//  Created by Gaurav Prakash on 20/08/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import UIKit

enum ApprovalCase{
    case CartApproval(actionState:TripActionState)
    case QueryApproval(requsitionAction:String)
}

class ApprovalController: UIViewController {
   @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtQuery: UILabel!
    @IBOutlet weak var txtReason: TVTextField!
    @IBOutlet weak var lineView: UIView!
    var approvalCase: ApprovalCase!
    var actionState:TripActionState!
    var callback:((String) -> ())! = {_ in
    }
    @IBOutlet weak var confirmAction: UIButton!
    @IBOutlet weak var cancelAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.cancelAction.setImage(#imageLiteral(resourceName: "ic_close").tint(with: .white), for: .normal)
        self.lineView.backgroundColor = Theme.primaryColor
        setUpView()
    }
    
    func setUpView(){
        self.headerView.backgroundColor = UIColor(rgb:0xEF6C00)
        switch approvalCase!{
        case .CartApproval(let data):
        switch data {
            case .DECLINEALL:
                self.txtQuery.text = "Are you sure you want to Decline the Trip?"
                self.txtReason.placeholder = "Reason to decline"
                self.txtReason.detailLabel.isHidden = false
                self.txtReason.detailLabel.text = "required"
            
            default:
                self.txtQuery.text = "Do you want to cancel the trip?"
            }
        case .QueryApproval(let action):
            switch action{
            case "H":
                self.txtQuery.text = "Are you sure you want to Approve the Query?"
                self.txtReason.placeholder = "Buffer Amount"
                self.txtReason.keyboardType = .numberPad
                self.txtReason.detailLabel.isHidden = true
                self.txtReason.detailLabel.text = ""
             
            case "J":
                self.txtQuery.text = "Are you sure you want to Decline the Query?"
                self.txtReason.placeholder = "Enter Reason for decline"
                self.txtReason.detailLabel.isHidden = false
                self.txtReason.keyboardType = .default
                self.txtReason.detailLabel.text = "required"
                
            default:
                self.txtQuery.text = "Are you sure you want to cancel the Query?"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if animated {view.backgroundColor = UIColor.clear.withAlphaComponent(0.0)
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        switch approvalCase!{
        case .CartApproval(let data):
            switch data{
            case .APPROVEALL:
                 break
                case .DECLINEALL:
                if let txt = self.txtReason.text, !txt.isEmpty{
                    self.dismiss(animated: true) {
                        self.callback(txt)
                    }
                }
                else{
                    self.view.makeToast("please enter a reason")
                }
           default:
            break
            }
        default:
        if let txt = self.txtReason.text, !txt.isEmpty{
            self.dismiss(animated: true) {
                self.callback(txt)
            }
        }
        else{
            self.view.makeToast("please enter a reason")
        }
    }
}
}

