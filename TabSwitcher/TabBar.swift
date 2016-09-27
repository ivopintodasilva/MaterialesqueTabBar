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
    
    internal var tabButtons: [TabButton] = []
    
    internal let indicator: UIView = UIView(frame: CGRect.zero)

    init(tabs: [String], titleColor: UIColor, indicatorColor: UIColor) {
        
        super.init(frame: CGRect.zero)
        
        for i in 0 ..< tabs.count {
            ///  Create and configure the tab buttons
            let tabButton: TabButton = TabButton(frame: CGRect.zero, index: i)
            
            /// Configure the tab button
            tabButton.configure(title: tabs[i], titleColor: titleColor)
            
            tabButton.delegate = self
            
            ///  Append the tab button into the array
            tabButtons.append(tabButton)
            
        }
        
        indicator.backgroundColor = indicatorColor
        
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
        
        addSubview(indicator)

    }
    
    internal var indicatorWidth: NSLayoutConstraint?
    
    internal var indicatorCenter: NSLayoutConstraint?
    
    /**
     Add constraints to the view
     */
    private func addConstraints() {
        
        /// Constraint the first tab to the beggining of the view
        constrain(self, tabButtons[0], indicator) { container, firstTab, indicator in
            firstTab.leading == container.leading
            firstTab.width == container.width / CGFloat(tabButtons.count)
            firstTab.height == container.height
            firstTab.centerY == container.centerY
            
            indicatorCenter = (indicator.centerX == firstTab.centerX)
            indicator.bottom == container.bottom
            indicator.height == TabBar.IndicatorHeight
            indicatorWidth = (indicator.width == TabBar.IndicatorInitialWidth)
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
    
    /// The initial height and width for the indicator view
    private static let IndicatorHeight: CGFloat = 2
    private static let IndicatorInitialWidth: CGFloat = 5
}

extension TabBar: TabButtonDelegate {
    
    func buttonTapped(index: Int) {
        
        /// Make sure that the width constraint already exists
        guard let widthConstraint = indicatorWidth,
            let centerConstraint = indicatorCenter
            else { return }
        
        /// Remove the constraint
        //removeConstraint(widthConstraint)
        removeConstraint(centerConstraint)
        //indicator.removeConstraint(widthConstraint)
        indicator.removeConstraint(centerConstraint)
        
        constrain(indicator, tabButtons[index]) { indicator, selectedTab in
            indicatorCenter = (indicator.centerX == selectedTab.centerX)
        }

        /// Force the view layout and animate it
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
    }
}
