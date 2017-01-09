//
//  ViewController.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 25/09/2016.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    
    let tabBar: TabBar = TabBar(tabs: ["First", "Second", "Third"],
                                titleColor: ViewController.TitleColor,
                                indicatorColor: ViewController.IndicatorColor,
                                font: UIFont(name: "Avenir", size: 14))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        addConstraints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    private static let TitleColor: UIColor = UIColor.gray
    private static let IndicatorColor: UIColor = UIColor.red
}

