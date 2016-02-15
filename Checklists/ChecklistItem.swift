//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Tom Ceulemans on 14/02/16.
//  Copyright © 2016 Tom Ceulemans. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject {
    var text:String
    var isChecked = false
    
    init(text:String) {
        self.text = text
    }
    
    func toggleIsChecked() {
        isChecked = !isChecked
    }
}