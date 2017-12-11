//
//  OtherInputTableViewCell.swift
//  Speech
//
//  Created by Nick Linck on 12/10/17.
//  Copyright © 2017 Google. All rights reserved.
//

import UIKit

class OtherInputTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var otherTextField: UITextField!
    var replacingText: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configure(text: String?, placeholder: String) {
        otherTextField.text = text
        otherTextField.placeholder = placeholder
        
        otherTextField.accessibilityValue = text
        otherTextField.accessibilityLabel = placeholder
        
        //replacingText = otherTextField.text!
    }

}
