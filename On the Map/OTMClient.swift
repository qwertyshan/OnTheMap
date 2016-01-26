//
//  OTMClient.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation

class OTMClient : NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication service */
    var authServiceUsed: AuthService?
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, baseURLSecure: String, parameters: [String: AnyObject]?, headers: [String:String]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL and configure the request */
      
        var urlString: String
        if let parameters = parameters {
            urlString = baseURLSecure + method + OTMClient.escapedParameters(parameters)
        } else {
            urlString = baseURLSecure + method
        }
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            OTMClient.manageErrors(data, response: response, error: error, completionHandler: completionHandler)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
    
            if let data = data {
                
                var newData: NSData
                
                if method.containsString("users") {
                    newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                } else {
                    newData = data
                }
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, baseURLSecure: String, headers: [String:String]?, jsonBody: [String:AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = baseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let jsonBody = jsonBody {
            do {
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            }
        } else {
            // Do nothing
        }
        
        print(request.allHTTPHeaderFields)
        print(NSString(data: request.HTTPBody!, encoding:NSUTF8StringEncoding)!)
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            OTMClient.manageErrors(data, response: response, error: error, completionHandler: completionHandler)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            if let data = data {
            
                var newData: NSData
                
                switch method {
                // If requesting method is for Udacity, shift data by 5 characters
                case OTMClient.Methods.UdacityPostSession:
                    newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                default:
                    newData = data
                }
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL and configure the request */
        var baseURLSecure = "https://"
        switch method {
        case OTMClient.Methods.UdacityPostSession, OTMClient.Methods.UdacityDeleteSession:
            baseURLSecure = Constants.UdacityBaseURLSecure
        default:
            baseURLSecure = Constants.ParseBaseURLSecure
        }
        let urlString = baseURLSecure + method
        let url = NSURL(string: urlString)!
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
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            OTMClient.manageErrors(data, response: response, error: error, completionHandler: completionHandler)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            if let data = data {
            
                var newData: NSData
                
                switch method {
                    // If requesting method is for Udacity, shift data by 5 characters
                case OTMClient.Methods.UdacityPostSession, OTMClient.Methods.UdacityDeleteSession:
                    newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                default:
                    newData = data
                }
                OTMClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    class func manageErrors(data: NSData?, response: NSURLResponse?, error: NSError?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            print("Error: There was an error with your request: \(error)")
            let modifiedError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: error!.localizedDescription])
            completionHandler(result: nil, error: modifiedError)
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode == 403 {
                    print("Authentication Error: Status code: \(response.statusCode)!")
                    completionHandler(result: nil, error: NSError(domain: "Authentication Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status code: \(response.statusCode)!"]))
                } else {
                    print("Server Error: Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, error: NSError(domain: "Server Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]))
                }
            } else if let response = response {
                print("Server Error: Your request returned an invalid response! Response: \(response)!")
                completionHandler(result: nil, error: NSError(domain: "Server Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]))
            } else {
                print("Server Error: Your request returned an invalid response!")
                completionHandler(result: nil, error: NSError(domain: "Server Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]))
            }
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let _ = data else {
            print("Network Error: No data was returned by the request!")
            completionHandler(result: nil, error: NSError(domain: "Network Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"]))
            return
        }
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
}