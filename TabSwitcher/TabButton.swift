//
//  TabButton.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 25/09/2016.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit
import Cartography

/**
 The tab button view
 */
class TabButton: UIView {
    var state: TabState = .Normal
    
    let button: UIButton = UIButton(frame: CGRect.zero)
    let indicator: UIView = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        addSubViews()
        
        addConstraints()
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Add the subviews to the view
     */
    private func addSubViews() {
        addSubview(button)
        addSubview(indicator)
    }
    
    var indicatorWidth: NSLayoutConstraint?
    
    /**
     Add auto-layout constraints to the view
     */
    private func addConstraints() {
        constrain(self, button, indicator) { container, button, indicator in
            button.edges == container.edges
            
            indicator.centerX == container.centerX
            indicator.bottom == container.bottom
            indicator.height == TabButton.IndicatorHeight
            indicatorWidth = (indicator.width == TabButton.IndicatorInitialWidth)
        }
    }

    
    /**
     Obj-C method called when button is tapped
     */
    @objc private func buttonTapped() {
        /// Make sure that the width constraint already exists
        guard let widthConstraint = indicatorWidth else { return }
        
        /// Remove the constraint
        removeConstraint(widthConstraint)
        indicator.removeConstraint(widthConstraint)
        
        /// Attribute the new constraints and switch states
        switch state {
        case .Normal:
            constrain(self, indicator) { container, indicator in
                indicatorWidth = (indicator.width == container.width)
            }
            
            state = .Highlighted
        case .Highlighted:
            constrain(indicator) { indicator in
                indicatorWidth = (indicator.width == TabButton.IndicatorInitialWidth)
            }
            
            state = .Normal
        }

        /// Force the view layout and animate it
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    /**
     Configure the button with the title and indicator's color
     
     - parameter title:String The title of the button
     - parameter indicatorColor:UIColor The color for the button's indicator
     */
    func configure(title: String, titleColor: UIColor, indicatorColor: UIColor) {
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        
        indicator.backgroundColor = indicatorColor
    }
    
    /// The initial height and width for the indicator view
    static let IndicatorHeight: CGFloat = 2
    static let IndicatorInitialWidth: CGFloat = 5
}
