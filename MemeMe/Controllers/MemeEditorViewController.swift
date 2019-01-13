//
//  ViewController.swift
//  MemeMe
//
//  Created by Arwa Alzeaagi on 14/11/2018.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    var isTopDefultText : Bool = true
    var isButtomDefultText : Bool = true
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        shareButton.isEnabled = false
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        textFieldsSetup(topTextField)
        textFieldsSetup(bottomTextField)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
        
    }
    func textFieldsSetup(_ textField : UITextField){
        textField.delegate = self
        let memeTextAttributes:[NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black ,
            .font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -3]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    @objc func keyboardWillHide (notification: NSNotification){
        if !topTextField.isEditing {
            view.frame.origin.y = 0
        }
        
    }
    @objc func keyboardWillShow (notification: NSNotification)
    {
        if !topTextField.isEditing {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let offest = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            if keyboardSize.cgRectValue.height == offest.cgRectValue.height {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.cgRectValue.height })
            }else {
                UIView.animate(withDuration: 0.1, animations: {() -> Void in
                    self.view.frame.origin.y += keyboardSize.cgRectValue.height
                })
            }
            
        }
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField) {
        if(textField == topTextField && isTopDefultText){
            textField.text = ""
            isTopDefultText = false
        }
        
        if(textField == bottomTextField && isButtomDefultText){
            textField.text = ""
            isButtomDefultText = false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        view.endEditing(true)
        return true
    }
    
    
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(from: .camera)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, originImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    func generateMemedImage() -> UIImage {
        hidToolbar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hidToolbar(false)
        return memedImage
    }
    
    
    @IBAction func share(_ sender: Any) {
        if imagePickerView.image != nil{
            let viewActivityVC = UIActivityViewController(activityItems:[generateMemedImage() as Any]  , applicationActivities: nil)
            viewActivityVC.popoverPresentationController?.sourceView = self.view
            viewActivityVC.completionWithItemsHandler = {
                (activityType, completed, returnedItems, activityError) in

                if completed {
                    self.save()
                }
            }
            self.present(viewActivityVC, animated: true, completion: nil)
            
        }
    }
    
    func hidToolbar (_ isHid : Bool){
        topToolbar.isHidden = isHid
        bottomToolbar.isHidden = isHid
    }
    
    
    
}
extension MemeEditorViewController:  UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.shareButton.isEnabled = true
            self.imagePickerView.contentMode = .scaleAspectFit
            self.imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
        
    }
}



