//
//  addNewGroupViewController.swift
//  gonshare
//
//  Created by SEIF EL FREJ ISMAIL on 02/05/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import Foundation
import UIKit

class addNewGroupViewController: UITableViewController {
    
    
    
    
    
    
    var firstNameCell: UITableViewCell = UITableViewCell()
    var lastNameCell: UITableViewCell = UITableViewCell()
    var shareCell: UITableViewCell = UITableViewCell()
    var datePickerCell: UITableViewCell = UITableViewCell()
    var cityToCell: UITableViewCell = UITableViewCell()
    var cityFromCell: UITableViewCell = UITableViewCell()
    
    var firstNameText: UITextField = UITextField()
    var lastNameText: UITextField = UITextField()
    
    var travelDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    override func loadView() {
        super.loadView()
        
        
        
        navigationItem.title = "Add new group"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: travelDatePicker.date)
        self.shareCell.textLabel?.text = "\(dateString)"
        travelDatePicker.isHidden = true
        
        // set the title
        self.title = "User Options"
        
        // construct first name cell, section 0, row 0
        self.firstNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.firstNameText = UITextField(frame: self.firstNameCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        self.firstNameText.placeholder = "First Name"
        self.firstNameCell.addSubview(self.firstNameText)
        
        // construct last name cell, section 0, row 1
        self.lastNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.lastNameText = UITextField(frame: self.lastNameCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        self.lastNameText.placeholder = "Last Name"
        self.lastNameCell.addSubview(self.lastNameText)
        
        // construct share cell, section 1, row 0
        self.shareCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.shareCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        self.datePickerCell.backgroundColor = UIColor.red
        self.datePickerCell.addSubview(self.travelDatePicker)
        self.travelDatePicker.frame = CGRect(x: 0, y: 0, width: 500, height: 216)
        self.datePickerCell.accessoryType = UITableViewCell.AccessoryType.none
        
        self.cityToCell.textLabel?.text = "Kiev"
        self.cityToCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.cityToCell.accessoryType = UITableViewCell.AccessoryType.none
        
        self.cityFromCell.textLabel?.text = "San Francisco"
        self.cityFromCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.cityFromCell.accessoryType = UITableViewCell.AccessoryType.none
        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: travelDatePicker.date)
        self.shareCell.textLabel?.text = "\(dateString)"
        
        print("changed")
        print("Selected value \(dateString)")
    }
    
    // Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Return the number of rows for each section in your static table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2    // section 0 has 2 rows
        case 1: return 4    // section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1{
            let height: CGFloat = travelDatePicker.isHidden ? 0.0 : 216.0
            return height
        }
        return 44.0
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.firstNameCell   // section 0, row 0 is the first name
            case 1: return self.lastNameCell    // section 0, row 1 is the last name
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.shareCell       // section 1, row 0 is the share option
            case 1: return self.datePickerCell
            case 2: return self.cityToCell
            case 3: return self.cityFromCell
            default: fatalError("Unknown row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Profile"
        case 1: return "Social"
        default: fatalError("Unknown section")
        }
    }
    
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Handle social cell selection to toggle checkmark
        if(indexPath.section == 1 && indexPath.row == 0) {
            
            // deselect row
            tableView.deselectRow(at: indexPath as IndexPath, animated: false)
            
            // toggle check mark
            if(self.shareCell.accessoryType == UITableViewCell.AccessoryType.none) {
                self.shareCell.accessoryType = UITableViewCell.AccessoryType.checkmark;
            } else {
                self.shareCell.accessoryType = UITableViewCell.AccessoryType.none;
            }
        }
        
        if(indexPath.section == 1 && indexPath.row == 0) {
            
            travelDatePicker.isHidden = !travelDatePicker.isHidden
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
    }
    
}
