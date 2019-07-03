//
//  GoalsHeaderCellCollectionViewCell.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/29/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class GoalsHeaderCell: UICollectionReusableView {
    
    var roundUpAmount: CGFloat? {
        didSet{
            
            guard let amount = roundUpAmount else {return}
            let formattedRoundUpAmount = String(format: "%0.2f", amount)
            let attributedText = NSMutableAttributedString(string: "Round Up Amount: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: "£\(formattedRoundUpAmount)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
            roundUpAmountLabel.attributedText = attributedText
            
        }
    }
    
    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "starlingLogo.PNG")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Goals"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    lazy var roundUpAmountLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Round Up Amount: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "£ -", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, roundUpAmountLabel])
        sv.alignment = .center
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        addSubview(horizontalStackView)
        horizontalStackView.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
