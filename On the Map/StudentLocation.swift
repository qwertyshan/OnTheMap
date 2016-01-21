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
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float?
    var longitude: Float?
    var createdAt: String?
    var updatedAt: String?
    
    // MARK: Initializers
    
    // Construct a StudentLocation from a dictionary 
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[OTMClient.JSONResponseKeys.objectId] as? String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.mediaURL] as! String
        longitude = Float(dictionary[OTMClient.JSONResponseKeys.longitude as String] as! String)
        latitude = Float(dictionary[OTMClient.JSONResponseKeys.latitude as String] as! String)
        createdAt = dictionary[OTMClient.JSONResponseKeys.createdAt] as? String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.updatedAt] as? String
    }
    
    // Initialize a StudentLocation object
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, longitude: Float, latitude: Float) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}
