//
//  TabBarChild.swift
//  TabSwitcher
//
//  Created by Ivo Silva on 17/07/2017.
//  Copyright © 2017 Ivo Silva. All rights reserved.
//

import Foundation
import UIKit

class TabBarChild {

    let title: String
    let viewController: UIViewController
    
    init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}
