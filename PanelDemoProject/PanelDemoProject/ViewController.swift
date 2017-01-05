//
//  ViewController.swift
//  PanelDemoProject
//
//  Created by Andrew on 2017-01-05.
//  Copyright © 2017 Walzy. All rights reserved.
//

import UIKit

class ViewController: PanelViewController, PanelViewControllerDataSource {
    
    var viewController1: UIViewController!
    var viewController2: CenterViewController!
    var viewController3: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Datasource to set our ViewControllers
        dataSource = self
        
        
    }
    
    // Required Delegate function. Setings the view controllers: [Left, Center, Right]
    
    func PanelViewDidSetViewControllers() -> [UIViewController] {
        viewController1 = UIViewController()
        viewController1.view.backgroundColor = UIColor.gray
        
        viewController2 = CenterViewController()
        // set delegate so left and right buttons scroll to the proper view
        viewController2.delegate = self
        
        viewController3 = UIViewController()
        viewController3.view.backgroundColor = UIColor.gray
        
        return[viewController1, viewController2, viewController3]
    }
    
    func PanelViewControllerDidScroll(offSet: CGFloat) {
        
        print(offSet)
        
        // Offset is a CGFloat between -1.0 to 1.0. Getting absolute value to use for adjusting button alpha
        
        let absoluteFloat = abs(offSet)
        
        viewController2.adjustButtonAlpha(float: absoluteFloat)
    }
}

