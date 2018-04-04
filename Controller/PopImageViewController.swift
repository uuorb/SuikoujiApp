//
//  PopImageViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/4/3.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit

class PopImageViewController: UIViewController {
    
    var popImage = UIImage()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = popImage        
    }

}
