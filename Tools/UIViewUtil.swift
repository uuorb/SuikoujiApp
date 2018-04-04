//
//  extension.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/24.
//  Copyright © 2018年 hpy. All rights reserved.
//
import UIKit
import Foundation


extension UIView{
    @IBInspectable
    var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var shadowRadius:CGFloat {
        get{
            return layer.shadowRadius
        }
        set{
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOpacity: Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowColor:UIColor? {
        get{
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        set{
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return  layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
}

