//
//  ViewController.swift
//  MeMeV1
//
//  Created by Andreas Talg on 03.09.15.
//  Copyright (c) 2015 Andreas Talg. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtBottom: UITextField!
    
    @IBOutlet weak var imgMeme: UIImageView!
    @IBOutlet weak var nvbMemeEditor: UINavigationBar!
    @IBOutlet weak var tlbMemeEditor: UIToolbar!
    
    
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTop.delegate = self
        txtBottom.delegate = self
        
        // Disable camera button if no camera available
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            btnCamera.enabled = false
        }
        
        setDefaults()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cancel button
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        
        setDefaults()
    }
    
    // Activity dialogue
    @IBAction func launchActivity(sender: UIBarButtonItem) {
        
        let myImage = createMemedImage()
        
        let activityController = UIActivityViewController (activityItems: [myImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activity, success, items, error) in
            self.save(myImage)
            activityController.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    // Imagepicker (Camera)
    @IBAction func pickImageCamera(sender: UIBarButtonItem) {
        let ctrlPicker = UIImagePickerController()
        ctrlPicker.delegate = self
        ctrlPicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(ctrlPicker, animated: true, completion: nil)
    }
    
    // Imagepicker (Album)
    @IBAction func pickImage(sender: AnyObject) {
        let ctrlPicker = UIImagePickerController()
        ctrlPicker.delegate = self
        ctrlPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(ctrlPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgMeme.image = image
            btnShare.enabled = true // Now it is possible to share
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Keyboard and textfields
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // Clear textfield only if it contains still the default texts
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if txtBottom.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if txtBottom.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Create memed image by overlaying image with text
    func createMemedImage() -> UIImage {
        
        // Hide toolbar and navbar (should not be in created image)
        tlbMemeEditor.hidden = true
        nvbMemeEditor.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar again
        tlbMemeEditor.hidden = false
        nvbMemeEditor.hidden = false
        
        return memedImage
    }
    
    // Used to set (or reset) default values for MeMeV1 Editor
    func setDefaults() {
        
        // Define default text attributes (
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]
        
        // Set textFields to defaults
        txtTop.defaultTextAttributes = memeTextAttributes
        txtTop.textAlignment = .Center
        txtTop.text = "TOP"
        
        txtBottom.defaultTextAttributes = memeTextAttributes
        txtBottom.textAlignment = .Center
        txtBottom.text = "BOTTOM"
        
        // Set button status
        btnShare.enabled = false // No image selected -> no sharing
        
        // Reset image
        self.imgMeme.image = nil
        
    }
    
    // Save Meme (at this stage no "real" saving)
    func save(memedImage:UIImage) {
        var meme = Meme(topText: txtTop.text!, bottomText: txtBottom.text!, originalImage: imgMeme.image!, memedImage: memedImage)
    }
    

}

