//
//  ViewController.swift
//  MessengerApp
//
//  Created by Clavel Tosco on 9/28/16.
//  Copyright © 2016 React. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet var EmailField: UITextField!
    
    @IBOutlet var PassField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginBtnPressed(sender: AnyObject) {
        Login(EmailField.text!, password: PassField.text!)
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.stringForKey("email") != nil {
        let email = userDefaults.stringForKey("email")
        let password = userDefaults.stringForKey("password")
        Login(email!, password: password!)
        }
    }

    func Login(email : String, password : String){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: {
            user, error in
            
            if error != nil {
                print("Error")
            }
            else{
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("Users").child(uid!).observeEventType(.Value, withBlock: {
                    snapshot in
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(self.EmailField.text!, forKey: "email")
                    userDefaults.setValue(self.PassField.text!, forKey: "password")
                    
                    if snapshot.childrenCount == 0{
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Setup")
                        self.presentViewController(vc!, animated: true, completion: nil)
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Profiles")
                        self.presentViewController(vc!, animated: true, completion: nil)
                    }
                })
                
                
                
            }
        })
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
        FIRAuth.auth()?.createUserWithEmail(EmailField.text!, password: PassField.text!, completion:  {
            user, error in
            
            if error != nil{
                print("Something is wrong")
            }
            else{
                print("User Is Created")
                self.Login(self.EmailField.text!, password: self.PassField.text!)
            }
        })
    }
}

