//
//  ImagePreviewViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/4/3.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
import TransitionAnimation
import TransitionTreasury

class ImagePreviewViewController: UIViewController, NavgationTransitionable{
    var tr_pushTransition: TRNavgationTransitionDelegate?
    
    
    var popImage = UIImage()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    var nameLabelString = ""
   
    override func viewWillAppear(_ animated: Bool) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backImageView.image = popImage
        nameLabel.text = nameLabelString
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        edgeGesture.edges = .left
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(edgeGesture)
    }
    
    @objc func handleGesture(_ sender: Any){
         pop()
    }
    
    func pop() {
        _ = navigationController?.tr_popViewController()
    }
    
}
