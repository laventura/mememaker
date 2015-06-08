//
//  EditorViewController.swift
//  MemeMaker
//
//  Created by Atul Acharya on 6/6/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UINavigationBar!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var receivedMeme: Meme?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegates
        topText.delegate = self
        bottomText.delegate = self
        
        // text attributes
        // Create meme font
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        topText.textAlignment = .Center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = .Center
        
        activityButton.enabled = false // initially
        
        // see if Camera available?
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            cameraButton.enabled = false
        }
    } // viewdidload
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Utilities
    
    
    
    // MARK: - Keyboard
    func keyboardWillShow(notifcation: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notifcation)
        }
    }
    
    func keyboardWillHide(notifcation: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notifcation)
        }
    }
    
    // Get the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
    // MARK: - TextField
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if topText.text == "TOP" {
            topText.text = ""
        } else if bottomText.text == "BOTTOM" {
            bottomText.text = ""
        }
    }
    
    // MARK: - Actions
    
    @IBAction func activityPressed(sender: UIBarButtonItem) {
        let memedImage = self.saveMeme()
        
        // pass along the meme to the VC
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { (activityType: String!, completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) in
            if completed {
                // TODO: there should be a better way here..
                self.presentTabController()
            }
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func chooseAlbum(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func chooseCamera(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate   = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - Picker Controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = pickedImage
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        activityButton.enabled = true
        
    }
    
    // MARK: - Utilities
    func presentTabController() {
        var tabController = self.storyboard?.instantiateViewControllerWithIdentifier("IDTabBarController") as UITabBarController
        self.presentViewController(tabController, animated: true, completion: nil)
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    func saveMeme() -> UIImage {
        let memedImage = generateMemedImage()
        
        var theMeme = Meme(uuid: NSUUID().UUIDString,
            top: topText.text!, bottom: bottomText.text!,
            originalImage: self.previewImageView.image!,
            memedImage: memedImage)
        
        // store the meme
        self.appDelegate().memes.append(theMeme)
        
        return memedImage
    }
    
    func generateMemedImage() -> UIImage {
        // hide toolbars
        navBar.hidden = true
        bottomBar.hidden = true
        
        // render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // unhide toolbars
        navBar.hidden = false
        bottomBar.hidden = false

        return memedImage
    }
    
    
    // MARK:

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
