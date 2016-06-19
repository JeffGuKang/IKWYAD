//
//  PrefViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 6/18/16.
//  Copyright © 2016 jeffgukang. All rights reserved.
//

import UIKit

class PrefViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard()
        if let username = defaults.object(forKey: "username") as? String {
            self.username.text = username
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBActions
    
    @IBAction func signIn() {
        let url = URL(string: "http://188.166.178.220:8080/o/token/")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let body = "grant_type=password&username=\(username.text!)&password=\(password.text!)&client_id=xgB01lQ6PbbKjDuAPuyvkpUv34TZg3VJBlmLxFx2"
        
        
        do {
            let json = [
                "username": username.text!,
                "password": password.text!,
                "client_id": "xgB01lQ6PbbKjDuAPuyvkpUv34TZg3VJBlmLxFx2",
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            // Insert json data to the request.
            request.httpBody = body.data(using: String.Encoding.utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        catch {
            print("Error -> \(error)")
        }
        
        let session = URLSession.shared()
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("responseString = \(jsonResponse)")
                print("Response -> \(response)")
                
                
//                if let username = jsonResponse["username"] as? String {
//                    let defaults = UserDefaults.standard()
//                    defaults.set(username, forKey: "username")
//                }
//                else {
//                    print("error = No username")
//                }
                
            }
            catch {
                print("error=\(error)")
                
            }
        })
        task.resume()
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
