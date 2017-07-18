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
                        backgroundColor: ViewController.BackgroundColor,
                        indicatorColor: ViewController.IndicatorColor,
                        font: ViewController.TitleFont)
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignDelegates()
        
        addSubviews()
        
        addConstraints()
        
        setViewControllers()
    }
    
    /**
     Set the delegates
     */
    private func assignDelegates() {
        dataSource = self
        delegate = self
        
        tabBar.delegate = self
    }
    
    /**
     Set the View Controllers in the UIPageViewController
     */
    private func setViewControllers() {
        
        guard let first: UIViewController = children.first?.viewController else { return }
        
        setViewControllers([first], direction: .forward, animated: false, completion: nil)
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
    private static let BackgroundColor: UIColor = UIColor.white
    private static let TitleFont: UIFont? = UIFont(name: "Avenir", size: 14)
    private static let IndicatorColor: UIColor = UIColor.red
}

extension ViewController: UIPageViewControllerDelegate {
    
    @available(iOS 6.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    
        guard let pending: UIViewController = pendingViewControllers.first else { return }
        
        let index: Int? = children
            .map{ $0.viewController }
            .index(of: pending)

        guard let mockTappedIndex: Int = index else { return }
        
        tabBar.buttonTapped(index: mockTappedIndex)
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    @available(iOS 5.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let activeIndex: Int? = children
            .map{ $0.viewController }
            .index(of: viewController)
        
        guard let index: Int = activeIndex, index > 0 else { return nil }
        
        return children[index - 1].viewController
    }
    
    @available(iOS 5.0, *)
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        let activeIndex: Int? = children
            .map{ $0.viewController }
            .index(of: viewController)

        guard let index: Int = activeIndex, index < children.count - 1 else { return nil }
        
        return children[index + 1].viewController

    }
}

extension ViewController: TabBarDelegate {
    func buttonTapped(index: Int) {
        setViewControllers([children[index].viewController], direction: .forward, animated: true, completion: nil)
    }
}
