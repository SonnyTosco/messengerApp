//
//  Profiles.swift
//  MessengerApp
//
//  Created by Clavel Tosco on 9/28/16.
//  Copyright © 2016 React. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

struct user {
    let username : String!
    let profileImageURL : String!
    let uid : String!
}

class ProfileVC: UITableViewController {
    
    var users = [user]()
    
    override func viewDidLoad() {
        
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("Users").queryOrderedByKey().observeEventType(.ChildAdded, withBlock:  {
            snapshot in
            
            print(snapshot)
            
            let username = snapshot.value!["username"] as! String
            let profileImageURL = snapshot.value!["profileImageURL"] as! String
            let uid = snapshot.value!["uid"] as! String
            
            self.users.append(user(username: username, profileImageURL: profileImageURL, uid: uid))
            
            self.tableView.reloadData()
            
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let imageView = cell?.viewWithTag(1) as! UIImageView
        imageView.alpha = 0
        
        let nameLbl = cell?.viewWithTag(2) as! UILabel
        nameLbl.alpha = 0
        
        
        dispatch_async(dispatch_get_main_queue(), {
            let imageData = NSData(contentsOfURL: NSURL(string: self.users[indexPath.row].profileImageURL)!)
            imageView.image = UIImage(data: imageData!)
            nameLbl.text = self.users[indexPath.row].username
            
            UIView.animateWithDuration(0.5, animations: {
                imageView.alpha = 1
                nameLbl.alpha = 1
            })
        })
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentChatUserID = users[indexPath.row].uid
    }
}
