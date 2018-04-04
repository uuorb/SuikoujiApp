//
//  randomString.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/28.
//  Copyright © 2018年 hpy. All rights reserved.
//

import Foundation
class RandomString {
    let items = ["钥匙","手机","钱包","身份证","银行卡","包子","昨天的外套","平板电脑","耳机","鞋子"]
    let location = ["床上","进门的柜子","微波炉","厨房","沙发上","阳台上","卫生间","一串超级超级超级超级超级超级超级超级超级长的字符串"]
    
    public func randomItem() -> String{
        return items[Int(arc4random() % UInt32(items.count - 1)) + 1]
    }
    
    public func randomLocation() -> String{
        return location[Int(arc4random() % UInt32(location.count - 1)) + 1]
    }


}





