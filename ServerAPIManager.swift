//
//  ServerAPIManager.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 6/19/16.
//  Copyright © 2016 jeffgukang. All rights reserved.
//

import Foundation

enum API: String {
    case SensorFileUpload = "http://188.166.178.220:8080/sensorfile/"
    
}

/**
 File upload to server.
 
 - parameter filepath: URL.
 
 - returns: Void void
 */
func fileUploadToServer(filepath: URL) {
    // Post request.
    
    let url = URL(string: API.SensorFileUpload.rawValue)!
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    let bodyData = NSMutableData()
    
    //https://docs.djangoproject.com/ja/1.9/topics/http/file-uploads/
    request.setValue("multipart/form-data; boundary=swiftboundary", forHTTPHeaderField:"Content-Type")
    
    bodyData.append("--swiftboundary\r\n".data(using: String.Encoding.utf8)!)

    let filename = filepath.absoluteString?.components(separatedBy: "/").last
    let contentDisposition = "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\")\r\n"
    bodyData.append(contentDisposition.data(using: String.Encoding.utf8)!)
        bodyData.append("Content-Type: text/plain\r\n\r\n".data(using: String.Encoding.utf8)!)
    do {
        let data = try Data(contentsOf: filepath)
        bodyData.append(data)
        bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
        
        bodyData.append("--swiftboundary\r\n".data(using: String.Encoding.utf8)!)
    }
    catch {
        print("Error -> \(error)")
    }
    
    request.httpBody = bodyData as Data
    
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
            print("Response -> \(response)")
            print("responseString = \(jsonResponse)")
        }
        catch {
            print("error=\(error)")
            
        }
    })
    task.resume()
}
