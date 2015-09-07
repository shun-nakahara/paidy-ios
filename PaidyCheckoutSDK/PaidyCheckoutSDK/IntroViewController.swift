//
//  IntroViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var introText: UILabel!
    @IBOutlet var point1Text: UILabel!
    @IBOutlet var point2Text: UILabel!
    @IBOutlet var point3Text: UILabel!
    @IBOutlet var introButton: UIButton!
 
    var authRequest: AuthRequest!
    var status: String
    
    // custom init
    init(status: String)
    {
        self.status = status
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "IntroViewController", bundle: frameworkBundle)
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
 
        // configure intro copy based on subscription
        if (authRequest.subscription != nil){
            introText.text = "クレジットカード不要の簡単決済！\n購入金額に応じて分割払いも可能。"
            point1Text.text = "メールアドレスと携帯電話番号で\n決済手続き完了"
            point2Text.text = "1回の注文手続きで\n定期購入受付完了"
            point3Text.text = "ご利用金額を翌月10日にコンビニ\nまたは銀行振込でお支払い"
        } else {
            introText.text = "クレジットカード不要の簡単決済！\n購入金額に応じて分割払いも可能。"
            point1Text.text = "メールアドレスと携帯電話番号で\n決済手続き完了"
            point2Text.text = "1ヵ月のご利用分をまとめた\n請求書を翌月1日に発行"
            point3Text.text = "翌月10日までにコンビニまたは\n銀行振込でお支払い"
        }
        
        // set button style
        introButton.layer.cornerRadius = 5
        introButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        view.alpha = 0
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (status == "launch"){
            introButton.titleLabel?.text = "次へ"
        } else {
            introButton.titleLabel?.text = "戻る"
        }
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 1.0
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // next button pressed
    @IBAction func introNext(sender: UIButton) {
        let paidyCheckoutViewController: PaidyCheckOutViewController = self.parentViewController as! PaidyCheckOutViewController
        
        if (status == "launch") {
            paidyCheckoutViewController.router("start", reason: nil)
        } else {
            paidyCheckoutViewController.closeIntro()
        }
    }
}
