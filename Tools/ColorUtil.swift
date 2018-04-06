//
//  ColorUtil.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/30.
//  Copyright © 2018年 hpy. All rights reserved.
//

import Foundation
import UIKit

/*
 myColorYellow = UIColor.init(colorWithHexValue: 0xEDCDBD)
 */
extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((value & 0x0000FF)) / 255.0,
            alpha: alpha
        )
    }
}

public let myBlueColor = UIColor.init(colorWithHexValue: 0x0984e3)
//0x3498DB

public let myGreenColor = UIColor.init(colorWithHexValue: 0x2ecc71)
public let myGrayColor = UIColor.init(colorWithHexValue: 0xecf0f1)
public let myDarkGrayColor = UIColor.init(colorWithHexValue: 0x849495)
public let myLightGrayColor = UIColor.init(colorWithHexValue: 0xbdc3c7)
public let myLightGreen = UIColor.init(colorWithHexValue: 0x55efc4)
public let myYellowColor = UIColor.init(colorWithHexValue: 0xfdcb6e)
public let myPinkColor = UIColor.init(colorWithHexValue: 0xfd79a8)
public let myOrangeColor = UIColor.init(colorWithHexValue: 0xffaf40)
public let myPurpleColor = UIColor.init(colorWithHexValue: 0x7158e2)
