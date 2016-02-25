//
//  CreateUserVC.swift
//  FirebaseApp
//
//  Created by Nick on 2/24/16.
//  Copyright © 2016 Nicholas Smith. All rights reserved.
//

import UIKit
import Alamofire

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
        let username = usernameTextField.text!
        let imgUrl = profileImg
        
        // @TODO: NEED TO PULL pw and username from previous view
        let password = passwordTextField.text!
        let email = "\(username)@gmail.com"
        
        print(imgUrl)
        
        DataService.ds.REF_USERS.createUser(email, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    print(error.debugDescription)
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    
                    DataService.ds.REF_USERS.childByAppendingPath(uid).childByAppendingPath("username").setValue(username)
                    DataService.ds.REF_USERS.childByAppendingPath(uid).childByAppendingPath("provider").setValue("password")
                    
                    self.uploadImage(uid!)
                    
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)

                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
        })
        
    }
    
    func uploadImage(uid: String) {
        if let img = profileImg.image where imageSet == true {
            
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlStr)!
            let imgData = UIImageJPEGRepresentation(img, 0.2)!
            let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
            
            Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: keyData, name: "key")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                
                }) { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    if let imgLink = links["image_link"] as? String {
                                        DataService.ds.REF_USERS.childByAppendingPath(uid).childByAppendingPath("imageUrl").setValue(imgLink)
                                    }
                                }
                            }
                        })
                        
                    case .Failure(let error):
                        print(error)
                    }
            }//Alamofire.upload
            
        }

    }



    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
