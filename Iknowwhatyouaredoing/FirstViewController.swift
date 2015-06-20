//
//  FirstViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 1/26/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var originalConstraint: CGFloat?
    var timeDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Setup
        sensorAnaylize.sensorAnaylizeOn()
        
        //    Receive(Get) Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification:", name:"NotificationIdentifier", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "altimeterNotification:", name:"altimeterNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        //    Remove Notification
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifier", object: nil)
        timeDate = NSDate()
        self.originalConstraint = self.keyboardHeightLayoutConstraint?.constant
        self.fileNameTextField.delegate = self
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true) // Causes the view (or one of its embedded text fields) to resign the first responder status.
        super.touchesBegan(touches, withEvent: event)
    }
    
    //Action take on notification
    func methodOfReceivedNotification(notification: NSNotification){

        let accel_x = sensorAnaylize.accelData.acceleration.x
        let accel_y = sensorAnaylize.accelData.acceleration.y
        let accel_z = sensorAnaylize.accelData.acceleration.z
        let gyro_x = sensorAnaylize.gyroData.rotationRate.x
        let gyro_y = sensorAnaylize.gyroData.rotationRate.y
        let gyro_z = sensorAnaylize.gyroData.rotationRate.z
        
        accelLabelX.text = String("\(sensorAnaylize.accelData.acceleration.x)")
//        accelLabelX.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.x) as String
        accelLabelY.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.y) as String
        accelLabelZ.text = NSString(format: "%f", sensorAnaylize.accelData.acceleration.z) as String
        infoLabel.text = sensorAnaylize.normalizeXYZ?.stringValue
        
        gyroLabelX.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.x) as String
        gyroLabelY.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.y) as String
        gyroLabelZ.text = NSString(format: "%f", sensorAnaylize.gyroData.rotationRate.z) as String
        
        let timeInterval = String(format: "%f", self.timeDate!.timeIntervalSinceNow)

        let info: String = String(format: "\(timeInterval)\t%f\t%f\t%f\t%f\t%f\t%f\t\n", accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z)
        
        if recordButton.currentTitle == "Stop" {
            writeInfoToFile(fileNameTextField.text!, text: info)
        }
        else {
        }

    }
    
    func altimeterNotification(notification: NSNotification) {
        altituteLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.pressure) as String
        relativeAltitudeLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.relativeAltitude) as String
        
        let timeInterval = String(format: "%f", self.timeDate!.timeIntervalSinceNow)
        let info = "\(timeInterval)\t\(altituteLabel.text!)\t\(relativeAltitudeLabel.text!)\n"
        
        if recordButton.currentTitle == "Stop" {
            writeInfoToFile(fileNameTextField.text! + "_altimeter", text: info)
        }
        else {
        }
    }
    
    func keyboardNotification(notification: NSNotification) {
        let isShowing = notification.name == UIKeyboardWillShowNotification
        
        var tabbarHeight: CGFloat = 0
        if self.tabBarController != nil {
            tabbarHeight = self.tabBarController!.tabBar.frame.height
        }
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = isShowing ? (endFrame!.size.height - tabbarHeight) : self.originalConstraint!
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    @IBAction func recordButtonPushed(sender: AnyObject) {
        if recordButton.currentTitle == "Start" {
            recordButton.setTitle("Stop", forState: UIControlState.Normal)
            recordLabel.text = "Recording"
            self.timeDate = NSDate()
        }
        else {
            recordButton.setTitle("Start", forState: UIControlState.Normal)
            recordLabel.text = "Record"
        }
    }
    
//    MARK: UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        fileNameTextField.resignFirstResponder()
        return false
    }
}

func writeInfoToFile(fileName: String, text: String) {
    let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)
    
    if ((dirs) != nil) {
        let dir = dirs![0]; //documents directory
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        let path = dir.stringByAppendingPathComponent(fileName + ".txt");
        
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(text)
            outputStream.close()
        }
        else {
            print("Unable to open file")
        }
        
        
        //        //writing
        //        text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
        //        //
        //        //            //reading
        //        //            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
    }
}


