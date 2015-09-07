//
//  SubscriptionSummaryViewController.swift
//  PaidyCheckoutSDK
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class SubscriptionSummaryViewController: UIViewController {

    @IBOutlet var subFirstText: UILabel!
    @IBOutlet var subAmountText: UILabel!
    @IBOutlet var subIntervalText: UILabel!
    @IBOutlet var subscriptionSelectedButton: UIButton!
    var authRequest: AuthRequest!
    
    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "SubscriptionSummaryViewController", bundle: frameworkBundle)
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
        
        var interval = ""
        let subscription:Subscription = authRequest.subscription!
        switch (subscription.interval) {
        case "year":
            interval = "年毎"
            
        case "month":
            interval = "月毎"
            
        case "week":
            interval = "週間毎"
            
        case "daily":
            interval = "日毎"
            
        default:
            break
        }

        subAmountText.text = "¥\(InputValidation.formatCurrency(authRequest.order.total_amount))"
        subIntervalText.text = "\(authRequest.subscription!.interval_count)\(interval)"
        subFirstText.text = formatDate(authRequest.subscription!.start)
        
        // button style
        subscriptionSelectedButton.layer.cornerRadius = 5
        
    }
    
    func formatDate (date: String) -> String {
        var d = date.componentsSeparatedByString("-")
        if (count(d) == 3) {
            return d[0] + "年" + d[1] + "月" + d[2] + "日";
        } else {
            return ""
        }
    }
    
    // subscription payment selected
    @IBAction func subscriptionSelected(sender: UIButton) {
        let options: Options = authRequest.options
        options.num_payments = 1
        updateAuth();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.doAuthorization()
    }
}
