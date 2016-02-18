//
//  Checklist.swift
//  Checklists
//
//  Created by Tom Ceulemans on 16/02/16.
//  Copyright © 2016 Tom Ceulemans. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var iconName: String
    var items = [ChecklistItem]()
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(iconName, forKey: "IconName")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        return items.filter { item in
            !item.isChecked
        }.map { item in
            1
        }.reduce(0) { sum, value in
            sum + value
        }
    }
}
