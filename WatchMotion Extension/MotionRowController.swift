//
//  MotionRowController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 12/6/15.
//  Copyright © 2015 jeffgukang. All rights reserved.
//

import Foundation
import WatchKit

@available(iOS 8.2, *)
class MotionRowController: NSObject {
    @IBOutlet var axisLabel: WKInterfaceLabel!
    @IBOutlet var axisValueLabel: WKInterfaceLabel!
    @IBOutlet var separator: WKInterfaceSeparator!
}