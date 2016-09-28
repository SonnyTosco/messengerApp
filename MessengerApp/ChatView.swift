//
//  ChatView.swift
//  MessengerApp
//
//  Created by Clavel Tosco on 9/28/16.
//  Copyright © 2016 React. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth
import FirebaseDatabase

var currentChatUserID = String()

struct post {
    let username : String!
    let bodyText : String!
}

class ChatView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [post]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func postSomething(sender: AnyObject) {
        
        if textField.text != nil{
            
            let databaseRef = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            let post = ["uid" : uid!,
                        "username" : userName,
                        "bodyText" : textField.text!
                        ]
            databaseRef.child("Posts").child(currentChatUserID).childByAutoId().setValue(post)
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Posts").child(currentChatUserID).queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let username = snapshot.value!["username"] as! String
            let bodyText = snapshot.value!["bodyText"] as! String
            
            self.posts.insert(post(username: username, bodyText: bodyText), atIndex: 0)
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        var nameLbl = cell?.viewWithTag(1) as! UILabel
        nameLbl.text = posts[indexPath.row].username
        var bodyLbl = cell?.viewWithTag(2) as! UITextView
        bodyLbl.text = posts[indexPath.row].bodyText
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}