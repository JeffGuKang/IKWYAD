//
//  InterfaceController.swift
//  WatchMotion Extension
//
//  Created by Jeff Kang on 12/6/15.
//  Copyright © 2015 jeffgukang. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!;
    @IBOutlet var accelLabel: WKInterfaceLabel!
    @IBOutlet var gyroLabel: WKInterfaceLabel!
    @IBOutlet var magneticLabel: WKInterfaceLabel!
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    var motionMgr: CMMotionManager!;
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        // Check Core Motion Status
        self.motionMgr = CMMotionManager.init()
        self.accelLabel.setTextColor(UIColor.grayColor())
        self.gyroLabel.setTextColor(UIColor.grayColor())
        self.magneticLabel.setTextColor(UIColor.grayColor())
        self.deviceLabel.setTextColor(UIColor.grayColor())
        
        if self.motionMgr.accelerometerAvailable {
            self.accelLabel.setTextColor(UIColor.whiteColor())
        }
        if self.motionMgr.gyroAvailable {
            self.gyroLabel.setTextColor(UIColor.whiteColor())
        }
        if self.motionMgr.magnetometerAvailable {
            self.magneticLabel.setTextColor(UIColor.whiteColor())
        }
        if self.motionMgr.deviceMotionAvailable {
            self.deviceLabel.setTextColor(UIColor.whiteColor())
        }
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}

