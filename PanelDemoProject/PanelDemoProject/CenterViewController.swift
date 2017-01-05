//
//  CenterViewController.swift
//  PanelDemoProject
//
//  Created by Andrew on 2017-01-05.
//  Copyright © 2017 Walzy. All rights reserved.
//

import UIKit

class CenterViewController: SwiftyCamViewController {
    
    var cameraButton: UIButton!
    var leftButton: UIButton!
    var rightButton: UIButton!
    var delegate: PanelViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 35.0, y: view.frame.height - 100, width: 70, height: 70))
        cameraButton.setImage(#imageLiteral(resourceName: "Camera"), for: UIControlState())
        view.addSubview(cameraButton)
        
        leftButton = UIButton(frame: CGRect(x: 50, y: view.frame.height - 80, width: 30, height: 30))
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        leftButton.setImage(#imageLiteral(resourceName: "left"), for: UIControlState())
        view.addSubview(leftButton)
        
        rightButton = UIButton(frame: CGRect(x: view.frame.width - 80, y: view.frame.height - 80, width: 30.0, height: 30.0))
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        rightButton.setImage(#imageLiteral(resourceName: "right"), for: UIControlState())
        view.addSubview(rightButton)
    }
    
    public func adjustButtonAlpha(float: CGFloat) {
        let adjustedFloat = 1.0 - float
        
        cameraButton.alpha = adjustedFloat
        leftButton.alpha = adjustedFloat
        rightButton.alpha = adjustedFloat
    }
    
    @objc private func leftButtonPressed() {
        self.delegate?.PanelViewControllerAnimateTo(panel: .left)
    }
    
    @objc private func rightButtonPressed() {
        self.delegate?.PanelViewControllerAnimateTo(panel: .right)
    }
    
}
