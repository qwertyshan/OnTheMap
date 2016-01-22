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
        
        // MARK: Parse
        static let ParseGetStudentLocations = ""
        static let ParsePostStudentLocations = ""
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let UserID = "id"
        static let Limit = "limit"
        static let Skip = "skip"
        static let UpdatedAtDefault = "updatedAt"
        static let UpdatedAtReverse = "-updatedAt"
        
    }
    
    struct HeaderKeys {
        
        static let ParseAppID = "X-Parse-Application-Id"
        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
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
        static let studentResults = "results"
        
    }
    
}
