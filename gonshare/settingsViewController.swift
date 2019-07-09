//
//  settingsViewController.swift
//  gonshare
//
//  Created by SEIF EL FREJ ISMAIL on 14/05/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import FirebaseAuth

class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var creditEmailCell: UITableViewCell = UITableViewCell()
    var numberOfUserCell = UITableViewCell()
    var logOutCell : UITableViewCell = UITableViewCell()
    var creditEmailTextField: UITextField = UITextField()
    var numberOfUserTextField1 = UITextField()
    var logOutTextField = UITextField()
    var numberOfUserTextField2 = UITextField()
    var logOutButton = UIButton(type: .system)
    
    
    let navBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.95)
        bar.translatesAutoresizingMaskIntoConstraints=false
        return bar
        
    }()
    
    let navBarTitle : UILabel = {
        let lab = UILabel()
        lab.text = "Settings"
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints=false
        lab.font = UIFont(name:"HelveticaNeue-Medium", size: lab.font.pointSize+3)
        return lab
    }()
    
    let returnButton : UIButton={
        let but = UIButton(type: .system)
        
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        but.setTitle("Done", for: .normal)
        but.setTitleColor(UIColor.blue, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        return but
    }()
    
    let tableView : UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 70*screenHeight, width: UIScreen.main.bounds.width, height: screen.height-70*screenHeight ), style: .grouped)
        table.isScrollEnabled = true
        
        return table
    }()
    
    func setUpCells(){
        self.numberOfUserCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.numberOfUserTextField1 = UITextField(frame: self.numberOfUserCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        self.numberOfUserTextField2 = UITextField(frame: self.numberOfUserCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        self.numberOfUserTextField1.text = "You are currently in:"
        self.numberOfUserTextField2.placeholder = "\(String(nOfMyUsers)) people"
        numberOfUserTextField1.isUserInteractionEnabled = false
        self.numberOfUserCell.addSubview(self.numberOfUserTextField1)
        self.numberOfUserCell.addSubview(self.numberOfUserTextField2)
        self.numberOfUserTextField1.frame = CGRect(x: self.numberOfUserTextField1.frame.minX*screenWidth, y: self.numberOfUserTextField1.frame.minY*screenHeight, width: 200*screenWidth, height: self.numberOfUserTextField1.frame.height*screenHeight)
        numberOfUserTextField2.frame = CGRect(x: self.numberOfUserTextField1.frame.minX*screenWidth+200*screenWidth, y: self.numberOfUserTextField1.frame.minY*screenHeight, width: 200*screenWidth, height: self.numberOfUserTextField1.frame.height*screenHeight)
        
        
        // construct last name cell, section 0, row 1
        self.creditEmailCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.creditEmailTextField = UITextField(frame: self.creditEmailCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        creditEmailCell.isUserInteractionEnabled = false
        self.creditEmailTextField.text = "hannibal.seif.tech.99@gmail.com"
        self.creditEmailCell.addSubview(self.creditEmailTextField)
        self.creditEmailTextField.frame = CGRect(x: self.creditEmailTextField.frame.minX*screenWidth, y: self.creditEmailTextField.frame.minY*screenHeight, width: 400*screenWidth, height: self.creditEmailTextField.frame.height*screenHeight)
        
        self.logOutCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.logOutCell.addSubview(self.logOutButton)
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 20)
        logOutButton.frame = logOutCell.frame
        logOutButton.frame = CGRect(x: 0, y: logOutButton.frame.minY, width: screen.width, height: logOutButton.frame.height)
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    @ objc func logOut(){
        do {
            _ = try Auth.auth().signOut()
            uid = ""
            nOfMyUsers = 0
            self.dismiss(animated: true, completion: nil)
        } catch  {
            print("Not me error")
        }
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        navbarSetter()
        setUpCells()
        
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.tableFooterView = UIView()
    }
    
    func navbarSetter(){
        
        view.addSubview(navBar)
        view.addSubview(navBarTitle)
    
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        navBar.heightAnchor.constraint(equalToConstant: 80*screenHeight).isActive=true
        
        navBarTitle.centerXAnchor.constraint(equalTo: navBar.centerXAnchor).isActive=true
        navBarTitle.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 9*screenWidth).isActive=true
        navBarTitle.widthAnchor.constraint(equalToConstant: 250*screenWidth).isActive=true
        navBarTitle.heightAnchor.constraint(equalToConstant: 40*screenHeight).isActive=true
        
        view.addSubview(returnButton)
        returnButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 13*screenWidth).isActive=true
        returnButton.heightAnchor.constraint(equalToConstant: 40*screenHeight).isActive=true
        returnButton.widthAnchor.constraint(equalToConstant: 80*screenWidth).isActive=true
        returnButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor, constant: 9*screenHeight).isActive=true
        returnButton.addTarget(self, action: #selector(reti), for: .touchUpInside)
        
        view.addSubview(tableView)
        hideKeyboardWhenTappedAround()
        
    }
    
    @ objc func reti(){
        guard Int(numberOfUserTextField2.text!) != nil else {
            self.dismiss(animated: true, completion: nil); return
        }
        if Int(numberOfUserTextField2.text!)!<6,Int(numberOfUserTextField2.text!)!>0{
            nOfMyUsers = Int(numberOfUserTextField2.text!)!
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text : String?
        switch section {
        case 1:
            text = "Contact developer"
        default:
            break
        }
        return text
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var i = 0
        switch section {
        case 0:
            i = 1
        case 1:
            i = 1
        case 2:
            i = 1
        default:
            break
        }
        return i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        switch indexPath.section {
        case 0:
            cell = numberOfUserCell
        case 1:
            cell = creditEmailCell
        case 2:
            cell = logOutCell
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    
}
