//
//  MultiPayTableViewCell.swift
//  Paidycheckoutsdk
//
//  Copyright (c) 2015 Paidy. All rights reserved.
//

import UIKit

class MultiPayTableViewCell: UITableViewCell {
    @IBOutlet var multipayTerm: UILabel!
    @IBOutlet var multipaymentAmount: UILabel!
    @IBOutlet var cellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // custom color of cell
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor =  (UIColor(netHex:0x1FADFF)).CGColor
        
        cellView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadItem(multipayTerm: String, multipaymentAmount: String) {
        self.multipayTerm.text = multipayTerm
        self.multipaymentAmount.text = multipaymentAmount
    }
}
