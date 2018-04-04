//
//  PayViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/29.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
import LTMorphingLabel

class PayViewController: UIViewController, LTMorphingLabelDelegate {
    @IBOutlet weak var tmpLabel1: LTMorphingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        returnHomePageButton.layer.cornerRadius = returnHomePageButton.frame.size.height / 2
        tmpLabel1.delegate = self
        tmpLabel1.text = "abcd"
        tmpLabel1.morphingEffect = .fall
        tmpLabel1.textColor = UIColor.black
        tmpLabel1.backgroundColor = myPinkColor
    }
    
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        let string = tmpLabel1.text! + ".."
        tmpLabel1.text = string
    }
    
    @IBOutlet weak var returnHomePageButton: UIButton!
    

}
