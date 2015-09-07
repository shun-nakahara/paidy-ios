//
//  AuthViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

// MARK: - AuthViewController

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var pin1: UITextField!
    @IBOutlet var pin2: UITextField!
    @IBOutlet var pin3: UITextField!
    @IBOutlet var pin4: UITextField!
    
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var errorText: UILabel!
    @IBOutlet var phoneView: UIView!
    
    var authRequest: AuthRequest!
    var authCode:String = ""
    
    // custom init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "AuthViewController", bundle: frameworkBundle)
    }
    
    // required init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set error text
        setError(false, text: "認証コードを送信しました。")
        
        // get authRequest from parent
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        authRequest = paidyCheckoutViewController.authRequest
        
        // set phone number with existing data
        if (authRequest.buyer.phone != nil){
            phoneNumber.text = authRequest.buyer.phone.number
        }
        
        // display keyboard for first textview
        pin1.becomeFirstResponder()
        
        setPhoneBackground()
        
        // pinField style
        pin1.textAlignment = .Center
        pin2.textAlignment = .Center
        pin3.textAlignment = .Center
        pin4.textAlignment = .Center

    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // set error text based on response
    func setError(error: Bool, text: String) {
        errorText.text = text

        if (error) {
            errorText.textColor = UIColor(netHex:0xF2506F)
            authCode = ""
            pin1.text = ""
            pin2.text = ""
            pin3.text = ""
            pin4.text = ""
            pin1.becomeFirstResponder()
            
            authRequest.auth_code = nil
            
        }  else {
            errorText.textColor = UIColor(netHex:0x777777)
        }
    }
    
    // request new pin code sms
    @IBAction func authResendButton(sender: UIButton) {
        // set authCode to nil and doAuth
        authRequest.auth_code = nil
        updateAuth()
    }
    
    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.doAuthorization()
    }
    
    // configure header background
    func setPhoneBackground(){
        // set border
        phoneView.layer.borderWidth = 1.0
        phoneView.layer.backgroundColor = UIColor(netHex:0xFFFFFF).CGColor
        phoneView.layer.borderColor = UIColor(netHex:0xDEDEDF).CGColor
        phoneView.layer.cornerRadius = 5;
        phoneView.layer.masksToBounds = true
    }
    
    
    // MARK: - TextField Delegates
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField == pin4 {
            //pin3.resignFirstResponder()
            authCode = pin1.text + pin2.text + pin3.text + pin4.text
            if count(authCode) == 4 {
                authRequest.auth_code = authCode
                updateAuth()
            } else {
                authCode = ""
                pin1.text = ""
                pin2.text = ""
                pin3.text = ""
                pin4.text = ""
                pin1.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = string
        if (count(string) > 0)
        {
            nextFocus(textField)
            return false
        }
        return true
    }

    // go to next textField
    func nextFocus(currentTextField : UITextField){
        if  currentTextField == pin1 {
            pin1.resignFirstResponder()
            pin2.becomeFirstResponder()
        } else if currentTextField == pin2 {
            pin2.resignFirstResponder()
            pin3.becomeFirstResponder()
        } else if currentTextField == pin3 {
            pin3.resignFirstResponder()
            pin4.becomeFirstResponder()
        } else if currentTextField == pin4 {
            pin4.resignFirstResponder()
        }
    }
    
    // dismiss keyboard on tap of background
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}
