//
//  MapViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//
    
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reloadLocations: UIBarButtonItem!
    @IBOutlet weak var addLocation: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    // MARK: Load view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationsForMap ()   // Get locations from Parse and set them on map annotations
        mapView.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBActions
    
    // Get locations from Parse and set them on map annotations
    @IBAction func reloadLocationsOnTouchUp(sender: AnyObject) {
        
        // Remove existing annotations
        for annotation : MKAnnotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        // Get new locations and set annotations
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
                    
                    let alert = UIAlertController(title: "Error", message: "Could not delete/logout session.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                    self.presentViewController(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: - Helper functions
    
    func getLocationsForMap () {
        
        OTMClient.sharedInstance().getStudentLocations() { (success, errorString) in
            
            print("MapViewController -> Called getStudentLocations. Error: \(errorString).") // debug 
            
            if success {
                print("Got student data")
                dispatch_async(dispatch_get_main_queue()) {
                    self.setLocationsOnMap()
                }
            } else {
                print("Could not get student data")
                
                let alert = UIAlertController(title: "Error", message: "Could not get student data.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            }
        }
    }
    
    func setLocationsOnMap () {
        
        var annotations = [MKPointAnnotation]()
            
        for location in StudentLocation.sharedInstance.studentArray {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude! as Float)
            let long = CLLocationDegrees(location.longitude! as Float)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName! as String
            let last = location.lastName! as String
            let mediaURL = location.mediaURL! as String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
}