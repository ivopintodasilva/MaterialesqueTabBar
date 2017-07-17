//
//  ViewController.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 25/09/2016.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIPageViewController {
    
    let tabBar: TabBar
    let children: [TabBarChild]
    
    required init?(coder aDecoder: NSCoder) {
        
        children = [
            TabBarChild(title: "First", viewController: BlueViewController()),
            TabBarChild(title: "Second", viewController: RedViewController()),
            TabBarChild(title: "Third", viewController: GreenViewController()),
        ]
        
        tabBar = TabBar(tabs: children.map{ $0.title },
                        titleColor: ViewController.TitleColor,
                        indicatorColor: ViewController.IndicatorColor,
                        font: ViewController.TitleFont)

        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setViewControllers([children[0].viewController], direction: .forward, animated: false, completion: nil)
        
        addSubviews()
        
        addConstraints()
        
    }
    
    /**
     Add subviews to the ViewController's view
     */
    private func addSubviews() {
        view.addSubview(tabBar)
    }
    
    /**
     Add auto-layout's constraints to the view
     */
    private func addConstraints() {
        let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
        
        constrain(self.view, tabBar) { container, tabBar in
            tabBar.leading == container.leading
            tabBar.trailing == container.trailing
            
            tabBar.top == container.top + statusBarFrame.height
            tabBar.bottom == container.top + statusBarFrame.height + ViewController.TabBarHeight
        }
    }
    
    /// The tab bar height
    private static let TabBarHeight: CGFloat = 40

    /// Mocked customisable attributes
    private static let TitleColor: UIColor = UIColor.gray
    private static let TitleFont: UIFont? = UIFont(name: "Avenir", size: 14)
    private static let IndicatorColor: UIColor = UIColor.red
}

extension ViewController: UIPageViewControllerDelegate {
    
    @available(iOS 6.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    
        switch pendingViewControllers[0] {
        case children[1].viewController:
            tabBar.buttonTapped(index: 1)
        case children[2].viewController:
            tabBar.buttonTapped(index: 2)
        default:
            tabBar.buttonTapped(index: 0)
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    @available(iOS 5.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        switch viewController {
        case children[1].viewController:
            return children[0].viewController
        case children[2].viewController:
            return children[1].viewController
        default:
            return nil
        }
    }
    
    @available(iOS 5.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        switch viewController {
        case children[0].viewController:
            return children[1].viewController
        case children[1].viewController:
            return children[2].viewController
        default:
            return nil
        }
    }
}
