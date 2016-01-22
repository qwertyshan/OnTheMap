//
//  StudentLocation.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation

class StudentLocation: NSObject {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Float?
    var longitude: Float?
    var createdAt: String?
    var updatedAt: String?
    
    static let sharedInstance = StudentLocation()
    
    var studentArray = [StudentLocation]()
    
    // MARK: Initializers
    
    // Construct a StudentLocation from a dictionary 
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[OTMClient.JSONResponseKeys.objectId] as? String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[OTMClient.JSONResponseKeys.lastName] as? String
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as? String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.mediaURL] as? String
        longitude = dictionary[OTMClient.JSONResponseKeys.longitude] as? Float
        latitude = dictionary[OTMClient.JSONResponseKeys.latitude] as? Float
        createdAt = dictionary[OTMClient.JSONResponseKeys.createdAt] as? String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.updatedAt] as? String
    }
    
    override init() {
        objectId = nil
        uniqueKey = nil
        firstName = nil
        lastName = nil
        mapString = nil
        mediaURL = nil
        longitude = nil
        latitude = nil
        createdAt = nil
        updatedAt = nil 
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func arrayFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}


