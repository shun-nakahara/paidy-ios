//
//  PaidyCheckOutViewController.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

// MARK: - Delegates

public protocol PaidyCheckOutDelegate: class{
    
    func paidyCheckOutDidCancel(controller: PaidyCheckOutViewController)
    func paidyCheckOutDidComplete(controller: PaidyCheckOutViewController, payment: Payment)
}

// MARK: - PaidyCheckOutViewController

public class PaidyCheckOutViewController: UIViewController {
    var delegate:PaidyCheckOutDelegate

    @IBOutlet var headerView: UIView!
    @IBOutlet var childViewContainer: UIView!
    var previousViewController: UIViewController?
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var headerBrand: UILabel!
    @IBOutlet var headerInvoice: UILabel!
    @IBOutlet var paidyLogo: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var store_logo: UIView!
    @IBOutlet var storeImage: UIImageView!
    
    var paymentType: String!
    var authRequest: AuthRequest!
    var merchantKey: String!
    var sessionId: String!
    var imagePath: String?
    
    var lastResult: AnyObject!
    var multipay: NSArray!
    var multipayData: NSDictionary!
    
    // init with options
    required public init(merchantKey: String, delegate: PaidyCheckOutDelegate, authRequest: AuthRequest, sessionId: String, imagePath: String?)
    {
        self.merchantKey = merchantKey
        self.delegate = delegate
        self.authRequest = authRequest
        self.sessionId = sessionId
        self.imagePath = imagePath
        
        let frameworkBundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
        super.init(nibName: "PaidyCheckoutViewController", bundle: frameworkBundle)
    }
    
    // required init
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure store logo
        if (imagePath != nil) {
            storeImage.image = UIImage(contentsOfFile: imagePath!)
        } else {
            let bundle = NSBundle(identifier: "com.paidy.PaidyCheckoutSDK")
            let imagePath = bundle!.pathForResource("pd_store_logo_default.png", ofType: "")
            storeImage.image = UIImage(contentsOfFile: imagePath!)
        }
        
        headerBrand.shadowColor = UIColor.whiteColor()
        headerInvoice.shadowColor = UIColor.whiteColor()
        
