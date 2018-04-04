//
//  SearchView.swift
//  SuiKouJiApp
//
//  Created by me293 on 2018/3/30.
//  Copyright © 2018年 hpy. All rights reserved.
//

import UIKit

class SearchView: UIView {
    let screenSize = UIScreen.main.bounds
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setColor(_ color:UIColor){
        self.shapeLayer.fillColor = color.cgColor
    }
    
    func setup() {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        // Create a CAShapeLayer
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = createBezierPath().cgPath
        
        // apply other properties related to the path
        shapeLayer.strokeColor = myBlueColor.cgColor
        shapeLayer.fillColor = myBlueColor.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.position = CGPoint(x: 0, y: 0)
        
        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    
    func createBezierPath() -> UIBezierPath {
        
        // create a new path
        let path = UIBezierPath()
        
        // starting point
        path.move(to: CGPoint(x: 0, y: 0))
        
       
        // step 2: line
        path.addLine(to: CGPoint(x: screenWidth, y: 0))
        
        // step 3: line
        
        path.addLine(to: CGPoint(x: screenWidth, y: screenHeight / 8.6))

        // step 4: curve
        path.addQuadCurve(to: CGPoint(x: 0, y: screenHeight / 8.6), controlPoint: CGPoint(x: screenWidth / 2, y: screenHeight / 7.5))
        
        path.close() // draws the final line to close the path
        
        return path
    }

    
}









