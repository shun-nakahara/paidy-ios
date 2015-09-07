//
//  SubViewViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import Alamofire


class SubViewViewController: UIViewController {
    @IBOutlet var subViewTitle: UILabel!
    @IBOutlet var subViewCopy: UILabel!
    @IBOutlet var subViewLink: UIButton!
    @IBOutlet var termsWebView: UIWebView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerBrand: UILabel!
    @IBOutlet weak var subViewBackButton: UIButton!
    
    var subView: String
    var brand: String
    var resetUrl: String!
    
    // custom init
    init(subView: String, brand: String)
    {
        self.subView = subView
        self.brand = brand
        
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "SubViewViewController", bundle: frameworkBundle)
    }
    
    // require init
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // button style
        subViewBackButton.layer.cornerRadius = 5
    }
    
    // configure subview
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        headerBrand.text = brand

        switch (subView){
        case "phone_mismatch":
            setupPhoneReset()
            
        case "email_mismatch":
            setupEmailReset()
            
        case "authorize_fail":
            setupAuthorizeFail()
            
        case "internal_error":
            setupInternalError()
            
        case "failed_request":
            setupBadRequest()
            
        case "terms_oneshot":
            setupTerms()

        case "terms_multipay":
            setupMutlipayTerms()
            
        default:
            closeView()
        }
    }
    
    /**
    * Phone reset subview
    */
    func setupPhoneReset() {
        subViewLink.hidden = false
        subViewTitle.hidden = false
        termsWebView.hidden = true
        subViewTitle.text = "入力された電話番号が\n前回と異なります"
        subViewCopy.text = "新しい電話番号で買い物を継続する場合には、アカウントの再設定を行ってください。"
        subViewLink.titleLabel?.text = "アカウントの再設定"
        resetUrl = "https://my.paidy.com/consumer/reset"
    }
    
    /**
    * Email reset subview
    */
    func setupEmailReset() {
        subViewLink.hidden = false
        subViewTitle.hidden = false
        termsWebView.hidden = true
        subViewTitle.text = "入力されたメールアドレスが\n前回と異なります"
        subViewCopy.text = "新しいメールアドレメールアドレスで買い物を継続する場合には、Paidyカスタマーサポートまでご連絡ください。(平日10:00 - 18:00)"
        subViewLink.titleLabel?.text = "お問い合わせフォーム"
        resetUrl = "https://support.paidy.com/hc/ja/requests/new"
    }
    
    /**
    * Authorize fail subview
    */
    func setupAuthorizeFail(){
        subViewLink.hidden = true
        subViewTitle.hidden = false
        termsWebView.hidden = true
        subViewTitle.text = "決済が承認されませんでした"
        subViewCopy.text = "誠に申し訳ございませんが、この度の決済は承認されませんでした。\nその他のお支払いをご選択ください。"
    }
    
    /**
    * Internal error subview
    */
    func setupInternalError(){
        subViewLink.hidden = true
        subViewTitle.hidden = false
        termsWebView.hidden = true
        subViewTitle.text = "一時的にpaidyを利用できません"
        subViewCopy.text = "誠に申し訳ございませんが、６０秒後に再度お申込みください。"
    }
    
    /**
    * Bad request subview
    */
    func setupBadRequest() {
        subViewLink.hidden = true
        subViewTitle.hidden = false
        termsWebView.hidden = true
        subViewTitle.text = "現在こちらのオンラインショップからのお申込が受け付けられません。"
        subViewCopy.text = "誠にお手数をおかけしますが、こちらのオンラインショップへお問い合わせいただくか、paidy.comまでお問い合わせください。"
    }
    
    /**
    * Terms and conditions subview
    */
    func setupTerms() {
        println("failed_request")
        subViewLink.hidden = true
        subViewTitle.hidden = true
        termsWebView.hidden = false
        subViewCopy.text = ""
        getTerms("https://dev.paidy.com/pay/appTermsOneshot")
    }
    
    /**
    * Multipay terms and conditions
    */
   func setupMutlipayTerms() {
        subViewLink.hidden = true
        subViewTitle.hidden = true
        termsWebView.hidden = false
        subViewCopy.text = ""
        getTerms("https://dev.paidy.com/pay/appTermsInstallment")
    }
    
    /**
    * Load terms from url into webview
    */
    func getTerms(url: String){
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        termsWebView.loadRequest(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setHeaderBackground()
        
        // button style
        subViewBackButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // link button pressed
    @IBAction func linkPressed(sender: AnyObject) {
        // open url in default browser
        UIApplication.sharedApplication().openURL(NSURL(string: resetUrl)!)
    }

    // back button selected
    @IBAction func backButton(sender: AnyObject) {
        closeView()
    }
    
    // go back to main view controller
    func closeView() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // configure header background
    func setHeaderBackground(){
        let gradient : CAGradientLayer = CAGradientLayer()
        let arrayColors: [AnyObject] = [
            UIColor(netHex:0xFFFFFF).CGColor,
            UIColor(netHex:0xECECEC).CGColor]
        
        gradient.frame = headerView.bounds
        gradient.colors = arrayColors
        // replace base layer with gradient layer
        headerView.layer.insertSublayer(gradient, atIndex: 0)
        
        // create bottom border
        var bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: headerView.frame.height, width: headerView.frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor(netHex:0xD3D3D3).CGColor
        headerView.layer.addSublayer(bottomBorder)
    }
}
