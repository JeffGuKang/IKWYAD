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

let kUpdateFrequency = 60.0 // min: 10, max: 100

class InterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!;
    @IBOutlet var accelLabel: WKInterfaceLabel!
    @IBOutlet var gyroLabel: WKInterfaceLabel!
    @IBOutlet var magneticLabel: WKInterfaceLabel!
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    
    var groupController = [TableGroupController]()
    var motionMgr: CMMotionManager!
    //    var accelData: CMAccelerometerData?;
    
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
            self.motionMgr.accelerometerUpdateInterval = 1/kUpdateFrequency
            self.groupController.append(TableGroupController(Label: "X"))
            self.groupController.append(TableGroupController(Label: "Y"))
            self.groupController.append(TableGroupController(Label: "Z"))
            print("Accel is working")
            
            self.table.setNumberOfRows(self.groupController.count, withRowType: "motionRow")
            motionMgr.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (accelData: CMAccelerometerData?, error: NSError?) -> Void in
                self.groupController[0].axisValue.setText(String(accelData?.acceleration.x))
                self.groupController[1].axisValue.setText(String(accelData?.acceleration.y))
                self.groupController[2].axisValue.setText(String(accelData?.acceleration.z))
            })
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

