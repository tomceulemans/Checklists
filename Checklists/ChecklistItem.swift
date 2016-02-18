//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Tom Ceulemans on 14/02/16.
//  Copyright © 2016 Tom Ceulemans. All rights reserved.
//

import UIKit

class ChecklistItem : NSObject, NSCoding {
    var text = ""
    var isChecked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemId: Int
    
    init(text:String) {
        self.text = text
        itemId = DataModel.nextChecklistItemId()
        super.init()
    }
    
    override init() {
        itemId = DataModel.nextChecklistItemId()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        isChecked = aDecoder.decodeBoolForKey("IsChecked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemId = aDecoder.decodeIntegerForKey("ItemId")
        super.init()
    }
    
    func toggleIsChecked() {
        isChecked = !isChecked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(isChecked, forKey: "IsChecked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemId, forKey: "ItemId")
    }
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = [ "ItemId" : itemId ]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            print("Scheduled notification \(localNotification) for itemId \(itemId)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemId"] as? Int where number == itemId {
                return notification
            }
        }
        
        return nil
    }
    
    deinit {
		if let notification = notificationForThisItem() {
			print("Removing existing notification \(notification)") 
			UIApplication.sharedApplication().cancelLocalNotification(notification)
		} 
	}
}