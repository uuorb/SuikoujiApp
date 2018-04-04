//
//  AddItemsViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/29.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
import AudioToolbox
import LTMorphingLabel
import TextFieldEffects
import TransitionAnimation
import TransitionTreasury
import ImagePicker

/*
 |- 属性
    |-测试数据
    |-Flags
    |-Top
    |-Content
    |-Alert View
    |-TextField
    |-AddItem and AddLocal View
    |-HomePage Button
 |- IBAction
 
 |- viewDidLoad()
 |- viewDidLayoutSubviews()
 
 */


class AddItemsViewController: UIViewController, LTMorphingLabelDelegate,UITextFieldDelegate, NavgationTransitionable, UIImagePickerControllerDelegate , UINavigationControllerDelegate, ImagePickerDelegate{
    

    

    
    enum SelectStatus: Int {
        case None
        case OnlyItem
        case ItemAndLocal
    }
    
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    func pop() {
        _ = navigationController?.tr_popViewController()
    }
    
    //MARK: 测试数据
    let freqItems = ["耳机","钱包","遥控器","外套","袜子","头盔","钥匙","药"]
    let freqLocals = ["卫生间","门口的鞋柜","床上","沙发上","餐厅桌子","阳台","微波炉内","狗窝里"]
    
    //MARK: Flags
    var nowStep:SelectStatus = .None
    
    //0->啥也没选 1->就选了个物品 2-> 物品地点都选了
    //3->添加了一个
    
    //MARK: Top Variable
    let customTopView = SearchView()
    
    @IBOutlet weak var titleLabel1: LTMorphingLabel!
    @IBOutlet weak var titleLabel2: LTMorphingLabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchViewImage: UIImageView!
    @IBOutlet weak var searchView: UIView!
    
    //MARK: Content Variable
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var addButtons: [ZFRippleButton]!
    
    //MARK: Alert View
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: LTMorphingLabel!

    //MARK: TextField Variable
    @IBOutlet weak var itemTextField: HoshiTextField!
    @IBOutlet weak var localTextField: HoshiTextField!
    @IBOutlet weak var typingReturnBtnBottomConstraint: NSLayoutConstraint!
    
    //MARK: AddItem and AddLocal View
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTypingViewCenterConstraint: NSLayoutConstraint!
    //
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var localImage: UIImageView!
    @IBOutlet weak var localTypingViewCenterConstraint: NSLayoutConstraint!

    //
    @IBOutlet weak var wordLabel: UILabel!
    
    //MARK: HomePage Button
    @IBOutlet weak var homePageButton: UIButton!
    
    @IBOutlet weak var successSwitch: AIFlatSwitch!
    var photoGesture = UILongPressGestureRecognizer()
    
    //MARK: IBAction
    //手动输入时，返回按钮
    @IBAction func typingReturnAction(_ sender: UIButton) {
        returnInitStatus()
    }
    
