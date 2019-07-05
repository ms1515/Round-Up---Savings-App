//
//  NewGoalController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

extension NewGoalController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.selectPhotoButton.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        
    }
    
}

class NewGoalController: UIViewController, NotificationCardViewDelegate {
    
    var uid: String?
    
    // MARK:- Card View Bottom Constraint
    var notificationCardViewBottomConstraint: NSLayoutConstraint?
    
    //MARK:- Buttons and Controls
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Choose Photo", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\nFor Goal", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: .heavy), NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.alpha = 0.5
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    let goalNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Saving Goals Name"
        tf.backgroundColor = .white
        tf.alpha = 0.5
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.cornerRadius = 10
        tf.autocorrectionType = .yes
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.clipsToBounds = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let goalTargetLabel = UILabel(text: "Target: £", font: UIFont.boldSystemFont(ofSize: 20), numberOfLines: 1)
    
    let goalTargetTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Amount"
        tf.backgroundColor = .white
        tf.alpha = 0.5
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.cornerRadius = 10
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.clipsToBounds = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var horizantalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [goalTargetLabel, goalTargetTextField])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 16
        return sv
    }()
    
    lazy var errorLabel: UILabel = {
        let tf = UILabel()
        tf.textColor = .red
        return tf
    }()

    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var createGoalButton: UIButton = {
        let button = UIButton(frame: .init(x: view.frame.width - 190, y: view.frame.height - 80, width: 170, height: 50))
        button.setTitle("CREATE GOAL", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 15
        button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleCreateGoal), for: .touchUpInside)
        return button
    }()
    
    lazy var notificationCardView: NotificationCardView = {
        let view = NotificationCardView()
        view.delegate = self
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalTargetTextField.delegate = self
        setupGradientLayer()
        setupViews()
        setupNotificationObservers()
        setupTapGesture()
        setupNotificationCardViewConstraints()
        
    }
    
    // MARK:- Setting Up Views
    func setupViews() {
        
        view.addSubview(selectPhotoButton)
        view.addSubview(goalNameTextField)
        view.addSubview(horizantalStackView)
        view.addSubview(dismissButton)
        view.addSubview(createGoalButton)
        view.addSubview(errorLabel)
        
        let width = view.frame.width - 60
        selectPhotoButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 30, bottom: 0, right: 30), size: .init(width: width, height: width))
        
        goalNameTextField.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 50))
        
        horizantalStackView.anchor(top: goalNameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 50))
        
        errorLabel.anchor(top: horizantalStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 50))
        
        dismissButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 30, right: 0), size: .init(width: 0, height: 50))

        createGoalButton.anchor(top: nil, leading: dismissButton.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 30, right: 30), size: .init(width: 0, height: 50))
       
    }
    
    //MARK:- @objc methods
    @objc func handleSelectPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
        
    }
    
    
    @objc func handleTextInputChange() {
        
        let isFormValid =  goalNameTextField.text?.count ?? 0 > 0 && goalTargetTextField.text?.count ?? 0 > 0 &&  ((selectPhotoButton.imageView?.image ?? nil) != nil)
        
        if isFormValid {
            createGoalButton.isEnabled = true
        } else {
            createGoalButton.isEnabled = false
        }
    }
    
    
    @objc func handleDismiss() {
        dismissNewGoalsController()
    }
    
    // MARK:- Creating a New Goal Method
    @objc func handleCreateGoal() {
        
        print("attempting to create Goal")
        createGoalButton.isEnabled = false
        
        guard let uid = self.uid else {return}
        guard let name = goalNameTextField.text else {return}
        guard let targetAmount = goalTargetTextField.text else {return}
        let targetAmountInUnits = convertPoundsStringToMinorUnitsInt(numberInString: targetAmount)
        let target = Target(currency: "GBP", minorUnits: targetAmountInUnits)
        guard let image = selectPhotoButton.imageView?.image else {return}
        let base64photo = convertImageToBase64(image: image)
        
        let newGoal = NewGoal(name: name, currency: "GBP", target: target, base64EncodedPhoto: base64photo)
        
        print("target amount in minor units:", targetAmountInUnits)
        //print(base64photo)
        Service.shared.createNewSavingGoal(uid: uid, newGoal: newGoal) { [weak self] (resp, err) in
            
            if let err = err {
                print("Error: \(err)")
            }
           
            guard let resp = resp  else {return}
            
            guard (200 ... 299) ~= resp.statusCode else {  // check for http errors
                print("HTTP Error: Status Code \(resp.statusCode)")
                
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Error: Status Code \(resp.statusCode)"
                    self?.createGoalButton.isEnabled = true
                }
                return }
            
            print("successfully created goal. Status Code",resp.statusCode)
            
            DispatchQueue.main.async {
               self?.showNotificationView()
               self?.createGoalButton.isEnabled = true
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
    
    
    func showNotificationView() {
        
        notificationCardView.textLabel.text = "Successfully created new Goal"
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
        self.view.endEditing(true)
        dismissNewGoalsController()
        
    }
    
    func dismissNewGoalsController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Setting up Background View
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
        
    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
        
    }
    
    // Mark:- Keyboard management Methods
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let difference = keyboardFrame.height
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
