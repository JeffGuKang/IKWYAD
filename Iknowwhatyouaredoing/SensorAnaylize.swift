//
//  SensorAnaylize.swift
//
//  Created by Jeff Kang on 1/29/15.
//  Copyright (c) 2014 Jeff Kang. All rights reserved.
//
// step, status detection


import Foundation
import UIKit
import CoreMotion

protocol SensorAnaylizeDelegate {
    func stepDetected(SensorAnaylize)
}

class SensorAnaylize: NSObject{
    private let _motionManager: CMMotionManager
    private let _XYZArray: NSMutableArray
    private let _LPFAccelData: LowPassFilter
    let altimeter: CMAltimeter!
    
    var normalizeXYZ: NSNumber!
    var gyroData: CMGyroData!
    var accelData: CMAccelerometerData!
    var altitudeData: CMAltitudeData!
    var stepDetection: Bool = false
    
    var delegate: SensorAnaylizeDelegate?
    
    override init() {
        //accelerometer
        _motionManager = CMMotionManager()
        _motionManager.accelerometerUpdateInterval = kAccelerometerFrequency
        _motionManager.startAccelerometerUpdates()
        //gyroscope
        _motionManager.gyroUpdateInterval = kAccelerometerFrequency
        _motionManager.startGyroUpdates()
        //magnetometer
        _motionManager.magnetometerUpdateInterval = kAccelerometerFrequency
        _motionManager.magnetometerActive
        
        _LPFAccelData = LowPassFilter(sampleRate: kUpdateFrequency, cutoffFrequency: kCutoffFrequency);
        _XYZArray = NSMutableArray(capacity: kBufferCapacity)
        
        altimeter = CMAltimeter();

        
        super.init()

        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(),
                withHandler: { data, error in
                    if (error == nil) {
                        self.altitudeData = data
                        NSNotificationCenter.defaultCenter().postNotificationName("altimeterNotification", object: nil)
                    }
                })
        }
    }
    
    
    func sensorAnaylizeOn() {
        let timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(kAccelerometerFrequency, target: self, selector: Selector("sensorAnaylizeThread"), userInfo: nil, repeats: true);
        timer.fire();
    }
    
    //    Thread Method
    func sensorAnaylizeThread() {
        gyroData = _motionManager.gyroData
        if (gyroData == nil) {
            return
        }
        accelData = _motionManager.accelerometerData
        if (accelData == nil) {
            return
        }
        
        _LPFAccelData.addAccelerometerData(accelData!.acceleration.x, aY: accelData!.acceleration.y, aZ: accelData!.acceleration.z)
        
        normalizeXYZ = sqrt(pow(accelData!.acceleration.x, 2) + pow(accelData!.acceleration.y, 2) + pow(accelData!.acceleration.z, 2))
        
//        let info: String = String(format: "%f %f %f %@ \n", _LPFAccelData.x, _LPFAccelData.y, _LPFAccelData.z, normalizeXYZ!)
        let info: String = String(format: "%f %f %f %@ \n", accelData.acceleration.x, accelData.acceleration.y, accelData.acceleration.z, normalizeXYZ)

//        NSLog("Normalize info: %@", info)

        

// MARK: Step Detection. Runtime Error
        _XYZArray.addObject(normalizeXYZ!)
        if (self.stepDetection) {
            if (_XYZArray.count > kBufferCapacity) {
                _XYZArray.removeObjectAtIndex(0)
                let sortedArray: NSArray = _XYZArray.sortedArrayUsingSelector(NSSelectorFromString("backwards"))
                
                let lowest: NSNumber? = sortedArray.objectAtIndex(0) as? NSNumber
                let highest: NSNumber? = sortedArray.lastObject as? NSNumber
                var indexOfHighest: Int = 0
                var indexOfLowest: Int = 0
                if highest != nil {
                    indexOfLowest = _XYZArray.indexOfObject(highest!)
                }
                if lowest != nil {
                    indexOfHighest = _XYZArray.indexOfObject(lowest!)
                }
                
                let gap = indexOfLowest - indexOfHighest
                
                if (gap >= kMinPeakToPeakTime &&
                    gap <= kMaxPeakToPeakTime &&
                    lowest?.isEqualToNumber( _XYZArray.lastObject as! NSNumber) == true &&
                    highest?.isEqualToNumber(_XYZArray.objectAtIndex(0) as! NSNumber) == false) {
                        
                        let previousOfHighest = _XYZArray.objectAtIndex(indexOfHighest - 1) as? NSNumber
                        let nextOfHighest = _XYZArray.objectAtIndex(indexOfHighest + 1) as? NSNumber
                        let previousOfLowest = _XYZArray.objectAtIndex(indexOfLowest - 1) as? NSNumber
                        let nextOfLowest = _XYZArray.objectAtIndex(indexOfLowest + 1) as? NSNumber
                        
                        //  highest and lowest are peaks
                        if (highest != nil && lowest != nil && previousOfHighest != nil && nextOfHighest != nil) {
                            if (highest!.doubleValue > previousOfHighest!.doubleValue && highest!.doubleValue > nextOfHighest!.doubleValue && lowest!.doubleValue < previousOfLowest!.doubleValue && lowest!.doubleValue < nextOfLowest!.doubleValue) {
                                
                                //step detected
                                if (highest!.doubleValue - lowest!.doubleValue >= kMinPeakToPeak && highest!.doubleValue - lowest!.doubleValue <= kMaxPeakToPeak) {
                                    delegate!.stepDetected(self);
                                    print("STeb Detected")
                                }
                            }
                            
                        }
                }
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
    }
    
}


func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}





