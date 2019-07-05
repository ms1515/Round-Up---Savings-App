//
//  GoalsControllerCollectionViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/29/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class GoalsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NotificationCardViewDelegate {
    
    // MARK:- Initialising Cell Ids
    fileprivate let headerCellId = "headerId"
    fileprivate let goalCellId = "cellId"
    fileprivate let newGoalCellId = "newCellId"
    fileprivate let contentInset: CGFloat = 30
    fileprivate let lineSpacing: CGFloat = 30
    
    var uid: String?
    var roundUpAmount: CGFloat?
    
    // MARK:- Card View Bottom Constraint
    var notificationCardViewBottomConstraint: NSLayoutConstraint?
    
    // MARK:- Buttons and Controls
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleDismiss() {
        dismissGoalsController()
    }

    lazy var transferFundsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TRANSFER FUNDS", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(transferFunds), for: .touchUpInside)
        return button
    }()
    
    lazy var notificationCardView: NotificationCardView = {
       let view = NotificationCardView()
        view.delegate = self
        view.layer.cornerRadius = 16
        return view
    }()
    
    // MARK:- View did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupGradientLayer()
        setupViews()
        setupRefreshControl()
        fetchGoals()
        
        setupNotificationCardViewConstraints()
    }
    
    //MARK:- Setting up Refresh Control
    func setupRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        print("handling refresh")
        self.savingGoalsList.removeAll()
        self.savingGoalsPhoto.removeAll()
        fetchGoals()
        collectionView?.reloadData()
        collectionView?.refreshControl?.endRefreshing()
    }

    //MARK:- Setting up CollectionView and Views Layout
    func setupCollectionView() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: contentInset, bottom: 100+view.safeAreaInsets.bottom, right: contentInset)
        collectionView.register(GoalsHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        collectionView.register(GoalCell.self, forCellWithReuseIdentifier: goalCellId)
        collectionView.register(NewGoalCell.self, forCellWithReuseIdentifier: newGoalCellId)
        
    }
    
    func setupViews() {
        view.addSubview(cancelButton)
        view.addSubview(transferFundsButton)
        
        cancelButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 30, right: 0), size: .init(width: 0, height: 50))
        
        transferFundsButton.anchor(top: nil, leading: cancelButton.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 30, right: 30), size: .init(width: 0, height: 50))
    }
    
    // MARK:- UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! GoalsHeaderCell
        header.roundUpAmount = self.roundUpAmount
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 150)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savingGoalsList.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case savingGoalsList.count:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newGoalCellId, for: indexPath) as! NewGoalCell
            cell.alpha = 0.5
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goalCellId, for: indexPath) as! GoalCell
            cell.savingGoal = savingGoalsList[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.width - 3 * contentInset )/2
        return CGSize(width: width, height: width)
    }
    
    // CollectionView Cells Animations
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
            
        }
    }
    
    var selectedGoal: IndexPath?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case savingGoalsList.count:
            self.selectedCreateNewGoalCell()
        default:
           self.selectedGoalCell(indexPath: indexPath)
            self.selectedGoal = indexPath
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {  [] in

            cell?.transform = .identity
            
        })
        
    }

    // MARK:- GoalCell Delegate Methods
    func selectedGoalCell(indexPath: IndexPath?) {
        
        print("tapped Goal Cell")
        self.transferFundsButton.isEnabled = true
        guard let indexPath = indexPath else {return}
        let transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [] in
            cell?.transform = transform
            
        })
        
    }
    
    func selectedCreateNewGoalCell() {
        
        print("tapped Create New Goal Cell")
        let newGoalController = NewGoalController()
        newGoalController.uid = self.uid
        present(newGoalController, animated: true, completion: nil)
        
    }
    
    
    // MARK:- Retreiving Saving Goals for User
    var savingGoalsList =  [SavingsGoalList]()
    var savingGoalsPhoto = [SavingsGoalPhoto]()
    
    func fetchGoals() {
        
        guard let uid = self.uid else {return}
        Service.shared.fetchUserSavingGoals(uid: uid) { [weak self] (goals, resp, err) in
            
            if let err = err {
                print("Failed to fetch Goals: ", err)
                return
            }
            
            let retreivedGoals = goals?.savingsGoalList ?? []
            
            if retreivedGoals.count > 0 {
            print("Successfully retrieved user saving goals", retreivedGoals)
            self?.savingGoalsList = retreivedGoals
            self?.fetchPhotoForEachGoal()
            DispatchQueue.main.async {
                    self?.collectionView.reloadData()
            }
                
            } else {
                
            print("User has no saving goals")
                
            }
        }
    }
    
    func fetchPhotoForEachGoal() {
        
        self.savingGoalsList.forEach({ (goal) in
            
            guard let uid = self.uid else {return}
            let goalUid = goal.savingsGoalUid

            
             Service.shared.fetchSavingGoalsPhoto(uid: uid, goalUid: goalUid, completion: { [weak self] (base64Photo, resp, err) in
                if let err = err {
                    print("failed to fetch goal photo: ",err)
                    return
                }
                
                guard let goalPhoto = base64Photo else {return}
                self?.savingGoalsPhoto.append(goalPhoto)
                
                
            }) 
            
        })
    }
    
    //MARK:- Transfer funds to a Savings Goal
    
    @objc func transferFunds() {
        
        transferFundsButton.isEnabled = false
        
        guard let uid = self.uid else {return}
        guard let roundUpAmount = self.roundUpAmount else {return}
        let roundUpAmountInUnits = convertPoundsCGFloatToMinorUnitsInt(number: roundUpAmount)
        let transferAmount = Amount(currency: "GBP", minorUnits: roundUpAmountInUnits)
        guard let selectedGoal = self.selectedGoal?.item else {return}
        let goalUid = self.savingGoalsList[selectedGoal].savingsGoalUid
        
        Service.shared.transferFundstoSavingGoal(uid: uid, goalUid: goalUid, amount: transferAmount) { [weak self] (resp, err) in
            
            if let err = err {
                print("Failed to transfer funds: ",err)
                return
            }
            
            guard let resp = resp  else {return}
            
            guard (200 ... 299) ~= resp.statusCode else { // check for http errors
                
                let errorCode = String(resp.statusCode)
                print("Error: Status Code \(errorCode)")
                DispatchQueue.main.async {
                    self?.showNotificationView(success: false, error: errorCode)
                }
                return
        }
            
            print("Successfully transferred Funds: ", roundUpAmountInUnits)
            DispatchQueue.main.async {
                self?.showNotificationView(success: true, error: nil)
            }
        
    }
    }
    
    // MARK:- Notification View Methods
    func setupNotificationCardViewConstraints() {
        
        view.addSubview(notificationCardView)
        notificationCardView.translatesAutoresizingMaskIntoConstraints = false
        notificationCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        notificationCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        notificationCardView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        notificationCardViewBottomConstraint = notificationCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 600)
        notificationCardViewBottomConstraint?.isActive = true
        
    }
    
    
    func showNotificationView(success: Bool, error: String?) {
        
        switch success {
        case true:
            notificationCardView.textLabel.text = "Successfully transferred the Funds"
        case false:
            notificationCardView.textLabel.text = "Unable to transfer the Funds. Status Code \(String(describing: error))"
        }
        
        notificationCardViewBottomConstraint?.constant = -20 - view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func dismissNotificationView() {
        
        notificationCardViewBottomConstraint?.constant = 600
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        dismissGoalsController()
        
    }
    
    func dismissGoalsController() {
        navigationController?.popViewController(animated: true)
    }

    // MARK:- Setting up Background View
    let gradientLayer = CAGradientLayer()
    
    let backgroundView = UIView()
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        gradientLayer.frame = backgroundView.bounds
        
    }
    
    fileprivate func setupGradientLayer() {
        
        collectionView.backgroundView = backgroundView
        
        let topColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        backgroundView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = backgroundView.bounds

    }
    
   init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 

