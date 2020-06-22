//
//  FlightSearchLoaderViewController.swift
//  Travolution
//
//  Created by Navin on 2/11/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class FlightSearchLoaderViewController: UIViewController {
    @IBOutlet weak var flight: UIImageView!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var loadingTitleLabel: UILabel!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var loaderTitle: String = ""
    var message = "Loading..."
    var countdownTimer: Timer!
    var totalTime = 0
    let disposeBag = DisposeBag()
    var completionCallback: ((Response?) -> Void)?
    
    fileprivate func setupUI() {
        loadingTitleLabel.text = loaderTitle
        loadingMessageLabel.text = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.flight.image = #imageLiteral(resourceName: "FlightSearch")
        loadingTitleLabel.text = loaderTitle
        loadingMessageLabel.text = message
        cancelButton.setImage(#imageLiteral(resourceName: "ic_close").tint(with: .white), for: .normal)
        cancelButton.backgroundColor = Theme.accentColor
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidAppear(_ animated: Bool) {
        //setupUI()
       // loadingTitleLabel.text = loaderTitle
        //loadingMessageLabel.text = message
        let diff = self.mapImage.frame.size.width - self.view.frame.size.width
        UIView.animate(withDuration: 12.0, delay: 0, options: [.repeat, .autoreverse,.curveLinear], animations: {
            self.mapImage.center = CGPoint(x:self.mapImage.center.x - diff, y: self.mapImage.center.y)
            self.startTimer()
        }, completion: nil)
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func mainLoad(request: Travolution,title: String = "", message: String = "Loading...", completion:@escaping (Response?) -> Void ){
        self.completionCallback = completion
        self.message = message
        self.loaderTitle = title
        if self.isViewLoaded { setupUI() }
        tryRequest(request: request) { [weak self] (response, authPassed) in
            if authPassed {
                if response?.data != nil {
                    self?.completionCallback?(response)
                }
                else{
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            else{
                self?.tryRMCLogin {
                    self?.tryRequest(request: request, completion: { (response, authPassed) in
                        self?.completionCallback?(response)
                    })
                }
            }
        }
    }
    func tryRequest(request: Travolution, completion: @escaping (Response?, Bool) -> Void){
        TVAPIProvider.rx.request(request).subscribe({ [weak self] event in
            switch event {
            case let .success(response):
                if let json = try? response.mapJSON() {
                    if (json as? [String: Any])?["Description"] as? String == "Authentication Failed" {
                        completion(response, false)
                    }
                    else{
                        completion(response, true)
                    }
                }
            case let .error(err):
                AlertFactory.alert(caller: self, msg: err.localizedDescription)
                completion(nil, true)
            }
        }).disposed(by: disposeBag)
    }
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc  func updateTime() {
        if totalTime == 0  {
            totalTime = 12
            self.flight.transform = CGAffineTransform(scaleX: -1, y:1)
        } else if totalTime == 12   {
            totalTime = 0
            self.flight.transform = CGAffineTransform(scaleX: 1, y:1)
        }
    }
    func tryRMCLogin(completion: @escaping () -> Void){
        TVAPIProvider.rx.request(.LOGIN(RMCLoginRequest().toDictionary())).subscribe({ event in
            switch event {
            case let .success(response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                if let dictionary = (json as? [String: Any])?["Data"] as? [String:Any]{
                    let loginData = SWLoginData(fromDictionary: dictionary)
                    if loginData.user != nil {
                        DefaultsManager.setUserData(value: loginData)
                        DefaultsManager.setIsLogged(value: true)
                    }
                    completion()
                }
                else {
                    presentLoginScreen()
                }
            case let .error(err):
                presentLoginScreen()
            }
        }).disposed(by: disposeBag)
        
        func presentLoginScreen() {
            DefaultsManager.setIsLogged(value: false)
            self.dismiss(animated: true) {
                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDel.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
        }
    }
    
    @IBAction func cancel_Action(_ sender: Any) {
        completionCallback = nil
        self.dismiss(animated: true, completion: nil)
    }
    deinit {
        print(self.description + " deinitialized")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
