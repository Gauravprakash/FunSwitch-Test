//
//  LoaderViewController.swift
//  Travolution
//
//  Created by Hemant Singh on 28/07/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class LoaderViewController: UIViewController {
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingTitleLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    let disposeBag = DisposeBag()
    var message = "Loading..."
    var loaderTitle: String = ""
    var image: UIImage?
    var completionCallback: ((Response?) -> Void)?
    
    fileprivate func setupUI() {
        loadingTitleLabel.text = loaderTitle
        loadingMessageLabel.text = message
        loadingImageView.image = image
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = Theme.Colors.loaderBackgroundColor
        loadingMessageLabel.textColor = Theme.primaryColor
        loadingTitleLabel.textColor = Theme.primaryColorDark
        cancelButton.setImage(#imageLiteral(resourceName: "ic_close").tint(with: .white), for: .normal)
        backGroundImageView.image = Images.loaderBackImage
        cancelButton.backgroundColor = Theme.accentColor
    }
     override func viewDidAppear(_ animated: Bool) {
        setupUI()
        let progressView = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 80)))
        progressView.center = self.view.center
        self.view.addSubview(progressView)
    }
    
    func mainLoad(request: Travolution,title: String = "", message: String = "Loading...", image: UIImage = #imageLiteral(resourceName: "ic_schedule"), bgColor: UIColor = Theme.Colors.loaderBackgroundColor, completion:@escaping (Response?) -> Void ){
        self.view.backgroundColor = bgColor
        self.loadingTitleLabel.textColor = Theme.Colors.loaderMessageColor
        self.loadingMessageLabel.textColor = Theme.Colors.loaderMessageColor
        self.completionCallback = completion
        self.message = message
        self.loaderTitle = title
        self.image = image.tint(with: Theme.Colors.loaderImageColor)
        if self.isViewLoaded { setupUI() }
        tryRequest(request: request) { [weak self] (response, authPassed) in
            if authPassed {
                if response?.data != nil {
                self?.dismiss(animated: true, completion: {
                self?.completionCallback?(response)
                })
                }
                else{
                    self?.dismiss(animated: true, completion: nil)
                  }
              }
            else{
                self?.tryRMCLogin {
                    self?.tryRequest(request: request, completion: { (response, authPassed) in
                        self?.dismiss(animated: true, completion: {
                        self?.completionCallback?(response) })
                    })
                }
            }
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        completionCallback = nil
        self.dismiss(animated: true, completion: nil)
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
                else{
                     completion(nil, true)
                }
            case let .error(err):
                AlertFactory.alert(caller: self, msg: err.localizedDescription)
                completion(nil, true)
            }
    }).disposed(by: disposeBag)
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
    
    deinit {
        print(self.description + " deinitialized")
    }
}

class BaseLoaderView:UIViewController,LoaderStuff{
    
func setUpUI(loaderTitle: String, loaderMessageLabel: String, loaderImage: UIImage) {
        
}
    
func mainLoad(request: Travolution, title: String, message: String, image: UIImage, bgColor: UIColor, completion: @escaping (Response?) -> Void) {
    self.view.backgroundColor = bgColor
    if self.isViewLoaded{
        
     }
    
}
}

protocol LoaderStuff {
func mainLoad(request: Travolution,title: String, message: String, image: UIImage, bgColor: UIColor, completion:@escaping (Response?) -> Void)
func setUpUI(loaderTitle:String, loaderMessageLabel:String, loaderImage:UIImage)
}
