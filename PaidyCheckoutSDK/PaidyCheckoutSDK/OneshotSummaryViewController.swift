//
//  OneshotSummaryViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class OneshotSummaryViewController: UIViewController {
    var authRequest: AuthRequest!
    
    @IBOutlet var oneshotAmount: UILabel!
    @IBOutlet var oneshotSelectedButton: UIButton!
    
    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "OneshotSummaryViewController", bundle: frameworkBundle)
    }
    
    // require init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get authRequest from parent
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        authRequest = paidyCheckoutViewController.authRequest
        
        // configure custom text lables
        oneshotAmount.text = "一括払い ¥\(InputValidation.formatCurrency(authRequest.order.total_amount))"
        
        // button style
        oneshotSelectedButton.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // oneshot payment selected
    @IBAction func oneshotSelected(sender: UIButton) {
        let options: Options = authRequest.options
        options.num_payments = 1
        updateAuth();
    }
        
    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.doAuthorization()
    }
}
