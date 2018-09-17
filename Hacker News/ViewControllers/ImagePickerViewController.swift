//
//  ImagePickerViewController.swift
//  Hacker News
//
//  Created by Admin on 17/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation

class ImagePickerViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,CustomGalleryViewdelegate {
   
    
    
var limPicker:CustomGalleryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func OpenCamera(sender: AnyObject) {
        var actionSheet:UIActionSheet
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Select photo from library", "Take a picture", "Take a video")
        } else {
            actionSheet = UIActionSheet(title: nil , delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Select photo from library")
        }
        actionSheet.delegate = self
        actionSheet.show(in: self.view)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeImage as String {
            limPicker = CustomGalleryView(nibName: "CustomGalleryView", bundle: Bundle.main)
            limPicker!.setSourceType(type: picker.sourceType)
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            limPicker!.addImage(image: image)
            limPicker!.delegate = self
            
            self.navigationController!.pushViewController(limPicker!, animated: true)
            picker.dismiss(animated: true, completion: {})
        } else {
            self.dismiss(animated: true, completion: {})
            print("Video Taken!!!!");
        }
    }
    func cleanProcessOnPicking() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func cancelPicking(picker: CustomGalleryView) {
        self.navigationController!.popToViewController(self, animated: true)
    }
    func donePicking(picker: CustomGalleryView, didPickedUrls: [String]) {
        DispatchQueue.main.async {
            self.cleanProcessOnPicking()
        }
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print("Title : \(String(describing: actionSheet.buttonTitle(at: buttonIndex)))")
        print("Button Index : \(buttonIndex)")
        
        if buttonIndex == 0 { return }
        
        let imageController = UIImagePickerController()
        imageController.isEditing = false
        imageController.delegate = self;
        
        if( buttonIndex == 1){
            imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else if(buttonIndex == 2){
            imageController.sourceType = UIImagePickerControllerSourceType.camera
            imageController.showsCameraControls = true
        } else {
            imageController.sourceType = UIImagePickerControllerSourceType.camera
            imageController.mediaTypes = [kUTTypeMovie] as [String]
            imageController.allowsEditing = false
            imageController.showsCameraControls = true
        }
        
       self.present(imageController, animated: true, completion: nil)
    }
}
