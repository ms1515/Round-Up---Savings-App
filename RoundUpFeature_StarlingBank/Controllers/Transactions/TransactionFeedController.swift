//
//  TransactionFeedController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/27/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class TransactionFeedController: UITableViewController, HeaderViewDelegate {
    
    // MARK:- Cell Ids
    fileprivate let headerViewId = "headerViewId"
    fileprivate let headerCellId = "headerCellId"
    fileprivate let cellId = "cellId"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupGradientLayer()
        setupRefreshControl()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fetchCurrentUser()
        }
        
    }
    
    func setupRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        print("handling refresh")
        
        fetchCurrentUser()
        tableView?.reloadData()
        tableView?.refreshControl?.endRefreshing()
    }
    
    // MARK:- Setup TableView
    fileprivate func setupTableView() {
        
        tableView.separatorStyle = .none
        tableView.register(TransactionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewId)
        tableView.register(TransactionHeadingCell.self, forCellReuseIdentifier: headerCellId)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    // MARK:- TableView DataSource
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewId) as? TransactionHeaderView
        header?.delegate = self
        if self.userDetails.count > 0 {
            header?.userDetails = self.userDetails[0]
        }
        header?.accountDetails = self.accountDetails
        header?.accountBalance = self.accountBalance
        header?.roundUpAmount = self.roundUpAmount
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TransactionCell
            // Accounting for extra heading cell
            if self.feedItems.count > 0 { 
                cell.feedItem = self.feedItems[indexPath.item-1]
            }
            return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK:- Account and Transaction Variables
    var userDetails =  [UserDetails]()
    var accountDetails: AccountDetails?
    var accountBalance: Amount?
    var feedItems = [FeedItem]()
    var roundUpAmount: CGFloat?
    
    // MARK: - Retreive Current User Account and Transactions
    fileprivate func fetchCurrentUser() {
        Service.shared.fetchUserAccount(completion: { [weak self] (retreivedAccount, resp, err)  in
            
            if let err = err {
                print("Failed to fetch User: ",err)
                return
            }
            
            print("Successfully retrieved user")
            self?.userDetails = retreivedAccount?.accounts ?? []
            
            guard let uid = self?.userDetails[0].accountUid else {return}
            self?.fetchCurrentUserAccountDetails(uid: uid)
            self?.fetchCurrentUserBalance(uid: uid)
            self?.fetchCurrentUserTransactions(uid: uid)
            
        })
        
    }
    
    func fetchCurrentUserAccountDetails(uid: String?) {
        guard let uid = uid else {return}
        Service.shared.fetchUserAccountDetails(uid: uid) { [weak self] (accountDetails, resp, err) in
            if let err = err {
                print("Failed to fetch account details: ",err)
                return
            }
            
            print("Successfully retrieved user account details")
            self?.accountDetails = accountDetails
            
        }
        
    }
    
    func fetchCurrentUserBalance(uid: String?) {
        guard let uid = uid else {return}
        Service.shared.fetchUserAccountBalance(uid: uid) { [weak self] (balance, resp, err) in
            
            if let err = err {
                print("Failed to retrieve user account Balance: ",err )
                return
            }
            print("Successfully retrieved user account Balance")
            self?.accountBalance = balance?.availableToSpend
            
            
        }
    }
    
    func fetchCurrentUserTransactions(uid: String?) {
        guard let uid = uid else {return}
        Service.shared.fetchUserTransactions(uid: uid) { [weak self] (transactions, resp, err) in
            
            if let err = err {
                print(err)
            }
            
            print("Successfully retrieved user transactions")
            self?.feedItems = transactions?.feedItems ?? []
            self?.calculateRoundUp()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                }
        }
    }
    
    // MARK:- Calculate total round up amount for all User payment Transactions
    func calculateRoundUp() {
        
        var roundUpSum: CGFloat = 0
        let feedItems = self.feedItems
        if feedItems.count > 0 {
            self.feedItems.forEach { (feedItem) in
            guard let paymentDirection = feedItem.direction else {return}
                
                switch paymentDirection {
                case "OUT":
                    
                    let transactionAmountInUnits = feedItem.amount.minorUnits
                    let roundUpAmount = calculateRoundUpForTransaction(number: transactionAmountInUnits)
                    roundUpSum += roundUpAmount
            
                default:
                    return
            }
        }
    }
        let formatted = String(format: "£%0.2f", roundUpSum)
        print("Total Round Up Amount: ",formatted)
        self.roundUpAmount = roundUpSum
    }
    
    //MARK:- HeaderView Delegate Methods
    func didTapSaveToGoals() {
        
        print("Saving Round Up Amount to Goals")
        let goalsController = GoalsController()
        if self.userDetails.count > 0 {
        let uid = self.userDetails[0].accountUid
        goalsController.uid = uid
        goalsController.roundUpAmount = self.roundUpAmount
        navigationController?.pushViewController(goalsController, animated: true)
        }
        
    }
    
    func didTapLogout() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK:- Setting up Background View
    let gradientLayer = CAGradientLayer()
    
    let backgroundView = UIView()
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        gradientLayer.frame = backgroundView.bounds
        
    }
    
    fileprivate func setupGradientLayer() {
        
        tableView.backgroundView = backgroundView
        
        let topColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        backgroundView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = backgroundView.bounds
        
    }
    
}
