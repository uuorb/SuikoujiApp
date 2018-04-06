//
//  PayViewController.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/29.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit
import TransitionAnimation
import TransitionTreasury
import Shimmer

class PayViewController: UIViewController{
    var listeningTimer:Timer!
    var leftRound = UIView()
    var rightRound = UIView()
    
    var waitingTime:Int = 0
    var textLabel: UILabel!
    var textLabel1: UILabel!
    weak var modalDelegate: ModalViewControllerDelegate?
    @objc func test(){
        dismiss()
    }
    func dismiss() {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        listeningTimer = Timer.scheduledTimer(
            timeInterval: 1.2,target:self,selector:#selector(listeningAnimation),userInfo:nil,repeats:true)
        listeningTimer.fire()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = myBlueColor
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(test))
        swipeGesture.direction = .down
        
        self.view.addGestureRecognizer(swipeGesture)
    
//        textLabel = UILabel(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y + 55, width: 200, height: 50))
        
        
        
        let animateView = UIView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 70, width: 100, height: 100))
       
        leftRound = UIView(frame: CGRect(x: 30 - 10, y: 40 - 10, width: 17, height: 17))
        rightRound = UIView(frame: CGRect(x: 50 + 10, y: 40 + 10, width: 17, height: 17))
       
        leftRound.cornerRadius = leftRound.bounds.height / 2
        rightRound.cornerRadius = rightRound.bounds.height / 2
        leftRound.backgroundColor = .white
        rightRound.backgroundColor = .white

        animateView.backgroundColor = .clear
        animateView.addSubview(leftRound)
        animateView.addSubview(rightRound)
        
        let shimmeringView = FBShimmeringView(frame: self.view.bounds)
        textLabel = UILabel(frame: shimmeringView.bounds)
        textLabel1 = UILabel(frame: shimmeringView.bounds)
        
        shimmeringView.center.y += 80
        
        textLabel.textColor = .white
        textLabel.text = "Listening..."
        textLabel.textAlignment = .center
        textLabel.cornerRadius = 5
        textLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        shimmeringView.addSubview(textLabel)
        
        shimmeringView.isShimmering = true
        shimmeringView.contentView = textLabel
        
        self.view.addSubview(shimmeringView)
        self.view.addSubview(animateView)
        
    }
    
    @objc func listeningAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
            self.leftRound.center.y += 20
            self.rightRound.center.y -= 20}, completion: {_ in
            UIView.animate(withDuration: 0.6 , delay: 0, options: [],
                           animations: {
                            self.leftRound.center.y -= 20;
                            self.rightRound.center.y += 20
            })
        })
    }

    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
    }
    
    
    @IBOutlet weak var returnHomePageButton: UIButton!
    

}
