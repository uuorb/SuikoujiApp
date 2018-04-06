//
//  DataModel.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/4/3.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
class DataModel: NSObject{
    
    var anchoredItems = [AnchoredItem]()
    
    override init(){
        super.init()
        print("数据文件路径：\(dataFilePath())")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(anchoredItems, forKey: "itemList")
    }
    
    func saveData() {
        print("saved")
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(anchoredItems, forKey: "itemList")
        archiver.finishEncoding()
        
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadData() {
        let path = self.dataFilePath()
        
        let defaultManager = FileManager()
        if defaultManager.fileExists(atPath: path) {
            //读取文件数据
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            anchoredItems = unarchiver.decodeObject(forKey: "itemList") as! Array
            unarchiver.finishDecoding()
        }
    }
    
    func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    func dataFilePath ()->String {
        return self.documentsDirectory().appendingFormat("/itemList.plist")
    }
}
