//
//  LoginViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/2/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var containingScrollView:TPKeyboardAvoidingScrollView!
    
    var usernameTextField:UITextField!
    var passwordTextField:UITextField!
    
    var loginButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(PFUser.currentUser() != nil){
            self.performSegueWithIdentifier("LoggedIn", sender: nil)
        }
        else{
            self.navigationItem.title = "Transtory"
            
            self.containingScrollView = TPKeyboardAvoidingScrollView(frame: self.view.frame)
            self.containingScrollView.backgroundColor = UIColor.whiteColor()
            self.view = self.containingScrollView
            
            self.usernameTextField = UITextField(frame: CGRectZero)
            self.usernameTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.usernameTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
            self.usernameTextField.autocorrectionType = UITextAutocorrectionType.No
            self.view.addSubview(self.usernameTextField)
            
            self.passwordTextField = UITextField(frame: CGRectZero)
            self.passwordTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.passwordTextField.secureTextEntry = true
            self.passwordTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)
            self.passwordTextField.delegate = self
            self.passwordTextField.returnKeyType = UIReturnKeyType.Go
            self.passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
            self.view.addSubview(self.passwordTextField)
            
            self.loginButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            self.loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.loginButton.frame = CGRectZero
            self.loginButton.setTitle("Login", forState: UIControlState.Normal)
            self.loginButton.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.containingScrollView.addSubview(self.loginButton)
            
            var metricsDictionary = ["sideMargin":7.5]
            var viewsDictionary = ["usernameTextField":self.usernameTextField, "passwordTextField":self.passwordTextField, "loginButton":self.loginButton]
            
            var usernameTextFieldHConstraint = NSLayoutConstraint(item: self.usernameTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.view.addConstraint(usernameTextFieldHConstraint)
            
            var usernameTextFieldHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[usernameTextField]-15-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            self.view.addConstraints(usernameTextFieldHConstraints)
            
            var passwordTextFieldHConstraint = NSLayoutConstraint(item: self.passwordTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.view.addConstraint(passwordTextFieldHConstraint)
            
            var verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=50-[usernameTextField(50)]-15-[passwordTextField(50)]-30-[loginButton]->=0-|", options: NSLayoutFormatOptions.AlignAllLeft | NSLayoutFormatOptions.AlignAllRight, metrics: metricsDictionary, views: viewsDictionary)
            self.view.addConstraints(verticalConstraints)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.passwordTextField && string == "\n"{
            textField.resignFirstResponder()
            self.processLogin()
            return false
        }
        else{
            return true
        }
    }
    
    func loginButtonPressed(){
        println("Login Button Pressed")
        self.processLogin()
    }
    
    func processLogin(){
        if self.usernameTextField.text != nil && self.passwordTextField.text != nil{
            PFUser.logInWithUsernameInBackground(self.usernameTextField.text, password:self.passwordTextField.text) {
                (user, error) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    PFInstallation.currentInstallation()["currentUser"] = PFUser.currentUser()
                    PFInstallation.currentInstallation().saveInBackgroundWithBlock(nil)
                    self.performSegueWithIdentifier("LoggedIn", sender: nil)
                } else {
                    // The login failed. Check error to see why.
                    self.loginButton.enabled = true
                    self.usernameTextField.enabled = true
                    self.passwordTextField.enabled = true
                }
            }

        }
        else{
            println("missing information")
        }
        
    }
}
