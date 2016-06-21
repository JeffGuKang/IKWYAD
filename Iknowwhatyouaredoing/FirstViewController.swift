//
//  FirstViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 1/26/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var sensorAnaylize: SensorAnaylize = SensorAnaylize()
    var originalConstraint: CGFloat?
    var timeDate: Date?
    var updateStatusTimer: Timer!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.updateStatusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStatusToServer), userInfo: nil, repeats: true)
        updateStatusTimer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI Setup
        sensorAnaylize.sensorAnaylizeOn()
        
        //    Receive(Get) Notification
        NotificationCenter.default().addObserver(self, selector: #selector(FirstViewController.methodOfReceivedNotification(_:)), name:"NotificationIdentifier", object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(FirstViewController.altimeterNotification(_:)), name:"altimeterNotification", object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(FirstViewController.keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(FirstViewController.keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //    Remove Notification
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifier", object: nil)
        timeDate = Date()
        self.originalConstraint = self.keyboardHeightLayoutConstraint?.constant
        self.fileNameTextField.delegate = self
    }

    deinit {
        NotificationCenter.default().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // Causes the view (or one of its embedded text fields) to resign the first responder status.
        super.touchesBegan(touches, with: event)
    }
    
    //Action take on notification
    func methodOfReceivedNotification(_ notification: Notification){

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
    
    func altimeterNotification(_ notification: Notification) {
        altituteLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.pressure) as String
        relativeAltitudeLabel.text = NSString(format: "%@", sensorAnaylize.altitudeData.relativeAltitude) as String
        
        let timeInterval = String(format: "%f", self.timeDate!.timeIntervalSinceNow)
        let info = "\(timeInterval)\t\(altituteLabel.text!)\t\(relativeAltitudeLabel.text!)\n"
        
        if recordButton.currentTitle == "Stop" {
            writeInfoToFile(fileNameTextField.text! + "_altimeter", text: info)
        }
        
        // MARK: Status upload to server.
        else {
        }
    }
    
    func keyboardNotification(_ notification: Notification) {
        let isShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        
        var tabbarHeight: CGFloat = 0
        if self.tabBarController != nil {
            tabbarHeight = self.tabBarController!.tabBar.frame.height
        }
        if let userInfo = (notification as NSNotification).userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue()
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = isShowing ? (endFrame!.size.height - tabbarHeight) : self.originalConstraint!
            UIView.animate(withDuration: duration,
                delay: TimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }

    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fileNameTextField.resignFirstResponder()
        return false
    }

    // MARK: IBActions
    @IBAction func recordButtonPushed(_ sender: AnyObject) {
        if recordButton.currentTitle == "Start" {
            recordButton.setTitle("Stop", for: UIControlState())
            recordLabel.text = "Recording"
            self.timeDate = Date()
        }
        else {
            recordButton.setTitle("Start", for: UIControlState())
            recordLabel.text = "Record"
        }
    }
    
    @IBAction func uploadButtonPushed(_ sender: UISwitch) {
        if sender.isOn {
            self.updateStatusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStatusToServer), userInfo: nil, repeats: true)
        }
        else {
            self.updateStatusTimer.invalidate()
        }
    }
    
    func updateStatusToServer() {
        if sensorAnaylize.altitudeData != nil {
            print(sensorAnaylize.altitudeData)
            let data = sensorAnaylize.altitudeData.relativeAltitude.floatValue*100
            
            let dictionary = [
                "floor": String(Int(data))
            ]
            statusUploadToServer(dictionary: dictionary)
        }
    }
}

func writeInfoToFile(_ fileName: String, text: String) {
    let dirs : [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    if ((dirs) != nil) {
        _ = dirs![0]; //documents directory
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.mediumStyle
        let path = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName + ".txt")
//        let path = dir.stringByAppendingPathComponent(fileName + ".txt");

        if let outputStream = NSOutputStream(toFileAtPath: "\(path)", append: true) {
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


