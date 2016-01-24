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
            OTMClient.JSONBodyKeys.Udacity: [OTMClient.JSONBodyKeys.Username: "\(username)",
                OTMClient.JSONBodyKeys.Password: "\(password)"]
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
                    completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSession"]))
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
                    completionHandler(success: false, error: NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteSession"]))
                }
            }
        }
    }
    
    // MARK: PARSE - GETting StudentLocations
    
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method : String = Methods.ParseGetStudentLocations
        let headers : [String:String] = [
            OTMClient.HeaderKeys.ParseAppID: OTMClient.Constants.AppID,
            OTMClient.HeaderKeys.ParseRESTAPIKey: OTMClient.Constants.RESTApiKey
        ]
        
        /* 2. Make the request */
        taskForGETMethod(method, baseURLSecure: OTMClient.Constants.ParseBaseURLSecure, headers: headers) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                
                if let results = JSONResult["results"] as? [[String : AnyObject]] {

                    let studentLocations = StudentLocation.sharedInstance
                    studentLocations.studentArray = StudentLocation.arrayFromResults(results)
                    
                    completionHandler(success: true, error: nil)
                    
                } else {
                    completionHandler(success: false, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations results"]))
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
                    completionHandler(success: false, error: NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
}