    //跳转回首页
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        pop()
    }
    
    //有8个的 按钮
    @IBAction func freqButtonClicked(_ sender: ZFRippleButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        handleFreqBtnClicked(sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCamera()
        initColor()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        itemTextField.delegate = self
        
        titleLabel1.delegate = self
        titleLabel2.delegate = self
        alertLabel.delegate = self
        
        alertLabel.morphingEffect = .pixelate
        titleLabel1.morphingEffect = .pixelate
        titleLabel2.morphingEffect = .pixelate

        
        localTextField.delegate = self
        localTextField.returnKeyType = .done
        customTopView.shadowRadius = 5
        customTopView.shadowOpacity = 0.5
        customTopView.shadowOffset = CGSize(width: -5, height: 0)
        customTopView.shadowColor = UIColor.darkText
        self.view.addSubview(customTopView)
        itemTextField.alpha = 0
        localTextField.alpha = 0
        
        photoGesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePhotoLongPressGesture(_:)))
        photoGesture.minimumPressDuration = 0.5

        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        itemTypingViewCenterConstraint.constant = -view.bounds.width
        localTypingViewCenterConstraint.constant = view.bounds.width

        let itemViewLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOfItemView(_:)))
        itemViewLongPressGesture.minimumPressDuration = 0.2
        itemView.addGestureRecognizer(itemViewLongPressGesture)
        
        let itemViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOfItemView))
        itemView.addGestureRecognizer(itemViewTapGesture)
        itemView.isUserInteractionEnabled = true
        
        //元组for
        for (index,btn) in addButtons.enumerated() {
            btn.setTitle(freqItems[index], for: .normal)
            btn.ripplePercent = 1.0
            btn.rippleColor = btn.backgroundColor!
            btn.rippleBackgroundColor = btn.backgroundColor!
            btn.rippleOverBounds = false
        }
        
        
        alertView.backgroundColor = UIColor.black
        
        self.view.bringSubview(toFront: topView)
        homePageButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        
        setShadowWithCorner(searchView)
        setShadowWithCorner(homePageButton)
    }
    
    func initColor(){
        
        topView.backgroundColor = .clear
        titleLabel1.textColor = UIColor.white
        titleLabel2.textColor = UIColor.white
        self.homePageButton.backgroundColor = myBlueColor
        for btn in addButtons{
            btn.backgroundColor = myBlueColor
            btn.setTitleColor(UIColor.white, for: .normal)
        }
    
        self.view.backgroundColor = UIColor.white
        self.itemView.backgroundColor = myBlueColor
        self.localView.backgroundColor = myBlueColor

    }
    
    override func viewDidLayoutSubviews() {
        searchView.layer.cornerRadius = searchView.frame.size.height / 2
        homePageButton.layer.cornerRadius = homePageButton.frame.size.height / 2
        itemView.layer.cornerRadius = itemView.frame.size.height / 2
        localView.layer.cornerRadius = localView.frame.size.height / 2
    }
    

    func handleFreqBtnClicked(_ sender: ZFRippleButton){
        switch nowStep{
        case .None:
            self.titleLabel1.text = "[ 2 / 3 ] "
            self.titleLabel2.text = "常丢地点"
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.wordLabel.textColor = myPurpleColor
                    self.itemView.center.x -= self.view.bounds.width
                    self.localView.backgroundColor = myPurpleColor
                    for (index,btn) in self.addButtons.enumerated() {
                        btn.setTitle(self.freqLocals[index], for: .normal)
                        btn.backgroundColor = myPurpleColor
                        btn.rippleColor = btn.backgroundColor!
                        btn.rippleBackgroundColor = btn.backgroundColor!
                    }
                    self.homePageButton.backgroundColor = myPurpleColor
            },
                completion:{ _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.itemView.center.x += self.view.bounds.width
                        self.itemView.backgroundColor = myGreenColor
                    })}
            )
            
            self.customTopView.setColor(myPurpleColor)
            setStatusBarBackgroundColor(myPurpleColor)
            self.itemLabel.text = sender.title(for: .normal)
            self.itemLabel.textColor = UIColor.white
            self.itemImage.image = #imageLiteral(resourceName: "delete-white")
            
            UIView.transition(with: sender, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
            self.nowStep = .OnlyItem
        case .OnlyItem:
            self.titleLabel1.text = "[ 3 / 3 ]"
            self.titleLabel2.text = "确认添加"
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.localView.center.x += self.view.bounds.width
            },
                completion:{_ in
                    self.localView.backgroundColor = myGreenColor
                    UIView.animate(withDuration: 0.3, animations: {
                        self.localView.center.x -= self.view.bounds.width
                    })
            })
            
            UIView.animate(withDuration: 0.3,delay: 0.3 ,animations: {
                sender.rippleColor = myGreenColor
                sender.rippleBackgroundColor = myDarkGrayColor
            })
            
            
            sender.addGestureRecognizer(photoGesture)
            
            self.localLabel.text = sender.title(for: .normal)
            self.localLabel.textColor = UIColor.white
            self.localImage.image = #imageLiteral(resourceName: "delete-white")
            sender.backgroundColor = myGreenColor
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setTitle("轻按添加(长按拍照)", for: .normal)
            self.nowStep = .ItemAndLocal
        default:
            //如果点击了同一个，那么添加成功
            if (sender.backgroundColor ==  myGreenColor){
                returnInitStatus()
                showAlert(msg: "添加成功", duration: 0.5, completionFunc: nil)
            }else{
                //否则的话，把之前的按钮恢复，并确认第二个按钮
                for (index,btn) in addButtons.enumerated(){
                    if btn.backgroundColor == myGreenColor{
                        btn.backgroundColor = myPurpleColor
                        btn.rippleColor = btn.backgroundColor!
                        btn.rippleBackgroundColor = btn.backgroundColor!
                        btn.setTitle(freqLocals[index], for: .normal)
                        break
                    }
                }
                self.nowStep = .OnlyItem
                freqButtonClicked(sender)
            }
        }
    }
    
    
    @objc func returnToHomePage(){
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     MARK: 相机
     */
    
    var imagePicker = ImagePickerController()
    var config = Configuration()
    
    func initCamera(){
        config.doneButtonTitle = "添加"
        config.allowPinchToZoom = true
        config.cancelButtonTitle = "退出"
        config.noImagesTitle = "未打开相册访问权限"
        config.recordLocation = false
        
        config.allowVideoSelection = false
        config.allowMultiplePhotoSelection = false
        config.showsImageCountLabel = true
        
        imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
    }
    
    //按相册的那个框框
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
    }
    
    
    //添加
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        showAlert(msg: "添加成功", duration: 0.5 , completionFunc: returnInitStatus())
        
        let imageView = UIImageView(image: imageAssets[0])
        imageView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
    }
    
    //取消
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("???")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handlePhotoLongPressGesture(_ sender: UILongPressGestureRecognizer){
        print("我被长按了")
        if(nowStep != .ItemAndLocal) {return}
        
        if(sender.state == .began){
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let alertController = UIAlertController.init(title: nil, message: "没有拍照权限!", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "哦", style: .default, handler: {(alert: UIAlertAction!) in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                present(imagePicker, animated: true, completion: nil)
                imagePicker.showGalleryView()
                imagePicker.expandGalleryView()
            }
        }
    }
    
    
    @objc func handleLongPressOfItemView(_ sender: UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            self.alertView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.alertView.alpha = 0.7
            })
            itemView.shadowOpacity = 0.1
            
            alertLabel.text = "请讲!"
        case .ended:
            itemView.shadowOpacity = 0.4
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            UIView.animate(withDuration: 0.3, animations: {
                self.alertView.alpha = 0
            },completion:{_ in
                self.alertView.isHidden = true
            })
        default:
            ()
        }
        
    }
    
    ///设置状态栏背景颜色
    func setStatusBarBackgroundColor(_ color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    @objc func handleTapOfItemView(){
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if (!itemView.backgroundColor!.isEqual(myGreenColor) ){
            addItemsByTyping()
        }else{
            deleteItemLabel()
        }
    }
    
    func deleteItemLabel(){
        UIView.animate(withDuration: 0.5, animations: {
            self.itemView.center.x -= self.view.bounds.width
        },completion:{_ in self.itemView.center.x += self.view.bounds.width})
        
        returnInitStatus()
    }
    
    var flag_IsItemTextField = true
    
    //MARK: 设置TextField代理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (flag_IsItemTextField){
            localTextField.becomeFirstResponder()
            flag_IsItemTextField = false
        }else{
            flag_IsItemTextField = true
            //收起键盘
            showAlert(msg: "添加成功", duration: 0.5 , completionFunc: returnInitStatus())
            //回到初始状态
            itemTextField.text = ""
            localTextField.text = ""
        }
        return true
    }
    
    //MARK: 显示AlertView
    func showAlert(msg:String, duration: TimeInterval, completionFunc: ()? = nil){
        self.view.bringSubview(toFront: self.alertView)
        alertView.isHidden = false
        self.alertLabel.text = ""
        UIView.animate(withDuration: duration, animations: {
            self.alertView.alpha = 1
        }, completion: { _ in
            self.successSwitch.setSelected(true, animated: true)
            UIView.animate(withDuration: 0, delay: 0.2, animations:{
                self.alertLabel.text = msg
            })
            UIView.animate(withDuration: 0, delay: 1.2, animations: {
                self.alertView.alpha = 0
            }, completion: { _ in
                self.alertView.isHidden = true
                self.successSwitch.setSelected(!self.successSwitch.isSelected,animated: false)
                //外部调用闭包
                completionFunc
            })
        })
    }

    
    //MARK: TODO
    func allNeedChangeColor(_ color:UIColor){
        
    }
    
    //MARK: 恢复初始状态
    func returnInitStatus(){
        
        
        titleLabel1.text = "[ 1 / 3 ]"
        titleLabel2.text = "常丢物品"
        
        self.contentViewBottomConstraint.constant = 30
        
        itemTextField.alpha = 0
        localTextField.alpha = 0

        self.itemTypingViewCenterConstraint.constant = -self.view.bounds.height
        self.localTypingViewCenterConstraint.constant = self.view.bounds.height

        customTopView.setColor(myBlueColor)
        setStatusBarBackgroundColor(myBlueColor)

        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.white
            self.homePageButton.backgroundColor = myBlueColor

            for btn in self.addButtons{
                btn.backgroundColor = myBlueColor
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.rippleBackgroundColor = btn.backgroundColor!
                btn.rippleColor = btn.backgroundColor!
            }            
            self.wordLabel.textColor = myBlueColor
            self.itemView.backgroundColor = myBlueColor
            self.localView.backgroundColor = myBlueColor
            //移除旧的
            self.view.layoutIfNeeded()
            self.wordLabel.alpha = 1
            //显示新的
            //把键盘弄回去
            self.localTextField.resignFirstResponder()
            self.itemTextField.resignFirstResponder()

        })
        

        self.itemLabel.text = "添加物品"
        self.itemImage.image = #imageLiteral(resourceName: "voice-white")
        
        self.localLabel.text = "添加地点"
        self.localImage.image = #imageLiteral(resourceName: "voice-white")
        
        for (index,btn) in self.addButtons.enumerated() {
            btn.setTitle(self.freqItems[index], for: .normal)
        }
        
        self.titleLabel1.text = "[ 1 / 3 ]"
        self.titleLabel2.text = "常丢物品"
        
        self.nowStep = .None
        
    }
    
    //MARK: 打字增加选项
    
    func addItemsByTyping(){
        titleLabel1.text = ""
        titleLabel2.text = "手动添加"
        //移除旧的
        self.contentViewBottomConstraint.constant += self.view.bounds.height
        //显示新的
        itemTextField.alpha = 1
        localTextField.alpha = 1
        
        self.itemTypingViewCenterConstraint.constant = 0
        self.localTypingViewCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.view.layoutIfNeeded()
            self.wordLabel.alpha = 0
            //把键盘弄出来
            self.itemTextField.becomeFirstResponder()
        },completion:{_ in })
    }
    // 键盘改变
    @objc func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            //self.view.setNeedsLayout()
            //改变下约束
            self.typingReturnBtnBottomConstraint.constant = intersection.height + 10
            UIView.animate(withDuration: duration, delay: 0.0,options: UIViewAnimationOptions(rawValue: curve), animations: {self.view.layoutIfNeeded()}, completion: nil)
        }}
    func setShadowWithCorner(_ btn:UIView){
        let shorterSide = min(btn.frame.size.width, btn.frame.size.height);
        btn.layer.cornerRadius = shorterSide / 2
        btn.clipsToBounds = true
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 3
        btn.layer.shadowOpacity = 0.4
        btn.layer.masksToBounds = false //key
        btn.layer.shadowOffset = CGSize(width: -4, height: 0)
        let btnColor = btn.backgroundColor?.cgColor //key
        btn.backgroundColor = nil
        btn.layer.backgroundColor = btnColor
    }
}
