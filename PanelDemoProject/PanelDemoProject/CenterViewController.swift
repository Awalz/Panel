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
