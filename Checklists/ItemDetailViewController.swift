//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Tom Ceulemans on 14/02/16.
//  Copyright © 2016 Tom Ceulemans. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController : UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = NSDate()
    var datePickerVisible = false
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let item = (itemToEdit ?? ChecklistItem(text: ""))
        
        item.text = textField.text!
        item.dueDate = dueDate
        item.shouldRemind = shouldRemindSwitch.on
        item.scheduleNotification()
        
        if itemToEdit == nil {
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        } else {
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }
    }
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    override func viewDidLoad() {
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text!
        let newText : NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
    
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
            
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.endUpdates()
            
        datePicker.setDate(dueDate, animated: false)
    }

    func hideDatePicker() { 
		if datePickerVisible {
			datePickerVisible = false
			let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
			let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)

			if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) { 
				cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
			}
			tableView.beginUpdates() 
			tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None) 
			tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
			tableView.endUpdates() 
		}
	}


}