//
//  ViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/27/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "starlingLogo.PNG")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Round Up Feature"
        label.font = UIFont(name: "Avenir", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOG IN", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    lazy var refreshTokenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REFRESH TOKEN", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(handleRefreshToken), for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let tf = UILabel()
        tf.textColor = .red
        return tf
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        return ai
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setupGradientLayer()
        setupTapGesture()
        setupViews()
    }

    
    fileprivate func setupViews() {
        
        view.addSubview(logoImageView)
        view.addSubview(appTitleLabel)
        view.addSubview(refreshTokenButton)
        view.addSubview(loginButton)
        view.addSubview(errorLabel)
        view.addSubview(activityIndicator)
        
        logoImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 150, left: 20, bottom: 0, right: 20), size: .init(width: view.frame.width - 40, height: 120))
        appTitleLabel.anchor(top: logoImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 20, bottom: 0, right: 20))
    
       refreshTokenButton.anchor(top: appTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 25, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        
       loginButton.anchor(top: appTitleLabel.bottomAnchor, leading: refreshTokenButton.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        errorLabel.anchor(top: loginButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 20, bottom: 0, right: 20))
        
        activityIndicator.anchor(top: errorLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        activityIndicator.centerXInSuperview()
        
    }
    
    @objc func handleRefreshToken() {
        
        activityIndicator.startAnimating()
        refreshTokenButton.isEnabled = false
        Service.shared.refreshToken { [weak self] (resp, err) in
            
            guard let resp = resp else {return}
            
            guard (200 ... 299) ~= resp.statusCode else { // check for http errors
                print("Status Code: \(resp.statusCode)")
               
            DispatchQueue.main.async {
                self?.errorLabel.text = "Status Code: \(resp.statusCode)"
                self?.activityIndicator.stopAnimating()
                self?.refreshTokenButton.isEnabled = true
            }
                
                return }
            
           print(resp)
        }
    }

    @objc fileprivate func login() {
        
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        Service.shared.fetchUserAccount(completion: { [weak self] (retreivedAccount, resp, err)  in
            
            if let err = err {
                print("Failed to Login User: ",err)
                DispatchQueue.main.async {
                self?.errorLabel.text = "Failed to Login User: \(err)"
                self?.activityIndicator.stopAnimating()
                self?.loginButton.isEnabled = true
                }
                return
            }
            
            print("Successfully Logged in User")
            
            DispatchQueue.main.async {
              self?.performLoginSteps()
            }
      })
    }
    
    func performLoginSteps() {
        self.errorLabel.text = ""
        self.activityIndicator.stopAnimating()
        self.loginButton.isEnabled = true
        let transactionFeedController = TransactionFeedController(style: .grouped)
        self.navigationController?.pushViewController(transactionFeedController, animated: true)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds

    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    

}

