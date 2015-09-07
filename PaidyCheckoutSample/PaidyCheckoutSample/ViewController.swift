//
//  ViewController.swift
//  PaidyCheckoutSample
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

import PaidyCheckoutSDK
import CryptoSwift

// Mark: - ViewController

class ViewController: UIViewController, PaidyCheckOutDelegate {
    let paidy = Paidy(merchantKey: "NTUwZmRiYjExZTAwMDBmMTMyM2Y5OTJh")
    var authRequest: AuthRequest!
    
    @IBOutlet var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set custom image
        let bundle = NSBundle(forClass: ViewController.self)
        let imagePath = bundle.pathForResource("sample_store_logo.png", ofType: "")
        paidy.imagePath = imagePath
        
        // create AuthRequest
        authRequest = AuthRequest()
        // set Buyer
        authRequest.buyer = configureBuyer()
        // set Merchant Data
        authRequest.merchant_data = configureMerchant()
        
        // button style
        checkoutButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func paidyPay(sender: UIButton) {
        
        // set Options
        let options = Options(authorize_type: "extended")
        authRequest.options = options
        // set Order Data
        authRequest.order = configureOrder()
        //set Checksum
        authRequest.checksum = generateCheckSum()
        //set Subscription
        //authRequest.subscription = configureSubscription()

        // call paidy.launch to get paidyViewController
        let paidyViewController =  paidy.launch(self, authRequest: authRequest)
        // present the paidyViewController
        presentViewController(paidyViewController, animated: true, completion: nil)
    }
    
    // Mark: - PaidyCheckOutViewController Delegate
    
    // Paidy cancel checkout cancel delegate method
    func paidyCheckOutDidCancel(controller: PaidyCheckOutViewController) {
        println("did cancel")
    }
    
    // Paidy complete checkout Success delegate method
    func paidyCheckOutDidComplete(controller: PaidyCheckOutViewController, payment: Payment) {
        println("PaymentID: \(payment.payment_id)")
    }
    
    // Mark: - AuthRequest Source Data
    
    /**
    * Hardcoded buyer sample
    */
    func configureBuyer() -> Buyer
    {
        // hard coded for testing
        let buyer = Buyer(name: "山田　太郎　ｉｏｓ", name2: "ヤマダ タロウ", dob: "1901-01-05")
        buyer.email = Buyer.Email(address: "test0@paidy.com")
        buyer.address = Buyer.Address(address1: "11-2", address2: "神田美土代町", address3: "千代田区", address4: "東京都", postal_code: "101-0053")
        buyer.phone = Buyer.Phone(number: "08000000000")
        
        return buyer
    }
    
    /**
    * Hardcoded merchant sample
    */
    func configureMerchant() -> MerchantData
    {
        // hard coded for testing
        return MerchantData(store: "Sample", last_order: 40, customer_age: 20, last_order_amount: 80231, known_address: true, num_orders: 2, ltv: 80231, ip_address: "0.0.0.0")
    }
    
    /**
    * Hardcoded order sample
    */
    func configureOrder() -> Order
    {
        // hard coded for testing
        let order = Order()!
        let item1 = Order.Item(item_id: "1", title: "BLACK FLYS FLY MIND ウェリントンアイウエア メンズ", amount: 5443, quantity: 1)
        let item2 = Order.Item(item_id: "2", title: "BLACK FLYS BFOPT.04 スクエアアイウエア メンズ", amount: 7290, quantity: 1)
        var items: [Order.Item] = [item1, item2]
        
        order.items = items
        order.tax = 0
        order.shipping = 648
        order.total_amount = 13381
        
        return order
    }
    
    /**
    * Hardcoded subscription sample
    */
    func configureSubscription() -> Subscription
    {
    return Subscription(title: "Contact Lenses Pro", interval: "year", interval_count: 1, start: "2015-07-01")
    }
    
    /**
    * Hardcoded checksum sample
    */
    func generateCheckSum() -> String
    {
        let merchantData = authRequest.merchant_data
        let text = "Ml8bSWMtDyVAatP8UZDRQKVCv0MqDSWPGhqqB4rXie95zx3Zt4hiQyV9UBhMpJDw\(Int(authRequest.order.total_amount))\(merchantData.store)\(merchantData.customer_age)\(merchantData.last_order)\(Int(merchantData.last_order_amount))\(merchantData.known_address)\(merchantData.num_orders)\(Int(merchantData.ltv))\(merchantData.ip_address)"
        
        let data = (text as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let hash = data!.sha256()
        return hash!.toHexString().lowercaseString
    }
}


