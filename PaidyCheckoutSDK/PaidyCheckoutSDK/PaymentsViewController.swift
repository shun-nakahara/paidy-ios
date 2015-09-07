//
//  PaymentsViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var oneshotTerm: UILabel!
    @IBOutlet var oneshotAmount: UILabel!
    @IBOutlet var multipayTableView: UITableView!
    @IBOutlet var oneshotButton: UIView!
    
    var authRequest: AuthRequest!
    var multipay: NSArray
    
    // custom init
    init(multipay: NSArray?) {
        self.multipay = multipay!
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "PaymentsViewController", bundle: frameworkBundle);
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
        
        oneshotAmount.text =  String("¥\(InputValidation.formatCurrency(authRequest.order.total_amount))")
        
        // load multipay cell
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        var nib = UINib(nibName: "MultiPayTableViewCell", bundle: frameworkBundle)
        multipayTableView.registerNib(nib, forCellReuseIdentifier: "multipayCell")
        
        
        // button style
        oneshotButton.layer.cornerRadius = 5
        oneshotButton.layer.masksToBounds = true
    }

    @IBAction func oneshotPayment(sender: UIButton) {
        // get authRequest from parent
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.router("oneshot-summary", reason: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // update authRequest with number of payments selected
    func paymentSelected(numPayments: Int) {
        let options: Options = authRequest.options
        options.num_payments = numPayments
        updateAuth();
    }

    // update main authRequest and do Auth
    func updateAuth() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.authRequest = authRequest
        paidyCheckoutViewController.doAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: Tableview
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selected = multipay.objectAtIndex(indexPath.row) as! NSDictionary
        paymentSelected(selected["num_payments"] as! Int)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multipay.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MultiPayTableViewCell = self.multipayTableView.dequeueReusableCellWithIdentifier("multipayCell") as! MultiPayTableViewCell
        
        // set cell data base on array items
        var term: NSDictionary = multipay[indexPath.row] as! NSDictionary        
        let num_payments = term["num_payments"] as! Int
        let monthly = term["monthly"] as! Double
        cell.loadItem("\(num_payments)回払い", multipaymentAmount: "¥\(InputValidation.formatCurrency(monthly))")
        return cell
    }
    
    
}
