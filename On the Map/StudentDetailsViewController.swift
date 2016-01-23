//
//  StudentDetailsViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/20/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit
import MapKit

// MARK: - StudentDetailsViewController: UIViewController

class StudentDetailsViewController: UIViewController {
    
    enum viewState {
        case One
        case Two
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var fullView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topView1: UIView!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var middleView1: UIView!
    @IBOutlet weak var bottomView1: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView2: UIView!
    @IBOutlet weak var bottomView2: UIView!
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setViewState(.One)
    }
    
    // MARK: 
    
    @IBAction func cancelOnTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnTouchUp(sender: AnyObject) {
    }
    
    @IBAction func submitOnTouchUp(sender: AnyObject) {
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
            print("viewState.One")
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
}

