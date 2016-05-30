//
//  InterfaceController.swift
//  WatchMotion Extension
//
//  Created by Jeff Kang on 12/6/15.
//  Copyright © 2015 jeffgukang. All rights reserved.
//
// Heart Rate
//http://stackoverflow.com/questions/30776331/watch-os-2-0-beta-access-heart-beat-rate/31864640#31864640

import WatchKit
import Foundation
import CoreMotion
import HealthKit

let kUpdateFrequency = 60.0 // min: 10, max: 100

enum SensorType : String{
    case accel      = "accel"
    case gyro       = "gyro"
    case magnetic   = "magnetic"
    case device     = "device"
    case heartRate  = "heartRate"
}

class InterfaceController: WKInterfaceController {
    
    // MARK: Properties
    @IBOutlet weak var accelLabel: WKInterfaceLabel!
    @IBOutlet weak var gyroLabel: WKInterfaceLabel!
    @IBOutlet weak var magneticLabel: WKInterfaceLabel!
    @IBOutlet weak var deviceLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var informationTable: WKInterfaceTable!
    
    var motionMgr: CMMotionManager!

    // MARK: Override functions
    
    override func awakeWithContext(context: AnyObject?) {
        
        // Configure interface objects here.
        
        // Check Core Motion Status
        self.motionMgr = CMMotionManager.init()
        self.accelLabel.setTextColor(UIColor.grayColor())
        self.gyroLabel.setTextColor(UIColor.grayColor())
        self.magneticLabel.setTextColor(UIColor.grayColor())
        self.deviceLabel.setTextColor(UIColor.grayColor())
        self.heartRateLabel.setTextColor(UIColor.grayColor())
        
        super.awakeWithContext(context)
        
        if self.motionMgr.gyroAvailable {
            self.gyroLabel.setTextColor(UIColor.whiteColor())
        }
        
        // Check accelerometer aviable.
        if self.motionMgr.accelerometerAvailable {
            self.accelLabel.setTextColor(UIColor.whiteColor())
            self.motionMgr.accelerometerUpdateInterval = 1/kUpdateFrequency
            
            // Make tablerows.
            let informationDataArray = [InformationData.init(label: "X"), InformationData.init(label: "Y"), InformationData.init(label: "Z")]
            configureTableWithData(informationDataArray)
            
            // Treat accelerometer datas.
            motionMgr.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (accelData: CMAccelerometerData?, error: NSError?) -> Void in
                let xRow = self.informationTable.rowControllerAtIndex(0) as! InformationTableRowController
                let yRow = self.informationTable.rowControllerAtIndex(1) as! InformationTableRowController
                let zRow = self.informationTable.rowControllerAtIndex(2) as! InformationTableRowController
                xRow.valueLabel.setText(String(format:"%.5f", accelData!.acceleration.x))
                yRow.valueLabel.setText(String(format:"%.5f", accelData!.acceleration.y))
                zRow.valueLabel.setText(String(format:"%.5f", accelData!.acceleration.z))
            })
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
    
    override func didAppear() {
        
        super.didAppear()
    }
    
    // MARK: Table Configurations
    
    func configureTableWithData(data: [InformationData]!) {
        self.informationTable.setNumberOfRows(data.count, withRowType: "tableRowController")

        for rowData in data {
            let row = self.informationTable.rowControllerAtIndex(data.indexOf(rowData)!) as! InformationTableRowController
            row.textLabel.setText(rowData.label)
        }
    }
}

