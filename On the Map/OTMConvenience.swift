//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation

// MARK: - OTMClient (Convenient Resource Methods)

extension OTMClient {
    
    // MARK: UDACITY - POSTing (Creating) a Session
    
    func postSession(username: String, password: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method : String = Methods.UdacityPostSession
        let jsonBody : [String:AnyObject] = [
            OTMClient.JSONBodyKeys.Udacity: [
                OTMClient.JSONBodyKeys.Username: "\(username)",
                OTMClient.JSONBodyKeys.Password: "\(password)"
            ]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, baseURLSecure: OTMClient.Constants.UdacityBaseURLSecure, headers: nil, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("Phooey!")
                completionHandler(success: false, error: error)
            } else {
                if let results = JSONResult["account"] as? [String: AnyObject] {
                    OTMClient.sharedInstance().authServiceUsed = OTMClient.AuthService.Udacity
                    StudentLocation.sharedInstance.uniqueKey = results["key"] as? String
                    print("uniqueKey: \(StudentLocation.sharedInstance.uniqueKey)") //debug
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "Client Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSession data."]))
                }
            }
        }
    }
    
    // MARK: UDACITY - DELETEing (Logging Out Of) a Session
    
    func deleteSession(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method : String = Methods.UdacityDeleteSession
        
        /* 2. Make the request */
        taskForDELETEMethod(method) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("Phooey!")
                completionHandler(success: false, error: error)
            } else {
                if let results = JSONResult["session"]!!["id"] as? String {
                    OTMClient.sharedInstance().authServiceUsed = nil
                    OTMClient.sharedInstance().sessionID = nil
                    print("Session deleted for ID: \(results)")
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "Client Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteSession data."]))
                }
            }
        }
    }
    
    // MARK: UDACITY - GETting Student Name
    
    func queryStudentName(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method: String
        if let uniqueKey = StudentLocation.sharedInstance.uniqueKey {
            method = OTMClient.subtituteKeyInMethod(Methods.UdacityUserData, key: URLKeys.UserID, value: uniqueKey)!
        } else {
            let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot post when logged in with Facebook credentials. Please log in with Udacity credentials."])
            completionHandler(success: false, error: error)
            return
        }
        
        /* 2. Make the request */
        taskForGETMethod(method, baseURLSecure: OTMClient.Constants.UdacityBaseURLSecure, parameters: nil, headers: nil) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                
                if let result = JSONResult["user"] as! [String : AnyObject]? {    // If result, store first and last name in sharedinstance object
                    
                    let studentLocation = StudentLocation.sharedInstance
                    if let firstname = result["first_name"] {
                        print(firstname)
                        studentLocation.firstName = firstname as? String
                    }
                    if let lastname = result["last_name"] {
                        print(lastname)
                        studentLocation.lastName = lastname as? String
                    }
                    if (studentLocation.firstName != nil) && (studentLocation.lastName != nil) {
                        completionHandler(success: true, error: nil)
                        print("In queryStudentName -> \(studentLocation.firstName!) \(studentLocation.lastName!)")    // debug
                    } else {
                        completionHandler(success: false, error: NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get user's name from server."]))
                    }
                    
                } else {
                    completionHandler(success: false, error: NSError(domain: "Client Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse queryStudentName data."]))
                }
            }
        }
    }

    
    // MARK: PARSE - GETting StudentLocations
    
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String: AnyObject] = [
            OTMClient.ParameterKeys.Limit: Int(100),
            OTMClient.ParameterKeys.Order: "-updatedAt"
        ]
        let method : String = Methods.ParseGetStudentLocations
        let headers : [String:String] = [
            OTMClient.HeaderKeys.ParseAppID: OTMClient.Constants.AppID,
            OTMClient.HeaderKeys.ParseRESTAPIKey: OTMClient.Constants.RESTApiKey
        ]
        
        /* 2. Make the request */
        taskForGETMethod(method, baseURLSecure: OTMClient.Constants.ParseBaseURLSecure, parameters: parameters, headers: headers) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                
                if let results = JSONResult["results"] as? [[String : AnyObject]] {

                    let studentLocations = StudentLocation.sharedInstance
                    studentLocations.studentArray = StudentLocation.arrayFromResults(results)
                    
                    completionHandler(success: true, error: nil)
                    
                } else {
                    completionHandler(success: false, error: NSError(domain: "Client Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations data."]))
                }
            }
        }
    }
    
    
    // MARK: PARSE - POSTing a StudentLocation
    
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method : String = Methods.ParsePostStudentLocation
        let headers : [String:String] = [
            OTMClient.HeaderKeys.ParseAppID: OTMClient.Constants.AppID,
            OTMClient.HeaderKeys.ParseRESTAPIKey: OTMClient.Constants.RESTApiKey,
            "application/json": "Content-Type"
        ]
        let jsonBody : [String:AnyObject] = [
            OTMClient.JSONResponseKeys.uniqueKey: "\(studentLocation.uniqueKey!)",
            OTMClient.JSONResponseKeys.firstName: "\(studentLocation.firstName!)",
            OTMClient.JSONResponseKeys.lastName: "\(studentLocation.lastName!)",
            OTMClient.JSONResponseKeys.mapString: "\(studentLocation.mapString!)",
            OTMClient.JSONResponseKeys.mediaURL: "\(studentLocation.mediaURL!)",
            OTMClient.JSONResponseKeys.latitude:   (studentLocation.latitude!),
            OTMClient.JSONResponseKeys.longitude:  (studentLocation.longitude!)
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, baseURLSecure: OTMClient.Constants.ParseBaseURLSecure, headers: headers, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print("Phooey!")
                completionHandler(success: false, error: error)
            } else {
                if let _ = JSONResult {
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "Client Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation data."]))
                }
            }
        }
    }
}


