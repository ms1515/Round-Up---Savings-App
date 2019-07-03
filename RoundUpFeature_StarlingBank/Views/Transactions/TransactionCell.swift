//
//  TransactionCell.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/28/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    var feedItem: FeedItem? {
        didSet {
            
            guard let transactionSource = feedItem?.source else {return}
            guard let spendingCategory = feedItem?.spendingCategory else {return}
            guard let transactionAmountInUnits = feedItem?.amount.minorUnits else {return}
            let transactionAmountInPounds = convertMinorUnitsIntToPoundsCGFloat(number: transactionAmountInUnits)
            let formattedTransactionAmountInPounds = String(format: "%0.2f", transactionAmountInPounds)
            
            let titleAttributedText = NSMutableAttributedString(string: "\(spendingCategory):\(transactionSource)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            transactionTitleLabel.attributedText = titleAttributedText
            
            guard let paymentDirection = feedItem?.direction else {return}
            
            switch paymentDirection {
            case "OUT":
                 let amountAttributedText = NSMutableAttributedString(string: "-£\(formattedTransactionAmountInPounds)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
                transactionAmountLabel.attributedText = amountAttributedText
                let roundUpAmount = CGFloat(Int(transactionAmountInPounds)) + 1 - transactionAmountInPounds
                let formatted = String(format: "£%0.2f", roundUpAmount)
                roundUpAmountLabel.text = formatted
            default:
                 let amountAttributedText = NSMutableAttributedString(string: "£\(transactionAmountInPounds)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
                transactionAmountLabel.attributedText = amountAttributedText
                roundUpAmountLabel.text = "£ - "
            }
        }
    }
    
    lazy var transactionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var transactionAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    lazy var roundUpAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "£ - "
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [transactionTitleLabel, transactionAmountLabel, roundUpAmountLabel])
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 16
       return sv
    }()
    
    let dividerLineView: UIView  = {
        let dv = UIView()
        dv.backgroundColor = .white
        dv.alpha = 0.5
        return dv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        
    }
    
    func setupViews() {
        
        addSubview(horizontalStackView)
        addSubview(dividerLineView)
        horizontalStackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        horizontalStackView.centerInSuperview()
        
        dividerLineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .zero, size: .init(width: 0, height: 0.5))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
