/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit

class ViewController: PanelViewController, PanelViewControllerDataSource {
    
    var viewController1: UIViewController!
    var viewController2: CenterViewController!
    var viewController3: UIViewController!
    
    // Used to store property if statusBar is hidden or not
    
    var isStatusBarHidden = true
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    
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
        
        // Determine if Panel is centered on Left or Right, and animate the status bar
        
        if (offSet == -1.0 || offSet == 1.0) && isStatusBarHidden == true {
            isStatusBarHidden = false
            
            UIView.animate(withDuration: 0.35, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        } else /*Hide status bar */ {
            isStatusBarHidden = true
            
            UIView.animate(withDuration: 0.35, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
}

