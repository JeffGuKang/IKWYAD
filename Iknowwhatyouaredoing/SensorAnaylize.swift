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


class SensorAnaylize: NSObject{
    private let _motionManager: CMMotionManager
    private let _XYZArray: NSMutableArray
    private let _LPFAccelData: LowPassFilter
    let altimeter: CMAltimeter!
    
    var normalizeXYZ: NSNumber!
    var gyroData: CMGyroData!
    var accelData: CMAccelerometerData!
    var altitudeData: CMAltitudeData!
    
    
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
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(kAccelerometerFrequency, target: self, selector: Selector("sensorAnaylizeThread"), userInfo: nil, repeats: true);
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

        
        
        //check step detection
       

        _XYZArray.addObject(normalizeXYZ!)
        //          need to fine error

        /*
        if (_XYZArray.count > kBufferCapacity) {
            _XYZArray.removeObjectAtIndex(0)
            var sortedArray: NSArray = _XYZArray.sortedArrayUsingSelector(NSSelectorFromString("backwards"))
            
            var lowest: NSNumber = sortedArray.objectAtIndex(0) as NSNumber;
            var highest: NSNumber = sortedArray.lastObject as NSNumber;
            
            var indexOfHighest = _XYZArray.indexOfObject(highest);
            var indexOfLowest = _XYZArray.indexOfObject(lowest);
            var gap = indexOfLowest - indexOfHighest;

            if (gap >= kMinPeakToPeakTime &&
                gap <= kMaxPeakToPeakTime &&
                !lowest.isEqualToNumber( _XYZArray.lastObject as NSNumber) &&
                !highest.isEqualToNumber(_XYZArray.objectAtIndex(0) as NSNumber)) {
                    
                var previousOfHighest = _XYZArray.objectAtIndex(indexOfHighest - 1) as NSNumber
                var nextOfHighest = _XYZArray.objectAtIndex(indexOfHighest + 1) as NSNumber
                var previousOfLowest = _XYZArray.objectAtIndex(indexOfLowest - 1) as NSNumber
                var nextOfLowest = _XYZArray.objectAtIndex(indexOfLowest + 1) as NSNumber
                
                //  highest and lowest are peaks
                if (highest.doubleValue > previousOfHighest.doubleValue && highest.doubleValue > nextOfHighest.doubleValue && lowest.doubleValue < previousOfLowest.doubleValue && lowest.doubleValue < nextOfLowest.doubleValue) {
                    
                    //step detected
                    if (highest.doubleValue - lowest.doubleValue >= kMinPeakToPeak && highest.doubleValue - lowest.doubleValue <= kMaxPeakToPeak) {
                        delegate?.stepDetected(self);
                    }
                }
            }
        }
*/
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
    }
    
}


func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}





