//
//  LoginViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/19/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginFacebookButton: FBSDKLoginButton!
    
    // MARK: View load functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginFacebookButton.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        checkFacebookLoginStatus()
    }
    
    // MARK: View settings
    
    func checkFacebookLoginStatus () {
        
        // Facebook login
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in
            print("User Logged In. Access token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
            completeLogin(OTMClient.AuthService.Facebook)
        } else {
            loginFacebookButton.readPermissions = ["email"]
        }
    }
    
    // MARK: Text Field Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }

    // MARK: Actions
    
    @IBAction func loginTouchUpInside(sender: AnyObject) {
        OTMClient.sharedInstance().postSession(emailTextField.text!, password: passwordTextField.text!) { (success, error) in
            if success == true {
                print("Logged in")
                dispatch_async(dispatch_get_main_queue(), {
                    self.completeLogin(OTMClient.AuthService.Udacity)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    Convenience.showAlert(self, error: error!)
                })
            }
        }
    }
    
    @IBAction func signupTouchUpInside(sender: AnyObject) {
        // Open Udacity sign-up page in browser
        let toOpen = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        let app = UIApplication.sharedApplication()
        app.openURL(toOpen!)
    }
    
    // MARK: Convenience methods
    
    func completeLogin(service: OTMClient.AuthService) {
        
        emailTextField.text = ""        // Clear login text fields
        passwordTextField.text = ""
        
        OTMClient.sharedInstance().authServiceUsed = service
        let controller = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Facebook login delegate methods
    
    func loginButton(loginFacebookButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            print("Failed Facebook login")
            dispatch_async(dispatch_get_main_queue(), {
                Convenience.showAlert(self, error: error!)
            })
        } else if result.isCancelled {
            print("Cancelled Facebook login")
        }
        else {
            if result.grantedPermissions.contains("email")
            {
                completeLogin(OTMClient.AuthService.Facebook)
                print("Successful Facebook login")
            }
        }
    }
    
    func loginButtonDidLogOut(loginFacebookButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}

