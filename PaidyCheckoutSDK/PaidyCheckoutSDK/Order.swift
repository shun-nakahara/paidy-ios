//
//  Order.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

public class Order: Mappable {
    public var items: [Item]!
    public var tax: Double!
    public var shipping: Double!
    public var total_amount: Double = 0
    public var order_ref: String!
    
    public class Item: Mappable {
        var item_id : String!
        var title: String!
        var amount: Double!
        var quantity: Int!
        
        public init(item_id: String, title: String, amount: Double,  quantity: Int) {
            self.item_id = item_id
            self.title = title
            self.amount = amount
            self.quantity = quantity
        }
        
        required public init?(_ map: Map) {
            mapping(map)
        }
        
        // Mappable
        public func mapping(map: Map) {
            item_id <- map["item_id"]
            title <- map["title"]
            amount <- map["amount"]
            quantity <- map["quantity"]
        }
    }
    
    public init?() {
        // Empty Constructor
    }
    
    required public init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        items <- map["items"]
        tax <- map["tax"]
        shipping <- map["shipping"]
        total_amount <- map["total_amount"]
        order_ref <- map["order_ref"]
    }
}
