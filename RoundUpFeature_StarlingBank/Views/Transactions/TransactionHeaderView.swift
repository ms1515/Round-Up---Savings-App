//
//  TransactionHeaderViewCollectionViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/27/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func didTapSaveToGoals()
    func didTapLogout()
}

class TransactionHeaderView: UITableViewHeaderFooterView {
    
    var delegate: HeaderViewDelegate?
    
    var userDetails: UserDetails? {
        didSet {
            guard let uid = userDetails?.accountUid else {return}
            let attributedText = NSMutableAttributedString(string: "Uid: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: uid, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
            uidLabel.attributedText = attributedText
        }
    }
    
    var accountDetails: AccountDetails? {
        didSet {
            
            guard let accountNumber = accountDetails?.accountIdentifier else {return}
            let attributedText = NSMutableAttributedString(string: "Account No: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: accountNumber, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
            accountNumberLabel.attributedText = attributedText
            
        }
    }
    
    var accountBalance: Amount? {
        didSet {
            guard let balanceInUnits = accountBalance?.minorUnits else {return}
            let balanceInPounds = convertMinorUnitsIntToPoundsCGFloat(number: balanceInUnits)
            let attributedText = NSMutableAttributedString(string: "Balance: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: "£\(balanceInPounds)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
            balanceLabel.attributedText = attributedText

        }
    }
    
    var roundUpAmount: CGFloat? {
        didSet{
            guard let amount = roundUpAmount else {return}
            let formattedRoundUpAmount = String(format: "%0.2f", amount)
            let attributedText = NSMutableAttributedString(string: "Total Round Up: ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: "£\(formattedRoundUpAmount)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .heavy), NSAttributedString.Key.foregroundColor: UIColor.white]))
            roundUpAmountLabel.attributedText = attributedText
        }
    }
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.alpha = 0.5
        return button
    }()
    
    @objc func handleLogout() {
        print(123)
        delegate?.didTapLogout()
    }
    
    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "starlingLogo.PNG")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var uidLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Uid: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    lazy var accountNumberLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Account No: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Balance: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var horizantalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [accountNumberLabel, balanceLabel])
        sv.alignment = .center
        sv.axis = .horizontal
        sv.spacing = 20
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [uidLabel, horizantalStackView])
    
    let roundUpAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Round Up: "
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var saveToGoalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE TO GOALS", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleRoundUp), for: .touchUpInside)
        return button
    }()

    @objc func handleRoundUp() {
        delegate?.didTapSaveToGoals()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        setupViews()
    }
    
    func setupViews() {
        
        overallStackView.axis = .vertical
        overallStackView.distribution = .fillEqually
        overallStackView.alignment = .center
        
        addSubview(logoutButton)
        addSubview(logoImageView)
        addSubview(horizantalStackView)
        addSubview(roundUpAmountLabel)
        addSubview(saveToGoalButton)
        
       logoutButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 25), size: .init(width: 40, height: 40))
        
       logoImageView.anchor(top: nil, leading: nil, bottom: horizantalStackView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: frame.width, height: 60))
        logoImageView.centerXInSuperview()
        
        horizantalStackView.anchor(top: nil, leading: nil, bottom: roundUpAmountLabel.topAnchor, trailing: nil, padding: .zero, size: .init(width: frame.width, height: 30))
        horizantalStackView.centerXInSuperview()
        
        roundUpAmountLabel.anchor(top: nil, leading: leadingAnchor, bottom: saveToGoalButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 15, right: 0), size: .init(width: 0, height: 30))
        roundUpAmountLabel.centerXInSuperview()
        
        saveToGoalButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 190, height: 50))
        saveToGoalButton.centerXInSuperview()
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
