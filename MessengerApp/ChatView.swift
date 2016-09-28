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
    
    
    override func viewDidLoad() {
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
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}