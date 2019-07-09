//
//  myBookedRidesCellCollectionViewCell.swift
//  gonshare
//
//  Created by SEIF EL FREJ ISMAIL on 08/05/2019.
//  Copyright © 2019 SEIF EL FREJ ISMAIL. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreLocation
import Foundation

class myBookedRidesCellCollectionViewCell: BaseCell {
    
    
    let personImage : UIImageView = {
        let im = UIImageView()
        im.tintColor = nil
        im.translatesAutoresizingMaskIntoConstraints=false
        return im
    }()
    
    let joinButton : UIButton = {
        let but = UIButton(type: .roundedRect)
        but.backgroundColor = UIColor(red: 220/255, green: 0/255, blue: 60/255, alpha: 1)
        but.layer.cornerRadius = 7
        but.setTitle("Directions", for: .normal)
        but.setTitleColor(UIColor.white, for: .normal)
        but.translatesAutoresizingMaskIntoConstraints=false
        
        return but
    }()
    
    let fullImageView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        
        v.layer.cornerRadius = 7
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.black.cgColor
        
        return v
    }()
    
    let lineSeparator : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    let emptyImageView : UIView = {
        let v = UIView()
        return v
    }()
    
    
    let personWaitingLabel : UILabel = {
        let lab = UILabel()
        lab.text = ""
        lab.font = UIFont(name: "Roboto-Bold", size: lab.font.pointSize - 3)
        lab.translatesAutoresizingMaskIntoConstraints=false
        //lab.backgroundColor = UIColor.red
        return lab
    }()
    
    let dateLabel : UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = UIColor.black
        l.font = UIFont(name:"DINAlternate-Bold", size: l.font.pointSize + 2)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints=false
        return l
    }()
    
    let pricePerPersonLabel : UITextField = {
        let lab = UITextField()
        lab.text = ""
        
        lab.font = UIFont(name: "Avenir-BookOblique", size: lab.font!.pointSize - 1)
        lab.textColor = UIColor(red: 61/255, green: 81/255, blue: 181/255, alpha: 1)
        //lab.backgroundColor = UIColor.red
        //lab.adjustsFontSizeToFitWidth = true
        lab.isSecureTextEntry = false
        lab.textAlignment = .center
        
        lab.translatesAutoresizingMaskIntoConstraints=false
        return lab
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        
        
        personImage.image = UIImage(named: "people_gonshare")
        
        
        addSubview(joinButton)
        addSubview(fullImageView)
        addSubview(personWaitingLabel)
        addSubview(personImage)
        addSubview(lineSeparator)
        
        
        addButtonConstraint()
        addFullViewConstraint()
        addPersonWaitingConstraint()
        addImageConstraint()
        //setGradientBackground()
        
        joinButton.addTarget(self, action: #selector(assignDirectionSTationName), for: .touchUpInside)
        
        
    }
    
    
    
    
    
    @ objc func assignDirectionSTationName() {
        let text = dateLabel.text!
        let index = text.index(text.startIndex, offsetBy: 19)
        directionStationName = String(text.suffix(from: index))
        isGivingDirections = true
        NotificationCenter.default.post(name: NSNotification.Name("getDirections"), object: nil)
    }
    
    
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        
        let image = UIImage(named: "people_gonshare")
        let rawImageRef: CGImage = (image?.cgImage!)!
        
        let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
        UIGraphicsBeginImageContext(image!.size);
        
        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0,y: image!.size.height)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: image!.size.width, height: image!.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result
        
    }
    
    
    
    func addButtonConstraint(){
        joinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10*screenHeight).isActive=true
        joinButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14*screenWidth).isActive=true
        joinButton.widthAnchor.constraint(equalToConstant: 99*screenWidth).isActive=true
        joinButton.heightAnchor.constraint(equalToConstant: 50*screenHeight).isActive=true
    }
    
    
    func addFullViewConstraint(){
        fullImageView.widthAnchor.constraint(equalToConstant: 250*screenWidth).isActive=true
        fullImageView.heightAnchor.constraint(equalToConstant: 50*screenHeight).isActive=true
        fullImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10*screenHeight).isActive=true
        fullImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25*screenWidth).isActive=true
    }
    
    
    func addPersonWaitingConstraint(){
        personWaitingLabel.widthAnchor.constraint(equalToConstant: 380*screenWidth).isActive=true
        personWaitingLabel.heightAnchor.constraint(equalToConstant: 50*screenHeight).isActive=true
        personWaitingLabel.bottomAnchor.constraint(equalTo: fullImageView.topAnchor, constant: -6*screenHeight).isActive=true
        personWaitingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 57*screenWidth).isActive=true
        
        lineSeparator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        lineSeparator.heightAnchor.constraint(equalToConstant: 1*screenHeight).isActive=true
        lineSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 6*screenHeight).isActive=true
        lineSeparator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        
        self.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(equalTo: personWaitingLabel.topAnchor).isActive=true
        dateLabel.widthAnchor.constraint(equalToConstant: 300*screenWidth).isActive=true
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        dateLabel.bottomAnchor.constraint(equalTo: personWaitingLabel.centerYAnchor, constant: 1*screenHeight)
        
        self.addSubview(pricePerPersonLabel)
        personWaitingLabel.addSubview(pricePerPersonLabel)
        
        pricePerPersonLabel.widthAnchor.constraint(equalToConstant: 140*screenWidth).isActive=true
        pricePerPersonLabel.heightAnchor.constraint(equalToConstant: 50*screenHeight).isActive=true
        pricePerPersonLabel.bottomAnchor.constraint(equalTo: fullImageView.topAnchor, constant: 6*screenHeight).isActive=true
        pricePerPersonLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
    }
    
    func addImageConstraint(){
        personImage.widthAnchor.constraint(equalToConstant: 29*screenWidth).isActive=true
        personImage.heightAnchor.constraint(equalToConstant: 29*screenHeight).isActive=true
        personImage.centerYAnchor.constraint(equalTo: personWaitingLabel.centerYAnchor, constant: 12*screenHeight).isActive=true
        personImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20*screenWidth).isActive=true
        
    }
    
    
    
    
    
    
    
    
    
    
}



