//
//  AnchoredItem.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/4/2.
//  Copyright © 2018年 hpy. All rights reserved.
//

import Foundation

enum MarkColor: Int32 {
    case none,red,blue,orange
}

class AnchoredItem :NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(itemName, forKey: "itemName")
        aCoder.encode(localName, forKey: "localName")
        
        aCoder.encode(isRecorded, forKey: "isRecorded")
        aCoder.encode(isPhotoed, forKey: "isPhotoed")
        aCoder.encode(isMarked, forKey:  "isMarked")
        
        aCoder.encodeCInt(Int32(markColor.rawValue), forKey: "markColor")
        
        aCoder.encode(recordUrl, forKey:  "recordUrl")
        aCoder.encode(photoUrl, forKey:  "photoUrl")
        
        aCoder.encode(createDate, forKey:  "createDate")
        aCoder.encode(modifyDate, forKey:  "modifyDate")
    }
    
    required init(coder decoder: NSCoder) {
        self.itemName = decoder.decodeObject(forKey: "itemName") as! String
        self.localName = decoder.decodeObject(forKey: "localName") as! String
        
        self.isRecorded = decoder.decodeBool(forKey: "isRecorded")
        self.isPhotoed = decoder.decodeBool(forKey: "isPhotoed")
        self.isMarked = decoder.decodeBool(forKey: "isMarked")
        
        self.markColor = MarkColor(rawValue: Int32(decoder.decodeInteger(forKey: "markColor")))!

        self.recordUrl = decoder.decodeObject(forKey: "recordUrl") as! URL?
        self.photoUrl = decoder.decodeObject(forKey: "photoUrl") as! URL?
        
        self.createDate = decoder.decodeObject(forKey: "createDate") as! Date
        self.modifyDate = decoder.decodeObject(forKey: "modifyDate") as! Date?        
    }
    
    private var itemName: String
    private var localName: String
    
    private var isRecorded: Bool = false
    private var isPhotoed: Bool = false
    private var isMarked: Bool = false
    private var markColor: MarkColor = MarkColor.none
    
    private var recordUrl: URL?
    private var photoUrl: URL?
    
    private let createDate: Date
    private var modifyDate: Date?
    
    override init() {
        self.itemName = ""
        self.localName = ""
        self.createDate = Date() //当前时间
        self.isRecorded = false
        self.isPhotoed = false
        self.isMarked = false
        self.markColor = MarkColor.none
    }
    
    init(itemName: String, localName: String) {
        self.itemName = itemName
        self.localName = localName
        self.createDate = Date() //当前时间
        self.isRecorded = false
        self.isPhotoed = false
        self.isMarked = false
        self.markColor = MarkColor.none
    }

    /*
     Set
     */
    
    func setMarkColor(color: MarkColor){
        self.markColor = color
    }
    
    func setIsMarked(_ isMark:Bool){
        self.isMarked = isMark
    }
    func setIsRecorded(_ isRecorded:Bool){
        self.isRecorded = isRecorded
    }
    
    func setPhotoUrl(picUrl: URL){
        self.photoUrl = picUrl
    }
    
    func setRecordUrl(recordUrl: URL){
        self.recordUrl = recordUrl
    }

    
    func setIsPhotoed(_ b: Bool){
        self.isPhotoed = b
    }
    
    /*
    Get
    */
    
    func getItemName() -> String{
        return itemName
    }
    
    func getMarkColor() -> MarkColor{
        return markColor
    }

    
    func getLocal() -> String{
        return localName
    }
    func getIsMark() -> Bool{
        return isMarked
    }
    
    /*
     Delete
     把本地录音和相片删除
    */
    func delete(){
        let f = FileManager()
        if (isPhotoed){
            do{
                try f.removeItem(at: photoUrl!)
            }catch{}
        }
        if (isRecorded){
            do{
                try f.removeItem(at: recordUrl!)
            }catch{}
        }
    }
    
    func isPhoto() -> Bool{
        return isPhotoed
    }
    
    func printAll(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full

        print("itemName = \(itemName) , localName = \(localName) , createDate = \(dateFormatter.string(from: createDate))")
    }

}
