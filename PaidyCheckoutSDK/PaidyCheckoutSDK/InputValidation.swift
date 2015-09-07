//
//  InputValidation.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class InputValidation {
    
    static func isValidEmail(emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailString)
    }
    
    static func isValidPhone(phoneString: String) -> Bool {
        let phoneRegex = "^(?:070|080|090)\\d{8}$"
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluateWithObject(phoneString)
    }
    
    static func formatCurrency(amount:AnyObject) -> String {
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.generatesDecimalNumbers = false
        return numberFormatter.stringForObjectValue(amount)!
    }
    
    static func isKana(input:String) -> Bool {
        let kanaRegex = "^[ぁ-んァ-ロワヲンー｡-ﾟ\r\n\t]+$"
        var kanaTest = NSPredicate(format: "SELF MATCHES %@", kanaRegex)
        return kanaTest.evaluateWithObject(input)
    }
    
    static func isDob(input:String) -> Bool {
        let dobRegex = "^\\d{4}-\\d{2}-\\d{2}$"
        var dobaTest = NSPredicate(format: "SELF MATCHES %@", dobRegex)
        
        if (dobaTest.evaluateWithObject(input)){
            return isAgeLimit(input)
        } else {
            return false
        }
    }
    
    static func isAgeLimit(dob:String) -> Bool {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateFromString = dateFormatter.dateFromString(dob)
        return calculateAge(dateFromString!) >= 18
    }
    
    static func calculateAge(birthday: NSDate) -> NSInteger {
        
        var userAge : NSInteger = 0
        var calendar : NSCalendar = NSCalendar.currentCalendar()
        var unitFlags : NSCalendarUnit = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay
        var dateComponentNow : NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
        var dateComponentBirth : NSDateComponents = calendar.components(unitFlags, fromDate: birthday)
        
        if ( (dateComponentNow.month < dateComponentBirth.month) ||
            ((dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day))
            )
        {
            return dateComponentNow.year - dateComponentBirth.year - 1
        }
        else {
            return dateComponentNow.year - dateComponentBirth.year
        }
    }
}
