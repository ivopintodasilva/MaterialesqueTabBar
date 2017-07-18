//
//  TabBar.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 26/09/2016.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit
import Cartography

/**
 The tab button delegate to delegate the button tapped action
 */
protocol TabBarDelegate: class {
    func buttonTapped(index: Int)
}

class TabBar: UIView {
    
    internal var tabButtons: [TabButton] = []
    
    internal let indicator: UIView = UIView(frame: CGRect.zero)
    
    weak var delegate: TabBarDelegate?

    init(tabs: [String], titleColor: UIColor, backgroundColor: UIColor, indicatorColor: UIColor, font: UIFont?) {
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = backgroundColor
        
        for i in 0 ..< tabs.count {
            ///  Create and configure the tab buttons
            let tabButton: TabButton = TabButton(frame: CGRect.zero, index: i)
            
            /// Configure the tab button
            tabButton.configure(title: tabs[i], color: titleColor, font: font)
            
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
            indicatorWidth = (indicator.width == firstTab.width)
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
    internal static let IndicatorHeight: CGFloat = 2
    internal static let IndicatorInitialWidth: CGFloat = 5
}

extension TabBar: TabButtonDelegate {
    
    func buttonTapped(index: Int) {
        
        delegate?.buttonTapped(index: index)
        
        /// Make sure that the width constraint already exists
        guard let centerConstraint = indicatorCenter
            else { return }
        
        
        /// Chain animate the indicator change
        UIView.animateKeyframes(withDuration: 0.9, delay: 0, options: .beginFromCurrentState, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (0.25)) {
                
                if let widthConstraint = self.indicatorWidth {
                    self.removeConstraint(widthConstraint)
                    self.indicator.removeConstraint(widthConstraint)
                    self.tabButtons[index].removeConstraint(widthConstraint)
                }
                
                constrain(self.indicator, self.tabButtons[index]) { indicator, selectedTab in
                    self.indicatorWidth = (indicator.width == TabBar.IndicatorInitialWidth)
                }
                
                self.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                self.removeConstraint(centerConstraint)
                
                constrain(self.indicator, self.tabButtons[index]) { indicator, selectedTab in
                    self.indicatorCenter = (indicator.centerX == selectedTab.centerX)
                }
                
                self.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                
                if let widthConstraint = self.indicatorWidth {
                    self.removeConstraint(widthConstraint)
                    self.indicator.removeConstraint(widthConstraint)
                    self.tabButtons[index].removeConstraint(widthConstraint)
                }
                
                constrain(self.indicator, self.tabButtons[index]) { indicator, selectedTab in
                    self.indicatorWidth = (indicator.width == selectedTab.width)
                }
                
                self.layoutIfNeeded()
            }
            
            }, completion: nil)
        
    }
}
