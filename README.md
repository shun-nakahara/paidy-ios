# Paidy iOS SDK

The Paidy iOS SDK makes it easy to accept payment using email address and phone number without the need of a credit card. 

## Requirements
Paidy SDK is a Swift framework compatible with iOS apps iOS 8 and above. It is recommended to use the latest Xcode 6.4 version for compiling.


# Installation

### CocoaPods


To integrate Paidy SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod ‘Paidy’, '~> 1.0.0’
```

Then, run the following command:

```bash
$ pod install
```

### Manually

Paidy SDK can be added manually into your project by cloning the current GiHub repository.

#### Embedded Framework

We’ve included an archived version of the [PaidyCheckoutSDK.framework](https://github.com/paidy/paidy-ios/tree/master/PaidyCheckoutSDK/_Archive) in the source files. Just add a copy of this to your working directory and ensure to include in the “Embedded Binaries” and “Linked Frameworks and Libraries” section of the applications target.   

#### Source File

You can also download the complete source, build it and generate your own PaidyCheckoutSDK.framework in your projects’ “DerivedData” output files. 

The PaidyCheckoutSDK.framework relies on the following depencies to compile succesfully:
- [Alamofire 1.3.1](https://github.com/Alamofire/Alamofire/tree/1.3.1)
- [ObjectMapper 0.12](https://github.com/Hearst-DD/ObjectMapper/tree/0.12)

---

## Usage

### Example Application

[PaidyCheckoutSample](https://github.com/paidy/paidy-ios/tree/master/PaidyCheckoutSample) shows the minimal requirements for integrating Paidy SDK.

### Preparation

The View Controller must conform to PaidyCheckOutDelegate and include the required methods.

```swift
import PaidyCheckoutSDK

// Mark: - PaidyCheckOutViewController Delegate
    
// Paidy cancel checkout cancel delegate method
func paidyCheckOutDidCancel(controller: PaidyCheckOutViewController) {
    println("did cancel")
}
    
// Paidy complete checkout Success delegate method
func paidyCheckOutDidComplete(controller: PaidyCheckOutViewController, payment: Payment) {
    println("PaymentID: \(payment.payment_id)")
}
```

### Initialization

Create a new Paidy object with the required merchantKey parameter.

```swift
let paidy = Paidy(merchantKey: "NTUwZmRiYjExZTAwMDBmMTMyM2Y5OTJh")
```

Within viewDidLoad override method create the AuthRequest object.

```swift
// create AuthRequest
authRequest = AuthRequest()
// set Buyer
authRequest.buyer = configureBuyer()
// set Merchant Data
authRequest.merchant_data = configureMerchant()
```

Custom Merchant image.png file can be set in the Paidy object.

```swift
// set custom image
let bundle = NSBundle(forClass: ViewController.self)
let imagePath = bundle.pathForResource("sample_store_logo.png", ofType: "") paidy.imagePath = imagePath
```

Buyer object must be initiated with required parameters.

```swift
let buyer = Buyer(name: "山田 太郎", name2: "ヤマダ タロウ", dob: "1901-01-05")
```

Buyer Email, Address and Phone are also objects required.

```swift
buyer.email = Buyer.Email(address: "test13@paidy.com")
buyer.address = Buyer.Address(address1: "11-2", address2: "神田美土代町", address3: "千代田区", address4: "東京都", postal_code: "101-0053")
buyer.phone = Buyer.Phone(number: "08000000013")
```

Merchant object must be initiated with required parameters:

```swift
MerchantData(store: "Sample Merchant", last_order: 40, customer_age: 20, last_order_amount:
80231, known_address: true, num_orders: 2, ltv: 80231, ip_address: "0.0.0.0")
```

### Paidy Button Action

Action of the Pay with Paidy button, Options, Order, Checksum and subscription should be added to the AuthRequest.

```swift
// set Options
let options = Options(authorize_type: "extended") authRequest.options = options
// set Order Data
authRequest.order = configureOrder()
//set Checksum
authRequest.checksum = generateCheckSum()
//set Subscription
//authRequest.subscription = configureSubscription()
```

An Order object can be created as follows

```swift
let order = Order()!
```

Order Items should be created with the required parameters: 
- Create a list of items and add to the orders list

```swift
let order = Order()!
let item1 = Order.Item(item_id: "1", title: "BLACK FLYS FLY MIND ウェリントンアイウエア メンズ", amount: 5443, quantity: 1)
let item2 = Order.Item(item_id: "2", title: "BLACK FLYS BFOPT.04 スクエアアイウエア メンズ", amount: 7290, quantity: 1)
var items: [Order.Item] = [item1, item2]
        
order.items = items
order.tax = 0
order.shipping = 648
order.total_amount = 13381
```

Subscription object must be initiated with required parameters:

```swift
Subscription(title: "Contact Lenses Pro", interval: "year", interval_count: 1, start:
"2015-06-26")
```

### Paidy Launch
paidy.launch requires delegate and AuthRequest parameters to return View Controller for application to present.

```swift
// call paidy.launch to get paidyViewController
let paidyViewController = paidy.launch(self, authRequest: authRequest)
// present the paidyViewController 
presentViewController(paidyViewController, animated: true, completion: nil)
```

---

## Reference 

Further support and API reference can be found at [Paidy Developer](https://paidy.com/developer)