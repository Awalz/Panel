<h1 align="center">Panel</h1>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat" alt="Platform: iOS 8+"/>
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift%203-4BC51D.svg?style=flat" alt="Language: Swift 3" /></a>
    <a href="https://cocoapods.org/pods/Panel"><img src="https://img.shields.io/cocoapods/v/Panel.svg?style=flat" alt="CocoaPods compatible" /></a>
    <img src="http://img.shields.io/badge/license-BSD-lightgrey.svg?style=flat" alt="License: BSD" /> <br><br>
</p>

## Overview

Panel is a a simple, Snapchat inspired ViewController subclass. Panel allows you to add you own custom ViewControllers to an embedded ScrollView. Panel allows complete control over the presentaion of the panels. 

## Requirements

* iOS 8.0+
* Swift 3.0+

## License

Panel is available under the BSD license. See the LICENSE file for more info.

## Installation

### Cocoapods:

Panel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Panel"
```

### Manual Installation:

Simply copy the contents of the Source folder into your project.

## Usage 

Using Panel is very simple.

### Getting Started:

If you have installed via Cocoapods, be sure to include 

    import Panel
    
Create a View Controller, and set its subclass to be **PanelViewController**:

    class MyViewController: PanelViewController {
    ///
    
### Adding View Controllers:

To add your own ViewControllers, your container ViewController must conform to the **PanelViewControllerDataSource** protocol:

    class MyViewController: PanelViewController, PanelViewControllerDataSource {
    ///
    
The container ViewController must also set itself as the dataSource delegate in **ViewDidLoad**:

        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Datasource to set our ViewControllers
        dataSource = self
    }
    
**PanelViewControllerDataSource** has one required protocol functions which must be implemented, **PanelViewDidSetViewControllers**. **PanelViewDidSetViewControllers** expects a return type of **[UIViewController]**. Panel requires three ViewControllers be returned in this array, in the order you wish to have them displayed:

    func PanelViewDidSetViewControllers() -> [UIViewController] {
    
     // Add your own custom View Controllers here 
     
        viewController1 = UIViewController()
        viewController2 = UIViewController()
        viewController3 = UIViewController()
        
        let panelArray = [viewController1, viewController2, viewController3]
        
        // Will be displayed in order: [LeftPanel, CenterPanel, RightPanel]
        
        return panelArray
    }
    
### Manually Moving to Panel

If you wish to animate to particular panel from inside your container ViewController, you can use the **animateTo(panel:)** function:

    animateTo(panel: .left)
 
 Additionally, if you wish to have one of the panel ViewControllers animate to another panel, you can use the **PanelViewControllerDelegate** property. 
 
 Within the panel ViewController's decleration, add a delegate property of optional type **PanelViewControllerDelegate**:
 
    var delegate: PanelViewControllerDelegate?

When declaring the container ViewControllers dataSource, set the panel's delegate to the container ViewController:

    func PanelViewDidSetViewControllers() -> [UIViewController] {
     
        viewController1 = CustomViewController()
     
        // set the ViewController's delegate to the container ViewController
        viewContoller1.delegate = self
        ..
    }

Once the delegate is set, you can animate the panels by calling the delegate function **anelViewControllerAnimateTo(panel:)**:

     delegate?.PanelViewControllerAnimateTo(panel: .left)


### Miscellaneous

If you wish to know the position of the container ScrollView as it scrolls, you can implement the optional **PanelViewControllerDataSource** function **PanelViewControllerDidScroll(offSet:)**. This will return the offSet CGFloat between -1.0 and 1.0:

     func PanelViewControllerDidScroll(offSet: CGFloat) {
          // Offset is a float between -1.0 to 1.0 depending on the position of ScrollView. 
          // -1.0 is centered on left panel
          // 0.0 is centered on central panel
          // 1.0 is centered on right panel
       }

### Contact

If you have any questions, requests, or enhancements, feel free to submit a pull request, create an issue, or contact me in person:

**Andrew Walz** - **andrewjwalz@gmail.com**
