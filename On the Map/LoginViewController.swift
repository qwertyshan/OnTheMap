//
//  LoginViewController.swift
//  On the Map
//
//  Created by Shantanu Rao on 1/19/16.
//  Copyright © 2016 Shantanu Rao. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    // MARK: View load functions
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.emailTextField.frame.height))
        //emailTextField.leftView = paddingView
        //emailTextField.leftViewMode = UITextFieldViewMode.Always
        //let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.passwordTextField.frame.height))
        //passwordTextField.leftView = paddingView
        //passwordTextField.leftViewMode = UITextFieldViewMode.Always
        debugTextLabel.hidden = true

    }
    
    // MARK: View settings
    

    
    // MARK: Text Field Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing")
        textField.resignFirstResponder()
    }
    
    // MARK: Keyboard notification methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //if passwordTextField.isFirstResponder() {
        //    view.frame.origin.y = -getKeyboardHeight(notification)
        //}
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    // MARK: Actions
    
    @IBAction func loginTouchUpInside(sender: AnyObject) {
        if emailTextField.text!.isEmpty {
            debugTextLabel.hidden = false
            debugTextLabel.text = "Email empty"
        } else if passwordTextField.text!.isEmpty {
            debugTextLabel.hidden = false
            debugTextLabel.text = "Password empty"
        } else {
            OTMClient.sharedInstance().postSession(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                if success == true {
                    print("Logged in")
                    self.completeLogin()
                } else {
                    print("Failed login")
                    self.debugTextLabel.hidden = false
                    self.debugTextLabel.text = "Login failed"
                }
                
            }
        }
    }
    
    @IBAction func signupTouchUpInside(sender: AnyObject) {
    }
    
    @IBAction func loginFacebookTouchUpInside(sender: AnyObject) {
    }
    
    // MARK: Convenience methods
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
}



