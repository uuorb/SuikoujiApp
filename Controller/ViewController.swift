//
//  ViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/24.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
import Speech
import BetterSegmentedControl
import AVFoundation
import AudioToolbox
import TransitionTreasury
import TransitionAnimation
import LTMorphingLabel
import SwipeCellKit
import MRefresh

enum MeowStatu {
    case PAW
    case BODY
}

class ViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource,LTMorphingLabelDelegate ,UIViewControllerTransitioningDelegate, SwipeTableViewCellDelegate, UIViewControllerPreviewingDelegate, ModalTransitionDelegate{
    var dataModel = DataModel()

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        var indexPath = tableView.indexPath(for: previewingContext.sourceView as! UITableViewCell)!
        let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "PopImageViewController") as! PopImageViewController
        if (dataModel.anchoredItems[indexPath.section].isPhoto()){
            favoriteViewController.popImage = UIImage(contentsOfFile: NSHomeDirectory().appending("/Documents/").appending("imageDate"))!
        }else{
            return nil
        }
        return favoriteViewController
    }
    
    @IBOutlet weak var test: NSLayoutConstraint!
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        var indexPath = tableView.indexPath(for: previewingContext.sourceView as! UITableViewCell)!
        if (dataModel.anchoredItems[indexPath.section].isPhoto()){
            let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
            let fullPath = NSHomeDirectory().appending("/Documents/").appending("imageDate")
            let savedImage = UIImage(contentsOfFile: fullPath)!
            favoriteViewController.popImage = savedImage
            favoriteViewController.nameLabelString = dataModel.anchoredItems[indexPath.section].getItemName()
            navigationController?.tr_pushViewController(favoriteViewController, method: TRPushTransitionMethod.fade)
        }
    }

    
    @IBOutlet weak var topView: UIView!
    var meowPlayer: AVAudioPlayer?
    var meowIsHidden = true
    var nowInt:UInt = 0
    var toWhere = ""
    
    @IBOutlet weak var imageTake: UIImageView!
    
    @IBOutlet weak var segmentView: BetterSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn2_TraillingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn2_BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn3_BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn3_TrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn0_TraillingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn0_BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn1_TraillingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn1_BottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var meowBtn: UIButton!

    var btn2InitX:CGFloat = 0
    var btn2InitY:CGFloat = 0
    var nowDeltaX:CGFloat = 0
    
    var testDate = RandomString()
    
    var titles:[String] = ["物品", "出门", "逛超市" , "设置"]

    var control = BetterSegmentedControl()
    var testDataCount = 5
    let tmpLabel = LTMorphingLabel()
    var tableHeaderView = TableViewHeaderView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    

    @IBOutlet weak var tableviewPullLabel: UILabel!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!

    override func viewWillLayoutSubviews() {
        setShadowWithCorner(addButton)
        setShadowWithCorner(settingButton)
        setShadowWithCorner(searchButton)
        setShadowWithCorner(payButton)
    }
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    
    func present() {
        let vc = PayViewController()
        vc.modalDelegate = self // Don't forget to set modalDelegate
        tr_presentViewController(vc, method: TRPresentTransitionMethod.twitter, completion: {
            print("Present finished.")
        })
    }

    func handlePullDownSuccess(){
        self.tableView.stopAnimating()
    }
    
    var flag = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset
        if(offset.y < -100){
            print(offset)
        }
        print(flag)
//
        if (offset.y < -100){
            tableView.contentOffset.y = -100
        }
        
        if (flag == false && offset.y <= -100 && scrollView.isDragging){
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            flag = true
        }
        
        if (flag == true && offset.y > -80 && !scrollView.isDragging ){
            flag = false
            self.present()
        }
    }
    
    var indicatorControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.loadData()
        