        let maskPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, 92, 92))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.CGPath
        
        store_logo.layer.mask = maskLayer
        store_logo.layer.shadowOffset = CGSizeMake(0, 1)
        store_logo.layer.shadowOpacity = 0.3
        store_logo.layer.shadowRadius = 1
        
        
        setupPaymentType()
        // show IntroViewController
        setupIntro("launch")
    }
    
    // MARK: - Authorization
    
    func doAuthorization() {
        progressView.hidden = false
        
        // add tracking to auth request
        authRequest.tracking = Tracking()
        
        sendAuthorization { (response, lastResult, error) in
            if let dictResult = lastResult as? NSDictionary {
                if let resultArray = dictResult["payment_id"] as? String {
                    self.setVerifyUrl("verify_payment_id")
                }
            }
            
            // check for OK response code
            if (response?.statusCode == 200) {
                var status: String? = lastResult!.valueForKey("status") as? String
                var reason: String? = lastResult!.valueForKey("reason") as? String
                
                if (reason != nil && reason == "require_num_payments" && self.paymentType == "subscription") {
                    self.router("subscription_summary", reason: nil)
                } else {
                    self.router(status!, reason: reason)
                }
                
            } else {
                // route internal error
                self.router("internal_error", reason: nil)
            }
            
            self.progressView.hidden == true
            self.progressView.setProgress(0, animated: false)
        }
    }
    
    // async send Authorization to server
    private func sendAuthorization(completionHandler: (NSHTTPURLResponse?, AnyObject?, NSError?) -> ()) -> () {
        
        // convert authRequest to JSON
        let jsonData = Mapper().toJSON(authRequest)
        
        // set key params
        let params = ["consumer_key":"key", "consumer_secret":"secret"]
        
        // create URL request
        let url = NSURL(string: "https://api.paidy.com/pay/authorize")
        var request = NSMutableURLRequest(URL: url!)
        
        self.progressView.setProgress(0.8, animated: true)
        
        // create Almofire session
        let manager = Alamofire.Manager.sharedInstance
        // set Authorization header
        manager.session.configuration.HTTPAdditionalHeaders = ["Authorization" : "Bearer \(merchantKey)"]
        let almofireRequest: Request = manager.request(.POST, request, parameters:jsonData, encoding: .JSON)
            .validate()
            .responseJSON { request, response, data, error in
                    
            self.progressView.setProgress(1, animated: true)

            // handle response data
            self.lastResult = data
            completionHandler(response, data, error)
        }
    }
    
    // MARK: - Router
    
    func router(result: String, reason: String!) {        
        switch (result) {
            
        case "start":
           setupStart()
           
            
        case "authenticate_consumer":
            setupAuth()
            
        case "authenticate_consumer_fail":
            switch (reason) {
                
            case "phone_mismatch":
                setupSubView("phone_mismatch")
                
            case "email_mismatch":
                setupSubView("email_mismatch")
                
            case "invalid_auth_code":
                authenticateConsumerFail()
                
            case "rejected_limits":
                setupAuthRejectedLimits()
                
            default:
                break
            }
            
        case "require_data":
            switch (reason) {
            case "require_num_payments":
                setupPayments()
                
            case "require_consumer_data":
                setupConsumerData()
                
            default:
                break
            }
            
        case "oneshot-summary":
            setupOneshotSummary()
            
        case "multipay_summary":
            setupMultipaySummary()
            
        case "subscription_summary":
            subscriptionSummary()
            
        case "authorize_success":
            setupAuthSuccess()
            
        case "authorize_fail":
            setupSubView("authorize_fail")
            
        case "internal_error":
            setupSubView("internal_error")
            
        case "failed_request":
            setupSubView("failed_request")
            
        default:
            setupStart()
        }
    }
    
    /**
    *
    */
    func setupPaymentType(){
        if (authRequest.subscription != nil){
            paymentType = "subscription"
        } else {
            paymentType = "oneshot"
        }
    }
    
    /**
    * Intro View
    */
    func setupIntro(status: String) {
        setVerifyUrl("verify_intro")
        
        activeViewController = IntroViewController(status: status)
        headerView.hidden = true
    }
    
    /**
    * Start View
    */
    func setupStart() {
        setVerifyUrl("verify_start_view")
        
        activeViewController = StartViewController()
        headerView.hidden = false
        setDefaultHeaderElements(false)
        backButton.hidden = true
        setHeaderLayout()
    }
    
    /**
    * Auth View
    */
    func setupAuth() {
        setVerifyUrl("verify_auth_view")
        
        activeViewController = AuthViewController()
        headerView.hidden = false
        setDefaultHeaderElements(false)
        backButton.hidden = true
        setHeaderLayout()
    }
    
    /**
    * Payments View
    */
    func setupPayments() {
        setVerifyUrl("verify_payments_view")
        
        if let dictResult = lastResult as? NSDictionary {
            if let resultArray = dictResult["multipay"] as? NSArray {
                multipay = resultArray
            }
        }
        activeViewController = PaymentsViewController(multipay: multipay)
        headerView.hidden = false
        setDefaultHeaderElements(false)
        backButton.hidden = true
        setHeaderLayout()
    }
    
    /**
    * Oneshot Summary
    */
    func setupOneshotSummary() {
        setVerifyUrl("verify_oneshot_summary_view")
        
        activeViewController = OneshotSummaryViewController()
        headerView.hidden = false
        setDefaultHeaderElements(false)
        paidyLogo.hidden = true
        headerInvoice.hidden = true
        
        setHeaderLayout()
    }
    
    /**
    * Consumer Data
    */
    func setupConsumerData() {
        setVerifyUrl("verify_consumer_data_view")
        
        activeViewController = ConsumerDataViewController()
        setMultipayData()
        headerView.hidden = false
        setDefaultHeaderElements(false)
        paidyLogo.hidden = true
        paymentType = "multipay"
        setHeaderLayout()
    }
    
    /**
    * Multipay Summary
    */
    func setupMultipaySummary() {
        setVerifyUrl("verify_multipay_summary_view")
        
        setMultipayData()
        activeViewController = MultipaySummaryViewController()
        headerView.hidden = false
        setDefaultHeaderElements(false)
        paidyLogo.hidden = true
        headerInvoice.hidden = true
        setHeaderLayout()
    }
    
    /**
    * Subscription Summary
    */
    func subscriptionSummary () {
        setVerifyUrl("verify_subscription_summary_view")
        
        activeViewController = SubscriptionSummaryViewController()
        headerView.hidden = false
        setDefaultHeaderElements(true)
        closeButton.hidden = false
        setHeaderLayout()
    }
    
    /**
    * Auth Success view
    */
    func setupAuthSuccess (){
        setVerifyUrl("verify_authorize_success_view")
        
        activeViewController = AuthorizeSuccessViewController()
        headerView.hidden = false
        setDefaultHeaderElements(true)
        headerInvoice.hidden = false
        setHeaderLayout()
    }
    
    
    /**
    * SubViews
    */
    func setupSubView(view: String) {
        var brand: String
        if (authRequest.merchant_data != nil){
            brand = authRequest.merchant_data.store
        } else {
            brand = "Demo"
        }
        
        let subViewController = SubViewViewController(subView: view, brand: brand)
        self.presentViewController(subViewController, animated: true, completion: nil)
    }

    @IBAction func logoPressed(sender: UIButton) {
        setupIntro("help")
    }
    
    // close button from header
    @IBAction func close(sender: AnyObject) {
        setVerifyUrl("checkout_closed_by_user")
        
        delegate.paidyCheckOutDidCancel(self)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    /**
    * Close Intro view controller
    */
    func closeIntro() {
        activeViewController = previousViewController
        headerView.hidden = false
    }
  
    // back button from header
    @IBAction func backToRequireData(sender: UIButton) {
        authRequest.consumer_data = nil
        authRequest.options.num_payments = nil
        multipayData = nil
        setupPaymentType()
        
        doAuthorization()
        //router("require_data", reason: "require_num_payments")
    }
    
    // send verify to server
    func setVerifyUrl(id: String) {
        Alamofire.request(.GET, "https://api.paidy.com/intel/verify/update/\(sessionId)/\(id)", parameters: nil)
            .response { (request, response, data, error) in
        }
    }
    
    func setDefaultHeaderElements(visiblity: Bool){
        closeButton.hidden = visiblity
        paidyLogo.hidden = visiblity
        headerInvoice.hidden = visiblity
        backButton.hidden = visiblity
    }
    
    // configure header
    func setHeaderLayout(){
        setHeaderBackground()

        switch (paymentType) {
            
        case "oneshot" :
            if (authRequest.merchant_data != nil){
                headerBrand.text = authRequest.merchant_data.store
            }
            headerInvoice.text = "¥\(InputValidation.formatCurrency(authRequest.order.total_amount))"
            
        case "multipay" :
            let num_payments = multipayData["num_payments"] as! Int
            let monthly = InputValidation.formatCurrency(multipayData["monthly"]!)
            headerInvoice.text = "\(num_payments)回払い 月々 ¥\(monthly)"
            
        case "subscription" :
            if (authRequest.subscription != nil) {
                let subscription:Subscription = authRequest.subscription!
                var interval = ""
                headerBrand.text = authRequest.subscription?.title
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
                
                headerInvoice.text = "¥\(InputValidation.formatCurrency(authRequest.order.total_amount)) (\(subscription.interval_count)\(interval))"
            }
        
        default:
            break
            
        }
        //progressView.hidden = true
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
    
    // loop through multipay data to to get item where num_payments matches authRequest
    func setMultipayData() {
        var options:Options = authRequest.options
        for item in multipay {
            multipayData = item as! NSDictionary
            let num_payments = multipayData["num_payments"] as! Int
            if (num_payments == options.num_payments){
                break
            }
        }
    }
    
    func getMultipayData() -> NSDictionary {
        return multipayData
    }
    
    // MARK: - Custom Call back functions
    
    func sendResult(){
        setVerifyUrl("verify_paidy_checkout_end")
        
        // convert data to Payment object
        let payment = Mapper<Payment>().map(lastResult)
        
        // return Payment object to client application
        delegate.paidyCheckOutDidComplete(self, payment: payment!)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    // Auth code incorrect
    private func authenticateConsumerFail() {
        if let authViewController = (activeViewController as? AuthViewController) {
            authViewController.setError(true, text: "認証コードが違います。")
        }
    }
    
    // Reached auth limits
    private func setupAuthRejectedLimits() {
        if let authViewController: AuthViewController = (activeViewController as? AuthViewController) {
            authViewController.setError(true, text: "認証コードは送信済みです。")
        }
    }
    
    // MARK: - Custom View Controller switching
    
    // set activeViewController
    private var activeViewController: UIViewController? {
        didSet {
            previousViewController = oldValue
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = childViewContainer.bounds
            childViewContainer.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }
}
