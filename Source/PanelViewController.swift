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

// MARK: Enum Declarations

public enum Panel {
    case left
    case center
    case right
}

// MARK: View Subclass Declarations

fileprivate class PanelScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureScrollView()
    }
    
    private func configureScrollView() {
        // allows scroll view to be interacted with gestures
        
        isScrollEnabled = true
        
        // remove scroll indicators
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        // prevent scrollview from bouncing
        
        isPagingEnabled = true
        bounces = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
    }
}

// MARK: Protocol Declarations

public protocol PanelViewControllerDataSource {
    
    // Setting Panel View Controllers: [Left, Center, Right]
    
    func PanelViewDidSetViewControllers() -> [UIViewController]
    
    // Offset is a float between -1.0 to 1.0 depending on the position of ScrollView. 
    // -1.0 is centered on left panel
    // 0.0 is centered on central panel
    // 1.0 is centered on right panel
    
    func PanelViewControllerDidScroll(offSet: CGFloat)
}

extension PanelViewControllerDataSource {
    
    func PanelViewControllerDidScroll(offSet: CGFloat) {
        // optional function
    }
}

public protocol PanelViewControllerDelegate {
    
    // Allows individual Panel View Controllers to animate to another Panel
    
    func PanelViewControllerAnimateTo(panel: Panel)
}

// MARK: ViewController Declarations


class PanelViewController: UIViewController {
    
    // MARK: Public properties
    
    public var dataSource                   : PanelViewControllerDataSource?
    
    // MARK: Private properties

    fileprivate var scrollView              : PanelScrollView!
    fileprivate var leftViewController      : UIViewController?
    fileprivate var centerViewController    : UIViewController?
    fileprivate var rightViewController     : UIViewController?
    fileprivate var _viewWidth              : CGFloat!
    fileprivate var _viewHight              : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create height and width instance variables for reuse
        _viewWidth = view.bounds.width
        _viewHight = view.bounds.height
        
        // Create and Add Scroll View to hold our Panel Views
        scrollView = PanelScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: _viewWidth * 3, height: _viewHight)
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checks if data source is set, and assigns View Controllers
        setViewControllers()
        
        // Add ViewControllers from data source. If they are not set, add blank ViewControllers
        addPanel(viewController: leftViewController, panel: .left)
        addPanel(viewController: centerViewController, panel: .center)
        addPanel(viewController: rightViewController, panel: .right)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set center panel as launch ViewController
        animateTo(panel: .center)
    }
    
    private func setViewControllers() {
        
        // Check if data source is set
        guard dataSource != nil else {
            print("[PanelViewController]: Data Source View Controllers not set")
            return
        }
        
        let panelViewControllers : [UIViewController] = dataSource!.PanelViewDidSetViewControllers()
        
        // If the data source contains either more, or less than 3 View Controllers, the Panels will be set as blank View Controllers
        
        guard panelViewControllers.count == 3 else {
            print("[PanelViewController]: Data Source View Controllers count not correct. Currently: \(panelViewControllers.count), expected: 3")
            return
        }
        
        leftViewController   = panelViewControllers[0]
        centerViewController = panelViewControllers[1]
        rightViewController  = panelViewControllers[2]
    }
    
    private func addPanel(viewController: UIViewController?, panel: Panel) {
        
        // Find x coordinate offset to add scrollView subviews in horizontal array
        
        let xOffset: CGFloat!
        switch panel {
        case .left:
            xOffset = 0.0
        case .center:
            xOffset = _viewWidth
        case .right:
            xOffset = _viewWidth * 2
        }
        
        let panelView = UIView(frame: CGRect(x: xOffset, y: 0, width: _viewWidth, height: _viewHight))
        
        scrollView.addSubview(panelView)
        
        let panelViewController: UIViewController!
        
        // Check if the ViewController property has been set by the data source. If not, assign to blank ViewController
        
        if viewController != nil {
            panelViewController = viewController!
        } else {
            panelViewController = UIViewController()
        }
        
        panelViewController.view.frame = view.bounds
        panelView.addSubview(panelViewController.view)
        addChildViewController(panelViewController)
    }
    
    fileprivate func animateTo(panel: Panel) {
        
        // Find x coordinate offset to animate to

        let xOffset: CGFloat!
        switch panel {
        case .left:
            xOffset = 0.0
        case .center:
            xOffset = _viewWidth
        case .right:
            xOffset = _viewWidth * 2
        }
        scrollView.contentOffset = CGPoint(x: xOffset, y: 0)
    }
}

// MARK: ViewController Extension Declarations


extension PanelViewController: PanelViewControllerDelegate {
    
    func PanelViewControllerAnimateTo(panel: Panel) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.animateTo(panel: panel)
        }, completion: nil)
    }
}

extension PanelViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = (scrollView.contentOffset.x / _viewWidth) - 1.0
        dataSource?.PanelViewControllerDidScroll(offSet: offSet)
    }
}
