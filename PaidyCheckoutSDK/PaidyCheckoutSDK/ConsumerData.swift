//
//  ConsumerData.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit
import ObjectMapper

class ConsumerData: Mappable {
    var contract_address: ContractAddress!
    var income: Double!
    var dob: String!
    var gender: String!
    var spouse: String!
    var household_size: Int!
    var residence_type: String!
    var mortgage: Bool!
    var employer_name: String!
    
    init(income: Double, dob: String, gender: String, spouse: String, household_size: Int, residence_type: String, mortgage: Bool,
        employer_name: String) {
            self.income = income
            self.dob = dob
            self.gender = gender
            self.spouse = spouse
            self.household_size = household_size
            self.residence_type = residence_type
            self.mortgage = mortgage
            self.employer_name = employer_name
    }
    
    init(){
        
    }
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        contract_address <- map["contract_address"]
        income <- map["income"]
        dob <- map["dob"]
        gender <- map["gender"]
        spouse <- map["spouse"]
        household_size <- map["household_size"]
        residence_type <- map["residence_type"]
        mortgage <- map["mortgage"]
        employer_name <- map["employer_name"]
    }
    
    class ContractAddress:Mappable {
        var postal_code: String!
        var address1: String!
        var address2: String!
        var address3: String!
        var address4: String!
        
        init(postal_code: String, address1: String, address2: String, address3: String, address4: String){
            self.postal_code = postal_code
            self.address1 = address1
            self.address2 = address2
            self.address3 = address3
            self.address4 = address4
        }
        
        init() {
            
        }
        
        required init?(_ map: Map) {
            mapping(map)
        }
        
        // Mappable
        func mapping(map: Map) {
            postal_code <- map["postal_code"]
            address1 <- map["address1"]
            address2 <- map["address2"]
            address3 <- map["address3"]
            address4 <- map["address4"]
        }
    }
}
