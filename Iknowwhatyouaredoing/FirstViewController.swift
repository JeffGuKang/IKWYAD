//
//  FirstViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 1/26/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var sensorAnaylize: SensorAnaylize = SensorAnaylize()
    
    
    @IBOutlet weak var accelLabelX: UILabel!
    @IBOutlet weak var accelLabelY: UILabel!
    @IBOutlet weak var accelLabelZ: UILabel!
    @IBOutlet weak var gyroLabelX: UILabel!
    @IBOutlet weak var gyroLabelY: UILabel!
    @IBOutlet weak var gyroLabelZ: UILabel!
    @IBOutlet weak var altituteLabel: UILabel!
    @IBOutlet weak var relativeAltitudeLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //UI Setup
        sensorAnaylize.sensorAnaylizeOn()
        
        //    Receive(Get) Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification:", name:"NotificationIdentifier", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "altimeterNotification:", name:"altimeterNotification", object: nil)

        
        //    Remove Notification
        
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifier", object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Action take on notification
    func methodOfReceivedNotification(notification: NSNotification){
        // TODO: Add original values of x, y, z
        let accel_x = sensorAnaylize.accelData.acceleration.x
        let accel_y = sensorAnaylize.accelData.acceleration.y
        let accel_z = sensorAnaylize.accelData.acceleration.z
        
        let gyro_x = sensorAnaylize.gyroData.rotationRate.x
        let gyro_y = sensorAnaylize.gyroData.rotationRate.y
        let gyro_z = sensorAnaylize.gyroData.rotationRate.z
        
        accelLabelX.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.x)
        accelLabelY.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.y)
        accelLabelZ.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.z)
        infoLabel.text = sensorAnaylize.normalizeXYZ?.stringValue
        
        gyroLabelX.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.x)
        gyroLabelY.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.y)
        gyroLabelZ.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.z)
        
        
        
        let info: String = String(format: "%f %f %f %@ \n", accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z)

        writeInfoToFile(info)
    }
    func altimeterNotification(notification: NSNotification) {
        altituteLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.pressure)
        relativeAltitudeLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.relativeAltitude)
    }
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


