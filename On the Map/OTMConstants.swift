//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Parse Authorization
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Facebook Authorization
        static let FBAppID : String = "365362206864879"
        static let FBSuffix : String = "onthemap"
        
        // MARK: URLs
        static let UdacityBaseURLSecure : String = "https://www.udacity.com/api/"
        static let ParseBaseURLSecure : String = "https://api.parse.com/1/classes/StudentLocation"
        //static let FBBaseURLSecure : String = "https://www.themoviedb.org/authenticate/"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Udacity
        static let UdacityUserData = "users/{id}"
        static let UdacityPostSession = "session"
        static let UdacityDeleteSession = "session"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: StudentLocation
        static let objectId = "8ZExGR5uX8"
        static let uniqueKey = "1234"
        static let firstName = "Shantanu"
        static let lastName = "Rao"
        static let mapString = "Walnut Creek, CA"
        static let mediaURL = "http://www.shanrao.org"
        static let latitude = "37.906389"
        static let longitude = "-122.065"
        static let createdAt = "Feb 25, 2015, 01:10"
        static let updatedAt = "Mar 09, 2015, 23:34"
        static let studentResults = ["results"]
        
    }
    
}
