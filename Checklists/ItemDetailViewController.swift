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

    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let item = (itemToEdit ?? ChecklistItem(text: ""))
        
        item.text = textField.text!
        
        if itemToEdit == nil {
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        } else {
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }
    }
    
    override func viewDidLoad() {
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text!
        let newText : NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
}