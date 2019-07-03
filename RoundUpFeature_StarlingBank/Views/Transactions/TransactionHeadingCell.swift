//
//  TransactionHeaderCell.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/28/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class TransactionHeadingCell: UITableViewCell {
    
    lazy var transactionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Transaction"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var transactionAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount (£)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var roundUpAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Round Up (£)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [transactionTitleLabel, transactionAmountLabel, roundUpAmountLabel])
        sv.alignment = .center
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 25
        return sv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupGradientLayer()
        setupViews()
        
    }
    
    func setupViews() {
        
        addSubview(horizontalStackView)
        horizontalStackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        horizontalStackView.centerInSuperview()
        
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
