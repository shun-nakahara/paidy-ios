//
//  StartViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import QuartzCore

class StartViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var startEmailText: UITextField!
    @IBOutlet var startPhoneText: UITextField!    
    @IBOutlet var agreementText: UIButton!
    @IBOutlet var startAgreementButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var layoutNextButton: NSLayoutConstraint!
    @IBOutlet weak var startViewHorizontal: NSLayoutConstraint!

    var authRequest: AuthRequest!
    var checkBoxSelected: Bool = false
    
    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "StartViewController", bundle: frameworkBundle)
    }
    
    // required init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        
        // set icons on textFields
        let envelope = UIImage(named: "pd_icon_envelope.png", inBundle: frameworkBundle,
            compatibleWithTraitCollection: nil)
        var envelopeView = UIImageView(frame: CGRectMake(0, 0, envelope!.size.width + 10, envelope!.size.height))
        envelopeView.image = envelope
        envelopeView.contentMode = UIViewContentMode.Center
        startEmailText.leftView = envelopeView
        startEmailText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        startEmailText.leftViewMode = UITextFieldViewMode.Always
        
        let phone = UIImage(named: "pd_icon_phone.png", inBundle: frameworkBundle,
            compatibleWithTraitCollection: nil)
        var phoneView = UIImageView(frame: CGRectMake(0, 0, phone!.size.width + 10, phone!.size.height))
        phoneView.image = phone
        phoneView.contentMode = UIViewContentMode.Center
        startPhoneText.leftView = phoneView
        startPhoneText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        startPhoneText.leftViewMode = UITextFieldViewMode.Always
        
        // get authRequest from parent
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        authRequest = paidyCheckoutViewController.authRequest
        
        //set textfield to normal
        TextViewStates.setNormal(startEmailText)
        TextViewStates.setNormal(startPhoneText)

        // set email and phone text with existing data
        if (authRequest.buyer.email != nil){
            startEmailText.text = authRequest.buyer.email.address
        }
        
        if (authRequest.buyer.phone != nil){
            startPhoneText.text = authRequest.buyer.phone.number
        }
        
        // set button style
        nextButton.layer.cornerRadius = 5
        nextButton.layer.masksToBounds = true
        
    }

    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        /*view.alpha = 0
        startViewHorizontal.constant += view.bounds.width*/
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*UIView.animateWithDuration(0.25,  animations: {
            self.view.alpha = 1.0
            self.startViewHorizontal.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        })*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // next button selected
    @IBAction func startNextButton(sender: UIButton) {
        if (validate()) {
            authRequest.buyer.email.address = startEmailText.text
            authRequest.buyer.phone.number = startPhoneText.text
            updateAuth();
        }
    }
    
    // agreement link selected
    @IBAction func agreementLink(sender: UIButton) {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.setupSubView("terms_oneshot")
    }
    
    // validate input and show error if invalid
    func validate() -> Bool {
        var emailValid: Bool = InputValidation.isValidEmail(startEmailText.text)
        var phoneValid:Bool = InputValidation.isValidPhone(startPhoneText.text)
        var checkBoxValid: Bool = checkBoxSelected
        
        if (emailValid){
            TextViewStates.setNormal(startEmailText)
        } else {
            TextViewStates.setError(startEmailText)
        }
        
        if (phoneValid){
            TextViewStates.setNormal(startPhoneText)
        } else {
            TextViewStates.setError(startPhoneText)
        }
        
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        if (checkBoxValid) {
            let normalCheck = UIImage(named: "pd_checkbox_checked.png", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            startAgreementButton.setImage(normalCheck, forState: UIControlState.Selected)
        } else {
            let errorCheck = UIImage(named: "pd_checkbox_error.png", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            startAgreementButton.setImage(errorCheck, forState: UIControlState.Normal)
        }
        
        return emailValid && phoneValid && checkBoxValid
    }
    
    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.doAuthorization()
    }

    // checkBox selection
    @IBAction func startAgreementCheck(sender: UIButton) {
        if (checkBoxSelected){
            startAgreementButton.selected = false
            checkBoxSelected = false
        } else {
            startAgreementButton.selected = true
            checkBoxSelected = true
        }
    }

    // MARK: - TextField Delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == startEmailText) {
            startEmailText.resignFirstResponder()
            startPhoneText.becomeFirstResponder()
        } else if (textField == startPhoneText) {
            startPhoneText.resignFirstResponder()
        }
        return true
    }
    
    // dismiss keyboard on tap of background
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}
