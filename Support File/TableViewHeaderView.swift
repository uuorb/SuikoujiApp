//
//  TableViewHeaderView.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/4/5.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit

class TableViewHeaderView: UIView {
     var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("infinite loop")
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        

        self.backgroundColor = .clear
    }
}
