//
//  ConsumerDataViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class ConsumerDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var activeTextField:UITextField?

    @IBOutlet var name2Last: UITextField!
    @IBOutlet var name2First: UITextField!
    @IBOutlet var postCode: UITextField!
    @IBOutlet var pref: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var income: UITextField!
    @IBOutlet var dob: UITextField!
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet var spouseControl: UISegmentedControl!
    @IBOutlet var houseHoldControl: UISegmentedControl!
    
    @IBOutlet var residence: UITextField!
    @IBOutlet var residencePicker: UIPickerView!
    
    @IBOutlet var mortgageControl: UISegmentedControl!
    @IBOutlet var employer: UITextField!
    @IBOutlet var consumerDataNextButton: UIButton!
    
    var residenceType = ["賃貸", "社宅・寮", "持ち家 (自己名義)", "持ち家 (家族名義)"]
    
    var gender:String?
    var spouse:String?
    var household:Int?
    var mortgage:Bool?

    var authRequest: AuthRequest!
    
    var gray : UIColor = UIColor(red:205/255, green:209/255, blue:216/255, alpha: 1.0)
    var blue : UIColor = UIColor(red:62/255, green:164/255, blue:248/255, alpha: 1.0)
    var red : UIColor = UIColor(netHex:0xFAE5E6)

    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "ConsumerDataViewController", bundle: frameworkBundle)
    }
    
    // requried init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get authRequest from parent
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        authRequest = paidyCheckoutViewController.authRequest
        
        // set fields with existing data
        let buyer:Buyer = authRequest.buyer
        var name2:String = buyer.name2.replace("　", withString:" ")
        var nameArray = name2.componentsSeparatedByString(" ")
        if count(nameArray) == 2 {
            name2Last.text = nameArray[0]
            name2First.text = nameArray[1]
        }
        
        if (buyer.address != nil) {
            postCode.text = buyer.address.postal_code
            pref.text = buyer.address.address4
            address.text = "\(buyer.address.address3)\(buyer.address.address2)\(buyer.address.address1)"
        }
        
        residencePicker = UIPickerView()
        residencePicker.delegate = self
        residencePicker.dataSource = self
        self.residence.inputView = residencePicker
        
        // button style
        consumerDataNextButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func nextButton(sender: UIButton) {
        if (validateInput()) {
            var buyer:Buyer = authRequest.buyer
            buyer.name2 = ("\(name2Last.text) \(name2First.text)")
            
            var consumerData: ConsumerData = ConsumerData()
            var contractAddress = ConsumerData.ContractAddress()
            
            contractAddress.postal_code = postCode.text
            contractAddress.address1 = address.text
            contractAddress.address2 = ""
            contractAddress.address3 = ""
            contractAddress.address4 = pref.text
            
            consumerData.contract_address = contractAddress
            consumerData.income = (income.text as NSString).doubleValue
            consumerData.dob = dob.text
            consumerData.gender = gender
            consumerData.spouse = spouse
            consumerData.household_size = household
            consumerData.residence_type = residence.text
            consumerData.mortgage = mortgage
            consumerData.employer_name = employer.text
            
            authRequest.consumer_data = consumerData
            updateAuth();
        }
    }
    
    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.router("multipay_summary", reason: nil)
    }
    
    @IBAction func genderChanged(sender:UISegmentedControl) {
        switch genderControl.selectedSegmentIndex
        {
        case 0:
            gender = "female"
            (genderControl.subviews[1] as! UIView).tintColor = blue
            (genderControl.subviews[0] as! UIView).tintColor = gray
        case 1:
            gender = "male"
            (genderControl.subviews[0] as! UIView).tintColor = blue
            (genderControl.subviews[1] as! UIView).tintColor = gray
        default:
            break;
        }
    }
    
    @IBAction func spouseChanged(sender:UISegmentedControl) {
        switch spouseControl.selectedSegmentIndex
        {
        case 0:
            spouse = "あり"
            (spouseControl.subviews[1] as! UIView).tintColor = blue
            (spouseControl.subviews[0] as! UIView).tintColor = gray
        case 1:
            spouse = "なし"
            (spouseControl.subviews[0] as! UIView).tintColor = blue
            (spouseControl.subviews[1] as! UIView).tintColor = gray
        default:
            break;
        }
    }
    
    @IBAction func householdChanged(sender:UISegmentedControl) {
        for subview in houseHoldControl.subviews{
            if let item = subview as? UIImageView {
                if item.highlighted {
                    item.tintColor = blue
                }
                else{
                    item.tintColor = gray
                }
            }
        }
        switch houseHoldControl.selectedSegmentIndex
        {
        case 0:
            household = 1
        case 1:
            household = 2
        case 2:
            household = 3
        case 3:
            household = 4
        default:
            break;
        }
    }
    
    @IBAction func mortgageChanged(sender:UISegmentedControl) {
        switch mortgageControl.selectedSegmentIndex
        {
        case 0:
            mortgage = true
            (mortgageControl.subviews[1] as! UIView).tintColor = blue
            (mortgageControl.subviews[0] as! UIView).tintColor = gray
        case 1:
            mortgage = false
            (mortgageControl.subviews[0] as! UIView).tintColor = blue
            (mortgageControl.subviews[1] as! UIView).tintColor = gray
        default:
            break;
        }
    }
    
    // display datePickerView for dob
    @IBAction func dobFieldEditing(sender: UITextField) {
        var datePickerView:UIDatePicker = UIDatePicker()
        
        // create done button on UIToolbar
        let toolBar:UIToolbar = UIToolbar()
        toolBar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dobDone:"))
        var toolbarButtons = [space, doneButton]
        toolBar.setItems(toolbarButtons, animated: false)
        dob.inputAccessoryView = toolBar
        
        // create default date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var defaultDate: NSDate = dateFormatter.dateFromString("1979-01-01")!
       
        datePickerView.date = defaultDate
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dob.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func dobDone(sender: UIDatePicker) {
        dob.resignFirstResponder()
    }

    
    // MARK: - Delegates

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the number of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return residenceType.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return residenceType[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        residence.text = residenceType[row]
        residence.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // validation
    func validateInput() -> Bool {
        var nameLastValid: Bool = InputValidation.isKana(name2First.text)
        var nameFirstValid: Bool = InputValidation.isKana(name2Last.text)
        var dobValid: Bool = InputValidation.isDob(dob.text)
        var postalCodeValid: Bool = postCode.text != ""
        var prefValid: Bool = pref.text != ""
        var addressValid: Bool = address.text != ""
        var incomeValid: Bool = income.text != ""
        var residenceValid: Bool = residence.text != ""
        var genderValid: Bool = gender != nil
        var spouseValid: Bool = spouse != nil
        var householdValid: Bool = household != nil
        var mortgageValid: Bool = mortgage != nil
        var employerValid: Bool = employer.text != ""

        if (nameLastValid){
            TextViewStates.setNormal(name2First)
        } else {
            TextViewStates.setError(name2First)
        }
        
        if (nameFirstValid){
            TextViewStates.setNormal(name2Last)
        } else {
            TextViewStates.setError(name2Last)
        }
        
        if (dobValid){
            TextViewStates.setNormal(dob)
        } else {
            TextViewStates.setError(dob)
        }
        
        if (postalCodeValid){
            TextViewStates.setNormal(postCode)
        } else {
            TextViewStates.setError(postCode)
        }
        
        if (prefValid){
            TextViewStates.setNormal(pref)
        } else {
            TextViewStates.setError(pref)
        }
        
        if (addressValid){
            TextViewStates.setNormal(address)
        } else {
            TextViewStates.setError(address)
        }
        
        if (incomeValid){
            TextViewStates.setNormal(income)
        } else {
            TextViewStates.setError(income)
        }
        
        if (residenceValid){
            TextViewStates.setNormal(residence)
        } else {
            TextViewStates.setError(residence)
        }
        
        if (employerValid){
            TextViewStates.setNormal(employer)
        } else {
            TextViewStates.setError(employer)
        }
        
        if (!genderValid) {
            genderControl.backgroundColor = red
        }
        
        if (!spouseValid) {
            spouseControl.backgroundColor = red
        }
        
        if (!householdValid) {
            houseHoldControl.backgroundColor = red
        }
        
        if (!mortgageValid) {
            mortgageControl.backgroundColor = red
        }
        
        return nameLastValid && nameFirstValid && dobValid && postalCodeValid && prefValid && addressValid
            && incomeValid && residenceValid && genderValid && spouseValid && householdValid
            && mortgageValid && employerValid
    }
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        //scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        //scrollView.scrollEnabled = false
    }
    
    // dismiss keyboard on tap of background
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
