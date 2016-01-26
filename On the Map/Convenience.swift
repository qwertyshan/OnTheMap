//
//  Convenience.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/25/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import Foundation

// MARK: Convenience Class

class Convenience {
    
    class func showAlert(caller: UIViewController, error: NSError) {
        print((error.domain),(error.localizedDescription))
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        caller.presentViewController(alert, animated: true, completion: nil)
    }
    
}