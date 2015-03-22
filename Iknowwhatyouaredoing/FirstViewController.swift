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
    
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //UI Setup
        
        
        sensorAnaylize.sensorAnaylizeOn()
        
        
        //    Receive(Get) Notification
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification:", name:"NotificationIdentifier", object: nil)
        
        
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
        
        xLabel.text = NSString(format: "%f", sensorAnaylize.accelData.x)
        yLabel.text = NSString(format: "%f", sensorAnaylize.accelData.y)
        zLabel.text = NSString(format: "%f", sensorAnaylize.accelData.z)
        infoLabel.text = sensorAnaylize.normalizeXYZ?.stringValue
    }
}

