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

/// Position of Panel in array: [left, center, right]

public enum Panel {
    
    /// Left Panel
    case left
    
    /// Center Panel
    case center
    
    /// Right Panel
    case right
}

// MARK: View Subclass Declarations

/// ScrollView subclass container to hold Panels

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

/// Public protocol for PanelViewController

public protocol PanelViewControllerDataSource {
    
    /**
     Constructing PanelViewController.
     
     - returns: [UIViewController] corresponding to Panels [Left, Center, Right]
     */
    
    func PanelViewDidSetViewControllers() -> [UIViewController]
    
    /**
     PanelViewControllerDataSource function called when the PanelViewController Container scrolls.
     
     - Parameter offSet: CGFloat corresponding the to position of the PanelViewController ScrollView.
     */
    
    func PanelViewControllerDidScroll(offSet: CGFloat)
}

/// Implementing optional delegate functions

public extension PanelViewControllerDataSource {
    
    func PanelViewControllerDidScroll(offSet: CGFloat) {
        // optional function
    }
}

/// Public protocol for PanViewController individual container ViewControllers

public protocol PanelViewControllerDelegate {
    
    /**
     Move to PanelViewController Panel with Animation.
     
     - Parameter panel: Panel to animate to.
     */
    
    func PanelViewControllerAnimateTo(panel: Panel)
}

/// Implementing optional delegate functions

public extension PanelViewControllerDelegate {
    
    func PanelViewControllerAnimateTo(panel: Panel) {
        // optional function
    }
}

// MARK: ViewController Declarations

/// A ViewController subclass containing three child ViewControllers in a UIScrollView

open class PanelViewController: UIViewController {
    
    // MARK: Public properties
    
    /// PanelViewController dataSource delegate
    
    public var dataSource                   : PanelViewControllerDataSource?
    
    // MARK: Private properties

    fileprivate var scrollView              : PanelScrollView!
    fileprivate var leftViewController      : UIViewController?
    fileprivate var centerViewController    : UIViewController?
    fileprivate var rightViewController     : UIViewController?
    fileprivate var _viewWidth              : CGFloat!
    fileprivate var _viewHight              : CGFloat!
    
    /// ViewDidLoad implementation

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // create height and width instance variables for reuse
        _viewWidth = view.bounds.width
        _viewHight = view.bounds.height
        
        // Create and Add Scroll View to hold our Panel Views
        scrollView = PanelScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: _viewWidth * 3, height: _viewHight)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        moveTo(panel: .center)
    }
    
    /// viewWillAppear implementation
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checks if data source is set, and assigns View Controllers
        setViewControllers()
        
        // Add ViewControllers from data source. If they are not set, add blank ViewControllers
        addPanel(viewController: leftViewController, panel: .left)
        addPanel(viewController: centerViewController, panel: .center)
        addPanel(viewController: rightViewController, panel: .right)
    }
    
    /**
     Move to PanelViewController Panel.
     
     - Parameter panel: Panel to move to.
     */
    
    public func moveTo(panel: Panel) {
        
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
}

// MARK: ViewController Extension Declarations


extension PanelViewController: PanelViewControllerDelegate {
    
    public func PanelViewControllerAnimateTo(panel: Panel) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.moveTo(panel: panel)
        }, completion: nil)
    }
}

extension PanelViewController: UIScrollViewDelegate {
    
    /// ScrollView delegate implementation
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = (scrollView.contentOffset.x / _viewWidth) - 1.0
        dataSource?.PanelViewControllerDidScroll(offSet: offSet)
    }
}
