//
//  SignUpViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 6/18/16.
//  Copyright © 2016 jeffgukang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func submitClicked(_ sender: UIButton) {
        if password.text != passwordConfirm.text {
            let alert = UIAlertController(title: "Password Error", message: "Check Your Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction) in
                
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
        
            // Post request.
            let url = URL(string: "http://188.166.178.220:8080/signup/")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"

            do {
                let json = ["username": username.text!, "password": password.text!]
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
                // Insert json data to the request.
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

                    
                    if let username = jsonResponse["username"] as? String {
                        let defaults = UserDefaults.standard()
                        defaults.set(username, forKey: "username")
                    }
                    else {
                        print("error = No username")
                    }

                    self.dismiss(animated: true, completion: {
                    })
                }
                catch {
                    print("error=\(error)")

                }
            })
            task.resume()
        }
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
