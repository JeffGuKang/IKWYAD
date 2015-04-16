//
//  AccelerometerFilter.swift
//  IndoorLocation_Swift
//
//  Created by Jeff Kang on 1/26/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class AccelerometerFilter : NSObject {
    var adaptive: Bool! = true
    var x = 1.0
    var y = 1.0
    var z = 1.0
    var filterConstant: Double!;
    var lastX, lastY, lastZ: CMAcceleration!;

    
    func addAcceleration(accel: CMAcceleration) {
        x = accel.x
        y = accel.y
        z = accel.z
    }
    
}


func Norm(x: Double, y: Double, z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
}

func Clamp(v: Double, min: Double, max: Double) -> Double {
    if (v > max) {
        return max
    }
    else if (v < min) {
        return min
    }
    else {
        return v;
    }
}

// See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering

class LowPassFilter : AccelerometerFilter {

    
    init(sampleRate: Double, cutoffFrequency freq: Double) {
        super.init()
        var dt: Double = 1.0 / sampleRate;
        var RC = 1.0 / freq;
        filterConstant = dt / (dt + RC);
    }
    
    override func addAcceleration(accel: CMAcceleration) {
        var alpha: Double! = filterConstant;
        x = accel.x * alpha + x * (1.0 - alpha);
        y = accel.y * alpha + y * (1.0 - alpha);
        z = accel.z * alpha + z * (1.0 - alpha);
    }
    
    func addAccelerometerData(aX: Double, aY: Double, aZ: Double) {
        let alpha = filterConstant;
        x = aX * alpha + x * (1.0 - alpha);
        y = aY * alpha + y * (1.0 - alpha);
        z = aZ * alpha + z * (1.0 - alpha);
    }
    
    func descript() -> NSString {
        return  (adaptive == true) ? "daptive Lowpass Filter" : "Lowpass Filter";
    }
    
}

