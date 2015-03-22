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
    private let _motionManager: CMMotionManager;
    private let _LPFAccelData: LowPassFilter;
    private let _XYZArray: NSMutableArray;
    var normalizeXYZ: NSNumber?{
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
        }
    }
    
    override init() {
        _motionManager = CMMotionManager();
        _motionManager.accelerometerUpdateInterval = kAccelerometerFrequency;
        _motionManager.startAccelerometerUpdates();
        
        _LPFAccelData = LowPassFilter(sampleRate: kUpdateFrequency, cutoffFrequency: kCutoffFrequency);
        _XYZArray = NSMutableArray(capacity: kBufferCapacity);
    }
    
    func sensorAnaylizeOn() {
        var timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(kAccelerometerFrequency, target: self, selector: Selector("sensorAnaylizeThread"), userInfo: nil, repeats: true);
        timer.fire();
    }
    
    //    Thread Method
    func sensorAnaylizeThread() {
        var accelData: CMAccelerometerData! = _motionManager.accelerometerData
        
        if (accelData == nil) {
            return
        }

        _LPFAccelData.addAccelerometerData(accelData.acceleration.x
            , aY: accelData.acceleration.y, aZ: accelData.acceleration.z)

        normalizeXYZ = sqrt(pow(_LPFAccelData.x, 2) + pow(_LPFAccelData.y, 2) + pow(_LPFAccelData.z, 2))


        let info: String = String(format: "%f %f %f %@ \n", _LPFAccelData.x, _LPFAccelData.y, _LPFAccelData.z, normalizeXYZ!)
        NSLog("Normalize info: %@", info)

        writeInfoToFile(info)
        
        
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
    }
    
}


func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}

func writeInfoToFile(text: String) {
    let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
    
    if ((dirs) != nil) {
        let dir = dirs![0]; //documents directory
        let path = dir.stringByAppendingPathComponent("data.txt");
        
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(text)
        
            outputStream.close()
        }
        else {
            println("Unable to open file")
        }

        
//        //writing
//        text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
//        //
//        //            //reading
//        //            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
    }
}



