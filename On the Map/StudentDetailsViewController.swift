//
//  StudentDetailsViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - StudentDetailsViewController: UIViewController

class StudentDetailsViewController: UIViewController, UITextFieldDelegate {
    
    var studentLocation = StudentLocation.sharedInstance
    
    enum viewState {
        case One
        case Two
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var fullView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topView1: UIView!
    @IBOutlet weak var middleView1: UIView!
    @IBOutlet weak var bottomView1: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView2: UIView!
    @IBOutlet weak var bottomView2: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterURLTextField: UITextField!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitURLButton: UIButton!
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterURLTextField.delegate = self
        enterURLTextField.delegate = self
        
        studentLocation.firstName = "Shantanu"
        studentLocation.lastName = "Rao"
        
        setViewState(.One)
        findOnMapButton.layer.cornerRadius = 4
        submitURLButton.layer.cornerRadius = 4
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: IBActions
    
    @IBAction func cancelOnTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTouchUp(sender: AnyObject) {

        
        let address = enterLocationTextField.text
        
        if let address = address {
            
            // Geolocate address
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                
                if let placemark = placemarks?[0] { // If there's a result, pick first location in array
                    self.studentLocation.latitude = Float(placemark.location!.coordinate.latitude)
                    self.studentLocation.longitude = Float(placemark.location!.coordinate.longitude)
                    self.studentLocation.mapString = address
                    
                    self.setViewState(viewState.Two)    // Change view
                    self.activityIndicator.startAnimating() // start activity indicator
                    
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))   // Place pin on mapView
                    self.mapView.camera.altitude = 50000.0
                    self.mapView.setCenterCoordinate(placemark.location!.coordinate, animated: true)
                    
                    self.activityIndicator.stopAnimating()  // stop activity indicator
                    
                } else if let error = error {
                    print(error.description)
                    let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil);
                    
                } else {
                    print("Could not complete geocoding request.")
                    let alert = UIAlertController(title: "Error", message: "Could not complete geocoding request.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil);
                }
            })
            
        } else {
            print("No location entered")
        }
        
    }
    
    @IBAction func submitOnTouchUp(sender: AnyObject) {
        
        if let url = enterURLTextField.text {
            
            if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
                studentLocation.mediaURL = "http://" + url
            } else {
                studentLocation.mediaURL = url
            }
            postToParse()   // post StudentLocation to Parse
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            print("No URL entered")
        }
    }
    
    // MARK: Helper functions
    
    func setViewState(viewState: StudentDetailsViewController.viewState) {
        switch viewState {
        case .One:
            fullView.backgroundColor = UIColor(white:0.8, alpha:1.0)    // set bg color to light gray
            cancelButton.setTitleColor(UIColor(red:0.2, green:0.4, blue:0.6, alpha:1.0), forState: .Normal) // set title color to this bluish tinge
            topView1.hidden     = false
            middleView1.hidden  = false
            bottomView1.hidden  = false
            mapView.hidden      = true
            topView2.hidden     = true
            bottomView2.hidden  = true
            
        case .Two:
            fullView.backgroundColor = UIColor(red:0.2, green:0.4, blue:0.6, alpha:1.0) // set bg color to this bluish tinge
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal) // set title color to white
            topView1.hidden     = true
            middleView1.hidden  = true
            bottomView1.hidden  = true
            mapView.hidden      = false
            topView2.hidden     = false
            bottomView2.hidden  = false
        }
    }
    
    func postToParse() {
        
        print(studentLocation.uniqueKey, studentLocation.firstName, studentLocation.lastName, studentLocation.mapString, studentLocation.mediaURL, studentLocation.latitude, studentLocation.longitude)

        
        
        OTMClient.sharedInstance().postStudentLocation(studentLocation) { (success, errorString) in
            
            if errorString != nil {
                print(errorString?.description)
                let alert = UIAlertController(title: "Error", message: errorString?.description, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            } else if success {
                print("StudentLocation posted")
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                print("Could not post StudentLocation.")
                
                let alert = UIAlertController(title: "Error", message: "Could not post location record to Parse.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            }
        }
    }
}

