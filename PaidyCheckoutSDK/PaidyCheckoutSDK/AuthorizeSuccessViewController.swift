//
//  AuthorizeSuccessViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class AuthorizeSuccessViewController: UIViewController {

    @IBOutlet var countdownTime: UILabel!
    @IBOutlet var completedButton: UIButton!
    
    var countTime = 8
    var timer = NSTimer()
    
    // default init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "AuthorizeSuccessViewController", bundle: frameworkBundle)
    }
    
    // requried init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create countdown
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown:"), userInfo: nil, repeats: true)

        // button style
        completedButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // OK button pressed
    @IBAction func okButton(sender: UIButton) {
        timer.invalidate()
        close()
    }
    
    func countDown(timer: NSTimer) {
        // count down 8 seconds
        countTime--
        countdownTime.text = "\(countTime)"

        // close on reaching 0
        if(countTime == 0)  {
            timer.invalidate()
            close()
        }
    }
    
    func close() {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        paidyCheckoutViewController.sendResult()
    }
}
