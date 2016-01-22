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
                if let results = JSONResult["session"] as? [String: AnyObject] {
                    OTMClient.sharedInstance().sessionID = results["id"] as? String
                    print("Session ID JSON: \(results)")
                    print("Session ID: \(OTMClient.sharedInstance().sessionID)")
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
                    if OTMClient.sharedInstance().sessionID == results {
                        OTMClient.sharedInstance().sessionID = nil
                        print("Session deleted for ID: \(results)")
                        completionHandler(success: true, error: nil)
                    } else {
                        print("Incorrect session returned for DELETE command. Returned ID: \(results)")
                        completionHandler(success: false, error: NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Incorrect session returned for DELETE command. Returned ID: \(results)"]))
                    }
                } else {
                    completionHandler(success: false, error: NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteSession"]))
                }
            }
        }
    }
    
    // MARK: PARSE - GETting StudentLocations
    
    func getStudentLocations(completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) -> Void {
        
        var studentLocations = [StudentLocation]()
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method : String = Methods.ParseGetStudentLocations
        let headers : [String:String] = [OTMClient.HeaderKeys.ParseAppID: OTMClient.Constants.AppID, OTMClient.HeaderKeys.ParseRESTAPIKey: OTMClient.Constants.RESTApiKey]
        
        /* 2. Make the request */
        taskForGETMethod(method, baseURLSecure: OTMClient.Constants.ParseBaseURLSecure, headers: headers) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult["results"] as? [[String : AnyObject]] {
                    //print("*******results in convenience function******")
                    //print(results)
                    
                    let studentLocations = StudentLocation.sharedInstance
                    studentLocations.studentArray = StudentLocation.arrayFromResults(results)
                    print("*******studentLocations in convenience function******")
                    print(studentLocations.studentArray)
                    print("*******END OF studentLocations in convenience function******")
                    
                    
                    completionHandler(result: studentLocations.studentArray, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations results"]))
                }
            }
        }
    }
}

    // MARK: GETing Public User Data
   /*
    func getUserData(userID: String, completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var mutableMethod : String = Methods.UdacityUserData
        mutableMethod = OTMClient.subtituteKeyInMethod(mutableMethod, key: OTMClient.URLKeys.UserID, value: userID)!
        
        /* 2. Make the request */
        let task = taskForGETMethod(mutableMethod) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult[OTMClient.JSONResponseKeys.StudentResults] as? [[String : AnyObject]] {
                    
                    let movies = StudentLocation..moviesFromResults(results)
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
    }

    */
    
    
    
    /*
    
    // MARK: POSTing (Creating) a Session
    
    func createSession(username: String, password: String) {
        
        // 1. Set the parameters
        
        // 2. Build the URL
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        // 3. Configure the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // 4. Make the request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Request Failed (Create Session).")
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5. Parse the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            // 6. Use the data
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        
        // 7. Start the request
        
        task.resume()
        
    }
    
    // MARK: DELETEing (Logging Out Of) a Session
    
    func deleteSession() {
        
        // 1. Set the parameters
        
        // 2. Build the URL
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        // 3. Configure the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // 4. Make the request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Request Failed (Delete Session).")
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5. Parse the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            // 6. Use the data
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        // 7. Start the request
        
        task.resume()
        
    }
    
    // MARK: GETing Public User Data
    
    func getUserData() {
        
        // 1. Set the parameters
        let userID = "3903878747"
        
        // 2. Build the URL
        let urlString = "https://www.udacity.com/api/users/"+userID
        let url = NSURL(string: urlString)!
        
        // 3. Configure the request
        let request = NSMutableURLRequest(URL: url)
        
        // 4. Make the request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Request Failed (Get User Data).")
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5. Parse the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            // 6. Use the data
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        // 7. Start the request
        
        task.resume()
        
    }
    
    func createFacebookSession() {
        
        // 1. Set the parameters
        
        // 2. Build the URL
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        // 3. Configure the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"rao.shantanu@gmail.com\", \"password\": \"oTtF1984\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // 4. Make the request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Reqest Failed (Create Session).")
                }
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5. Parse the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            // 6. Use the data
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        // 7. Start the request
        
        task.resume()
        
    }
    
    */


