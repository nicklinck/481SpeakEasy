//
//  Settings.swift
//  Speech
//
//  Created by Christopher James Lebioda on 11/6/17.
//  Copyright © 2017 Google. All rights reserved.
//

import UIKit


class Setting {
    
    //MARK: Properties
    
    var button: UIButton?
    var string: String?
    
    //MARK: Initialization
    
    init?(button: UIButton?, string: String) {
        
        // Initialize stored properties.
        self.button = button
        button?.setTitle(string, for: .normal)
        
    }
}
