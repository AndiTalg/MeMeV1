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

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true;
    }
    
    // Used to set (or reset) default values for MeMeV1 Editor
    func setDefaults() {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
        ]
        
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
    
    // Imagepicker (Album)
    @IBAction func pickImage(sender: AnyObject) {
        let ctrlPicker = UIImagePickerController()
        ctrlPicker.delegate = self
        ctrlPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(ctrlPicker, animated: true, completion: nil)
    }
  
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        
       setDefaults()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgMeme.image = image
            btnShare.enabled = true // Now it is possible to share
        }
    }
    
    
    // Keyboard
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


}

