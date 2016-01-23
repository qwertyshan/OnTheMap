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
    
    var studentLocations = [StudentLocation]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadLocations: UIBarButtonItem!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationsForMap ()   // Get locations from Parse and set local studentLocations array
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //getLocationsForMap ()   // Get locations from Parse and set local studentLocations array
    }
    
    // MARK: - IBActions
    
    // Get locations from Parse and rebuild the table
    @IBAction func reloadLocationsOnTouchUp(sender: AnyObject) {
        
        getLocationsForMap()
        
    }
    
    // MARK: TableView delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "studentCell"
        let studentLocation = studentLocations[indexPath.row]
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
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Open mediaURL
        let app = UIApplication.sharedApplication()
        if let toOpen = studentLocations[indexPath.row].mediaURL {
            app.openURL(NSURL(string: toOpen)!)
        }
    }
  /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    */
    // MARK: - Helper functions
    
    func getLocationsForMap () {
        
        OTMClient.sharedInstance().getStudentLocations() { (result, errorString) in
            
            print("ListViewController -> Called getStudentLocations. Error: \(errorString).") // debug
            
            if result != nil {
                print("Got student data")
                dispatch_async(dispatch_get_main_queue()) {
                    let locations = result!
                    self.studentLocations = locations
                    self.tableView.reloadData()
                }
            } else {
                print("Could not get student data")
            }
        }
    }
}