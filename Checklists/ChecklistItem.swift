//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Tom Ceulemans on 14/02/16.
//  Copyright © 2016 Tom Ceulemans. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject, NSCoding {
    var text = ""
    var isChecked = false
    
    init(text:String) {
        self.text = text
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        isChecked = aDecoder.decodeBoolForKey("IsChecked")
        super.init()
    }
    
    func toggleIsChecked() {
        isChecked = !isChecked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(isChecked, forKey: "IsChecked")
    }
}