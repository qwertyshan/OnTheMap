//
//  ListViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit

// MARK: - ListViewController: UIViewController

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadLocations: UIBarButtonItem!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationsForMap ()   // Get locations from Parse and set local studentLocations array
        tableView.delegate = self
    }

    // MARK: - IBActions
    
    // Get locations from Parse and rebuild the table
    @IBAction func reloadLocationsOnTouchUp(sender: AnyObject) {
        
        getLocationsForMap()
        
    }
    
    @IBAction func logoutOnTouchUp(sender: AnyObject) {
        
        // Check which auth service was used to log in
        
        if OTMClient.sharedInstance().authServiceUsed == OTMClient.AuthService.Facebook {
            
            FBSDKLoginManager().logOut()
            print("Facebook logout")
            dismissViewControllerAnimated(true, completion: nil)
            
        } else {    // if Udacity was used to log in
            
            OTMClient.sharedInstance().deleteSession() { (success, errorString) in
                
                print("MapViewController -> Called deleteSession. Error: \(errorString).") // debug
                
                if success {
                    print("Session Deleted")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    print("Could not delete/logout session.")
                    
                    let alert = UIAlertController(title: "Error", message: "Could not logout from Udacity.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "studentCell"
        let studentLocation = StudentLocation.sharedInstance.studentArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        let first = studentLocation.firstName! as String
        let last = studentLocation.lastName! as String
        let mediaURL = studentLocation.mediaURL! as String
        cell.textLabel!.text = "\(first) \(last)"
        cell.imageView!.image = UIImage(named: "pin")
        cell.detailTextLabel!.text = mediaURL
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.sharedInstance.studentArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Open mediaURL
        let app = UIApplication.sharedApplication()
        if let toOpen = StudentLocation.sharedInstance.studentArray[indexPath.row].mediaURL {
            app.openURL(NSURL(string: toOpen)!)
        }
    }

    // MARK: - Helper functions
    
    func getLocationsForMap () {
        
        OTMClient.sharedInstance().getStudentLocations() { (success, errorString) in
            
            print("ListViewController -> Called getStudentLocations. Error: \(errorString).") // debug
            
            if success {
                print("Got student data")
                dispatch_async(dispatch_get_main_queue()) {

                    self.tableView.reloadData()
                }
            } else {
                print("Could not get student data")
                
                let alert = UIAlertController(title: "Error", message: "Could not get student data.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}