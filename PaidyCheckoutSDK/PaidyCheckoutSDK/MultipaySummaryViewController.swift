//
//  MultipaySummaryViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class MultipaySummaryViewController: UIViewController {

    @IBOutlet var formula: UILabel!
    @IBOutlet var agreementText: UIButton!
    @IBOutlet var agreementCheck: UIButton!
    
    @IBOutlet var amount: UILabel!
    @IBOutlet var lastMonth: UILabel!
    @IBOutlet var total: UILabel!
    @IBOutlet var rate: UILabel!
    @IBOutlet var multipaySelectedButton: UIButton!
    
    var authRequest: AuthRequest!
    var checkBoxSelected: Bool = false

    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "MultipaySummaryViewController", bundle: frameworkBundle)
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
    
        let multipayData:NSDictionary = paidyCheckoutViewController.getMultipayData()
        var multipayNumPayments:Int = multipayData["num_payments"] as! Int
        var multipayMonthly = InputValidation.formatCurrency(multipayData["monthly"]!)
        var multipayLastMonth = InputValidation.formatCurrency(multipayData["last_month"]!)
        var multipayAmount = InputValidation.formatCurrency(authRequest.order.total_amount)
        var multipayTotal = InputValidation.formatCurrency(multipayData["total"]!)
        var multipayRate:Int = multipayData["effective"] as! Int

        formula.text = "\(multipayNumPayments)回払い　月々¥\(multipayMonthly)"
        amount.text = "¥\(multipayAmount)"
        lastMonth.text = "¥\(multipayLastMonth)"
        total.text = "¥\(multipayTotal)"
        rate.text = "支払総額(実質年率\(multipayRate)%)"
        
        // button style
        multipaySelectedButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func agreementCheckPressed(sender: UIButton) {
        if (checkBoxSelected){
            agreementCheck.selected = false
            checkBoxSelected = false;
        } else {
            agreementCheck.selected = true
            checkBoxSelected = true;
        }
    }

    @IBAction func agreementLink(sender: UIButton) {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.setupSubView("terms_multipay")
    }
    
    @IBAction func nextButton(sender: UIButton) {
        if (isCheckBoxValid()) {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.doAuthorization()
        }
    }
    
    // valdate checkBox
    func isCheckBoxValid() -> Bool  {
        var checkBoxValid: Bool = checkBoxSelected

        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        if (checkBoxValid) {
            let normalCheck = UIImage(named: "pd_checkbox_checked.png", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            agreementCheck.setImage(normalCheck, forState: UIControlState.Selected)
        } else {
            let errorCheck = UIImage(named: "pd_checkbox_error.png", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
            agreementCheck.setImage(errorCheck, forState: UIControlState.Normal)
        }
        
        return checkBoxValid
    }
}
