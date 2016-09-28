//
//  SetupView.swift
//  MessengerApp
//
//  Created by Clavel Tosco on 9/28/16.
//  Copyright © 2016 React. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class setupView : UIViewController {
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var nameTextField: UITextField!
    
    var captureSession = AVCaptureSession()
    var stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var profileImage = UIImage()
    
    override func viewDidLoad() {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            if device.position == AVCaptureDevicePosition.Front {
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(stillImageOutput) {
                            captureSession.addOutput(stillImageOutput)
                            captureSession.startRunning()
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                            cameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.bounds = cameraView.frame
                            previewLayer.position = CGPoint(x: cameraView.frame.width / 2, y: cameraView.frame.height / 2)
                        }
                    }
                }
                catch{
                    
                }
            }
        }
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:  {
                buffer, error in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                self.profileImage = UIImage(data: imageData)!
                
            })
        }
    }
    
    @IBAction func Submit(sender: AnyObject) {
        
        if profileImage != 0 && nameTextField.text != nil {
        
        let storageRef = FIRStorage.storage().reference()
        let databaseRef = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let profileImageData = UIImageJPEGRepresentation(profileImage, 0.4)
        
        let profileImageRef = storageRef.child("ProfileImages/\(uid!)/profileImage.jpg")
        profileImageRef.putData(profileImageData!, metadata: nil) {
            metadata, error in
            if error != nil{
                print("error")
            }
            else{
                let downloadURL = metadata?.downloadURL()?.absoluteString
                print(downloadURL)
                let username = self.nameTextField.text
                let user : [NSObject : AnyObject] = ["uid" : uid!,
                                                     "username" : username!,
                                                     "profileImageURL" : downloadURL!]
                let childUpdates = ["Users/\(uid!)/" : user]
                databaseRef.updateChildValues(childUpdates)
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Profiles")
                self.presentViewController(vc!, animated: true, completion: nil)
            }
        }
        }
    }
}
