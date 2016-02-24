//
//  CreateUserVC.swift
//  FirebaseApp
//
//  Created by Nick on 2/24/16.
//  Copyright © 2016 Nicholas Smith. All rights reserved.
//

import UIKit

class CreateUserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imageSet = false
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imageSet = false
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageSet = true
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profileImg.image = image
        profileImg.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func createUser(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        DataService.ds.REF_BASE.createUser(username, password: password, withValueCompletionBlock: { error, result in
            
            if error != nil {
                // There was a problem creating this user account
                print(error.debugDescription)
                self.showErrorAlert("Could not create account", msg: "Try a different username or password")
            } else {
                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                
                DataService.ds.REF_BASE.authUser(username, password: password, withCompletionBlock: { err, authData in
                    let user = [
                        "username": username!,
                        "provider": authData.provider!
                    ]
                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                })
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            }
        })
        
    }



    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
