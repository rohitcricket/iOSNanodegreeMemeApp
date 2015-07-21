//
//  ViewController.swift
//  My Memes
//
//  Created by ROHIT GUPTA on 7/20/15.
//  Copyright (c) 2015 ROHIT GUPTA. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController() //global scope for accessability to functions.
    
    // Setup Meme font
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.5
    ]
    
    // Outlets


    @IBOutlet weak var memeImage: UIImageView!

    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    
    
    // Actions
    
    
    @IBAction func loadImageAlbum(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func loadImageCamera(sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {

                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
          
        } else {
            let controller = UIAlertController()
            controller.title = "Alert"
            controller.message = "Camera is not available"
            
            // Dismiss the view controller after the user taps “ok”
            let okAction = UIAlertAction (title:"ok", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            controller.addAction(okAction)
            self.presentViewController(controller, animated: true, completion:nil)
        }
    }
    
    @IBAction func activityView(sender: UIBarButtonItem) {
        
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        
        // Setting up Text
        
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        
        self.topText.textAlignment = .Center
        self.bottomText.textAlignment = .Center
        
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Keyboard setup
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // Generating Meme Object
    
    struct Meme {
        var topText:String?
        var bottomText:String?
        var originalImage:UIImage?
        var memedImage:UIImage!
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        return memedImage
    }
    



}

