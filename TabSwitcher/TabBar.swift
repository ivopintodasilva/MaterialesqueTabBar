//
//  TabBar.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 26/09/2016.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit
import Cartography

class TabBar: UIView {
    
    
    var tabButtons: [TabButton] = []
    
    init(tabs: [String], titleColor: UIColor, indicatorColor: UIColor) {
        
        super.init(frame: CGRect.zero)
        
        for tab in tabs {
            ///  Create and configure the tab buttons
            let tabButton: TabButton = TabButton(frame: CGRect.zero)
            
            /// Configure the tab button
            tabButton.configure(title: tab, titleColor: titleColor, indicatorColor: indicatorColor)
            
            ///  Append the tab button into the array
            tabButtons.append(tabButton)
        }
        
        addSubviews()
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Add the subviews to the view
     */
    private func addSubviews() {
        /// Add the tab buttons to the view
        for tabButton in tabButtons {
            addSubview(tabButton)
        }
    }
    
    
    /**
     Add constraints to the view
     */
    private func addConstraints() {
        
        /// Constraint the first tab to the beggining of the view
        constrain(self, tabButtons[0]) { container, firstTab in
            firstTab.leading == container.leading
            firstTab.width == container.width / CGFloat(tabButtons.count)
            firstTab.height == container.height
            firstTab.centerY == container.centerY
        }
        
        /// The following tabs come after the others
        for i in 1 ..< tabButtons.count {
            constrain(self, tabButtons[i-1], tabButtons[i]) { container, previousTab, currentTab in
                currentTab.leading == previousTab.trailing
                currentTab.width == container.width / CGFloat(tabButtons.count)
                currentTab.height == container.height
                currentTab.centerY == container.centerY

            }
        }
    }
    
}