//        let customSubview = UIView(frame: CGRect(x: -10, y: 40, width: 40, height: 4.0))
//        customSubview.backgroundColor = .black
//        customSubview.layer.cornerRadius = 2.0
//        customSubview.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
//        segmentView.autoresizingMask = [.flexibleWidth]
//        segmentView.addSubviewToIndicator(customSubview)
//        segmentView.titles = titles
//        segmentView.backgroundColor = myBlueColor
//        segmentView.selectedTitleColor = myBlueColor
        indicatorControl = BetterSegmentedControl(
            frame: CGRect(x: 0.0, y: 0, width: view.bounds.width, height: 50.0),
            titles: titles,
            index: 0, options: [.backgroundColor(myBlueColor),
                                .titleColor(.lightGray),
                                .indicatorViewBorderColor(.white),
                                .selectedTitleColor(.white),
                                .bouncesOnChange(false),
                                .panningDisabled(false)])
        indicatorControl.autoresizingMask = [.flexibleWidth]
        let customSubview = UIView(frame: CGRect(x: 0, y: 40, width: 40, height: 4.0))
        customSubview.backgroundColor = .white
        customSubview.layer.cornerRadius = 2.0
        customSubview.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        indicatorControl.addSubviewToIndicator(customSubview)
        topView.addSubview(indicatorControl)
        
        
        
        
        
        
        let size = CGSize(width: 25.0, height: 25.0)

        let pathConfiguration = PathConfiguration(lineWidth: 3.0,
                                                  strokeColor: myDarkGrayColor)
        let pathManager = defaultPathManager(size: size)

        let pullView = MRefreshAnimatableView(frame: CGRect(origin: CGPoint.zero,
                                                        size: size),
                                          pathManager: pathManager,
                                          pathConfiguration: pathConfiguration)
        
        let refreshConfiguration = MRefreshConfiguration(heightIncrease: 30.0,
                                                         animationEndDistanceOffset: 35.0,
                                                         animationStartDistance: 18.0,
                                                         contentInsetChangeAnimationDuration: 0.2)
        tableView.addPullToRefresh(animatable: pullView,
                                   configuration: refreshConfiguration) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                        self.handlePullDownSuccess()
                                    })
        }
        
        tableView.backgroundColor = .clear
        self.tableView.allowsMultipleSelection = false
        setStatusBarBackgroundColor(color: myBlueColor)
        UIApplication.shared.statusBarStyle = .lightContent
        
        //猫叫
        do{
            meowPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "meowSound", ofType: "wav")!))
            meowPlayer?.enableRate = true
            meowPlayer?.rate = 2.0
            meowPlayer?.volume = 0.2
        }catch{}
        
        initStatu()
        
        tableView.delegate = self
        tableView.dataSource = self
        //table的分割线设置为无
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        topView.backgroundColor = myBlueColor
  
        self.view.backgroundColor = myBlueColor
    }
    
    func defaultPathManager(size: CGSize) -> SVGPathManager {
        let svg1 = "M 176.5,98 C 206.6,98 231,122.41 231,152.53 L 231,273.47 C 231,303.59 206.6,328 176.5,328 146.4,328 122,303.59 122,273.47 L 122,152.53 C 122,122.41 146.4,98 176.5,98 Z M 176.5,98"
        let svg2 = "M 77,327 C 77,327 127,374 177,374 227,374 277,327 277,327"
        let svg3 = "M 177.5,373.5 L 177.5,416.5"
        
        let firstConfiguration: ConfigurationTime = (time: 0.0,
                                                     configuration: SVGPathConfiguration(path: svg1,
                                                                                         timesSmooth: 3,
                                                                                         drawableFrame: CGRect(origin: CGPoint.zero, size: size)))
        let secondConfiguration: ConfigurationTime = (time: 0.3,
                                                      configuration: SVGPathConfiguration(path: svg2,
                                                                                          timesSmooth: 3,
                                                                                          drawableFrame: CGRect(origin: CGPoint.zero, size: size)))
        let thirdConfiguration: ConfigurationTime = (time: 0.3,
                                                     configuration: SVGPathConfiguration(path: svg3,
                                                                                         timesSmooth: 3,
                                                                                         drawableFrame: CGRect(origin: CGPoint.zero, size: size)))
        
        let pathManager = try! SVGPathManager(configurationTimes: [firstConfiguration,secondConfiguration,thirdConfiguration],
                                              shouldScaleAsFirstElement: true)
        
        return pathManager
    }


        
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: myBlueColor)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initStatu(){
        initAddBtn()
        initSettingBtn()
        initSearchBtn()
        initPayBtn()
    }
    
    func initAddBtn(){
        addButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        addButton.imageEdgeInsets = UIEdgeInsetsMake(addButton.bounds.height/3, addButton.bounds.width/3, addButton.bounds.height/2.3, addButton.bounds.width/2.3)
        addButton.addTarget(self, action: #selector(btnFeedBack), for: UIControlEvents.touchUpInside)
        //UIEdgeInsetsMake(top, left, bottom, right)
    }
    
    //给button添加震动效果
    @objc func btnFeedBack(){
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func initSettingBtn(){
        settingButton.setImage(#imageLiteral(resourceName: "next"), for: UIControlState.normal)
        settingButton.imageEdgeInsets = UIEdgeInsetsMake(19, 19, 19, 19)
    }
    
    func initSearchBtn(){
        searchButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(20, 19, 20, 19)
    }
    
    func initPayBtn(){
        payButton.addTarget(self, action: #selector(btnFeedBack), for: UIControlEvents.touchUpInside)
        payButton.setImage(#imageLiteral(resourceName: "money"), for: .normal)
        payButton.imageEdgeInsets = UIEdgeInsetsMake(19, 19, 19, 19)
        btn2_BottomConstraint.constant = addButton.center.y - settingButton.center.y - payButton.bounds.height/2
        btn2_TraillingConstraint.constant = addButton.center.x - searchButton.center.x - payButton.bounds.width/2
        btn2InitX = btn2_TraillingConstraint.constant
        btn2InitY = btn2_BottomConstraint.constant
    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (meowIsHidden){
            pawChangeStatu(statu:MeowStatu.BODY)
        }else{
            
        }
    }
    
    @IBAction func meowClickedListener(_ sender: UIButton) {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        btn0_TraillingConstraint.constant = -40
        btn0_BottomConstraint.constant = 40
        
        btn1_BottomConstraint.constant = 0
        btn1_TraillingConstraint.constant = 15
        btn3_BottomConstraint.constant = 15
        btn3_TrailingConstraint.constant = 0
        btn2_TraillingConstraint.constant = btn2InitX
        btn2_BottomConstraint.constant = btn2InitY
        
        meowBottomConstraint.constant = -150
        
        UIView.animate(withDuration: 0.6, animations: {
            //Key - view
            self.view.layoutIfNeeded()
        }, completion: {_ in
           self.meowIsHidden = true
        })
    }
    
    @IBOutlet weak var meowBottomConstraint: NSLayoutConstraint!
    func pawChangeStatu(statu: MeowStatu){
        switch statu {
        case .BODY:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            meowPlayer?.play()

            self.meowIsHidden = false
            btn0_TraillingConstraint.constant -= 120
            btn0_BottomConstraint.constant += 120
            
            btn2_BottomConstraint.constant -= 140
            btn2_TraillingConstraint.constant -= 140
            
            btn3_BottomConstraint.constant += 60
            btn3_TrailingConstraint.constant -= 140
            
            btn1_BottomConstraint.constant -= 140
            btn1_TraillingConstraint.constant += 60
            
            meowBottomConstraint.constant = -80
            UIView.animate(withDuration: 1, animations: {
                //Key - view
                self.view.layoutIfNeeded()
            }, completion: {_ in
            })
            
            break
        case .PAW:
            break
        }
    }
    
    ///设置状态栏背景颜色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView

        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    @objc func controlValueChanged(_ sender: BetterSegmentedControl){
        print(sender.index)
    }
    
    func nextInt() -> UInt{
        nowInt = indicatorControl.index
        if (nowInt + 1 > titles.count - 1){
            return 0
        }else{
            return nowInt + 1
        }
    }
    func previousInt() -> UInt{
        nowInt = indicatorControl.index
        if (nowInt == 0){
            return UInt(titles.count - 1)
        }else{
            return nowInt - 1
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        do{
            nowInt = nextInt()
            try indicatorControl.setIndex(nowInt)
        }catch{
            
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        do{
            nowInt = previousInt()
            try indicatorControl.setIndex(nowInt)
        }catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.anchoredItems.count
    }

    //高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView (_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func getMarkImageByColor(_ color: MarkColor) -> UIImage{
        switch color {
        case .orange:
            return #imageLiteral(resourceName: "star-orange")
        case .blue:
            return #imageLiteral(resourceName: "star-blue")
        default:
            return #imageLiteral(resourceName: "star-red")
        }
    }
    
    //处理左滑mark
    func handleMark(at indexPath: IndexPath,color: MarkColor){
        let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
        let itemModel = dataModel.anchoredItems[indexPath.section]
        let markedImageView = cell.viewWithTag(9) as! UIImageView
        let numberLabel = cell.viewWithTag(10) as! UILabel
        
        if(itemModel.getIsMark() && itemModel.getMarkColor() == color){
            itemModel.setMark(false)
            UIView.animate(withDuration: 0.5, animations: {
                let trans1 = CGAffineTransform.init(rotationAngle: 0)
                markedImageView.transform = trans1.scaledBy(x: 0.5, y: 0.5)
                markedImageView.image = self.getMarkImageByColor(itemModel.getMarkColor())
                markedImageView.alpha = 0
                numberLabel.alpha = 1
            }, completion:{_ in })
        }else{
            itemModel.setMarkColor(color: color)
            itemModel.setMark(true)
            numberLabel.alpha = 0
            markedImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            markedImageView.image = getMarkImageByColor(itemModel.getMarkColor())
            UIView.animate(withDuration: 0.5, animations: {
                let trans1 = CGAffineTransform(scaleX: 0.7, y: 0.7)
                markedImageView.transform = trans1.rotated(by: CGFloat.pi * 0.789)
                markedImageView.alpha = 1
            })
        }
        print(itemModel.getIsMark())
        tableView.endUpdates()
        self.dataModel.saveData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            tableView.beginUpdates()
            let orange = SwipeAction(style: .default, title: nil) { action, indexPath in
                self.handleMark(at: indexPath,color: .orange)
            }
            
            let red = SwipeAction(style: .default, title: nil) { action, indexPath in
                self.handleMark(at: indexPath,color: .red)
            }
            
            let blue = SwipeAction(style: .default, title: nil) { action, indexPath in
                self.handleMark(at: indexPath,color: .blue)
            }
            
            orange.image = #imageLiteral(resourceName: "star")
            blue.image = #imageLiteral(resourceName: "star")
            red.image = #imageLiteral(resourceName: "star")
            
            orange.hidesWhenSelected = true
            red.hidesWhenSelected = true
            blue.hidesWhenSelected = true

            orange.font = .systemFont(ofSize: 7)
            orange.transitionDelegate = ScaleTransition.default
            orange.backgroundColor = myOrangeColor
            red.backgroundColor = UIColor.red
            blue.backgroundColor = myBlueColor
            return [orange,red,blue]
        } else{
            guard orientation == .right else { return nil }
            let cell = tableView.cellForRow(at: indexPath) as! SwipeTableViewCell
            let itemModel = dataModel.anchoredItems[indexPath.section]

            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
                // handle action by updating model with deletion
                //view中删除
                tableView.beginUpdates()
//                销毁
                itemModel.delete()
                action.fulfill(with: .delete)
                self.dataModel.anchoredItems.remove(at: indexPath.section)
                self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                tableView.endUpdates()
                
                self.dataModel.saveData()
            }
            
            let modifyAction = SwipeAction(style: .destructive, title: "修改") { action, indexPath in
                action.fulfill(with: .reset)
//                action.hidesWhenSelected = true
            }
            
            let hideClosure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            let alertCheckClosure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            let alertMatainClosure: (UIAlertAction) -> Void = { _ in cell.hideSwipe(animated: true) }
            
            let alertAction = SwipeAction(style: .destructive, title: "响铃") { action, indexPath in
                let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(title: "查看位置", style: .default, handler: alertCheckClosure))
                controller.addAction(UIAlertAction(title: "持续响铃", style: .default, handler: alertMatainClosure))
                controller.addAction(UIAlertAction(title: "取消", style: .default, handler: hideClosure))
                self.present(controller, animated: true, completion: nil)
            }
            
            // customize the action appearance
                alertAction.backgroundColor = myBlueColor
                modifyAction.backgroundColor = myOrangeColor
                return [deleteAction,modifyAction,alertAction]
            }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .fill
            options.maximumButtonWidth = orientation == .left ? self.view.bounds.width / 8 : self.view.bounds.width / 6
        options.minimumButtonWidth = orientation == .left ? self.view.bounds.width / 8 : self.view.bounds.width / 6
        return options
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusedCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let itemModel = dataModel.anchoredItems[indexPath.section]
        let backgroundView = cell.viewWithTag(12)!
        backgroundView.backgroundColor = UIColor.white
        backgroundView.cornerRadius = 5
        backgroundView.layer.shadowColor =  myDarkGrayColor.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: -1, height: 1)
        backgroundView.layer.shadowRadius = 2.5
        backgroundView.layer.shadowOpacity = 0.5
        
        let numberLabel = cell.viewWithTag(10) as! UILabel
        let itemLabel = cell.viewWithTag(11) as! UILabel
        let localLabel = cell.viewWithTag(13) as! UILabel
        let underLineLabel = cell.viewWithTag(15) as! UILabel
        let markedImageView = cell.viewWithTag(9) as! UIImageView

        if (itemModel.isPhoto()){
            //注册3dTouch
            registerForPreviewing(with: self, sourceView: cell)
            
            let underLineCharacter = "_"
            var underLine = ""            
            for _ in 0...(itemModel.getLocal().count*2)  {
                underLine += underLineCharacter
                underLineLabel.text = underLine
            }
        }
        //显示标记
        if(itemModel.getIsMark()){
            markedImageView.image = getMarkImageByColor(itemModel.getMarkColor())
            markedImageView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            markedImageView.alpha = 1
            numberLabel.alpha = 0
        }else{
            markedImageView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
            markedImageView.alpha = 0
            numberLabel.alpha = 1

        }

//        numberLabel.text = String.init( indexPath.section + 1)
        localLabel.text = dataModel.anchoredItems[indexPath.section].getLocal()
        itemLabel.text = dataModel.anchoredItems[indexPath.section].getItemName()
        return cell
    }
    
    
    @IBOutlet weak var btn1: UIButton!
    //按
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //button按下时，改变颜色
    @IBAction func allBtnTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor.init(colorWithHexValue: 0x515151)
    }
    
    //button抬起时，改变颜色
    @IBAction func allBtnTouchUp(_ sender: UIButton) {
        sender.backgroundColor = myBlueColor
    }
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        imageTake.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let imageData = UIImageJPEGRepresentation(imageTake.image!, 1) as NSData? {
            //用哈希值
            let name = String.init(imageTake.image!.hash)
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(name)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }

    @IBAction func btn2Action(_ sender: UIButton) {
        dataModel.anchoredItems.insert(AnchoredItem(itemName: testDate.randomItem(), localName:  testDate.randomLocation()), at: 0)
        tableView.reloadData()
        dataModel.saveData()
    }
    
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func jumpToAddView(_ sender: UIButton) {
        /*
         
        UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        let fullPath = NSHomeDirectory().appending("/Documents/").appending("imageDate")
        if let savedImage = UIImage(contentsOfFile: fullPath) {
            self.imageTake.image = savedImage
        } else {
            print("文件不存在")
        }
        */
        
        //截屏
//        let imageView = UIImageView(image: captureScreen())
//        imageView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
//        self.view.addSubview(imageView)
        
        let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemsViewController") as! AddItemsViewController
        navigationController?.tr_pushViewController(second, method: TRPushTransitionMethod.page)
    }

    func setShadowWithCorner(_ btn:UIButton){
        btn.backgroundColor = myBlueColor
        let shorterSide = min(btn.frame.size.width, btn.frame.size.height);
        btn.layer.cornerRadius = shorterSide / 2
        btn.clipsToBounds = true
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.5
        btn.layer.masksToBounds = false //key
        btn.layer.shadowOffset = CGSize(width: -5, height: 0)
        let btnColor = btn.backgroundColor?.cgColor //key
        btn.backgroundColor = nil
        btn.layer.backgroundColor =  btnColor
    }

}

