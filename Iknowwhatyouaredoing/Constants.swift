//
//  Constants.swift
//  IndoorLocation_Swift
//
//  Created by Jeff Kang on 2/9/13.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import Foundation

let infoViewHeight = 67



let kMapName = "map_sw_half.png"
let kMapRatio = 0.1//m per 1px
let kPlusHead = 90.0

let kBufferCapacity = 25 //Array buffer for step detection
let kUpdateFrequency = 60.0
let kCutoffFrequency = 5.0 // 5.0/60.0
let kAccelerometerFrequency = 1.0 / 60.0//sec
let kFileGyro = "gyro.txt"
let kFileAccel = "accel.txt"
let kFileGPS = "gps.txt"
let kFileCompass = "compass.txt"
let kFileStepCoordinate = "step.txt"
let kGapTimeOfStep = 25 // 0.333sec
let kBaseStepValue = 0.01 //g unit
let kPeakGap = 10
let kMinPeakToPeak = 0.04 //have to extract from InitializedjE
let kMaxPeakToPeak = 0.25
let kMinPeakToPeakTime = 8 //60.0
let kMaxPeakToPeakTime = 20//60.0
let kInitOneStep = 0.72
let kSaveMode = 0 //0:simple 1:all
let kOneStep = "oneStep"
let khttpAddress = "http://itspace.kr/step/step.cgi"

func DEG2RAD(degrees: Double) -> Double {
    return (degrees * M_PI/180.0)
} // degrees * pi over 180

func RAD2DEG(radians: Double) -> Double {
    return (radians * 180.0/M_PI) // radians * 180 over pi
}



//NSUserDefaults
let kColor = "color"
let kNickname = "identification"
enum color {
    case kRed,
    kGreen,
    kBlue,
    kYellow
};

