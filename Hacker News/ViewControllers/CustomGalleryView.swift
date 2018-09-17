//
//  CustomGalleryViewController.swift
//  Hacker News
//
//  Created by Admin on 17/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import MobileCoreServices
import MediaPlayer

protocol CustomGalleryViewdelegate:class {
    func donePicking(picker: CustomGalleryView, didPickedUrls: [String])
    func cancelPicking(picker: CustomGalleryView)
}

class CustomGalleryView: UIViewController,UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    var pickerController:UIImagePickerController?
    var sourceType : UIImagePickerControllerSourceType?
    var loadedImages: [UIImage] = []
    var selectedIndex : Int = -1
    @IBOutlet var mainBgView: UIView!
    @IBOutlet var btnRemover: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    weak var delegate: CustomGalleryViewdelegate?
    
    //AWS UPLOAD
    var uploadFileURL: NSURL?
    var tempIndex : Int = 0
    var tempImage: UIImage?;
    
    var isuploading : Bool = false
    var loadedUrls : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func loadView() {
      super.loadView()
        collectionView.register(CustomGalleryCell.self, forCellWithReuseIdentifier: "Cell")
        self.automaticallyAdjustsScrollViewInsets = false
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = bgView.bounds
        let cor1 = UIColor.lightGray.cgColor
        let cor2 = UIColor.darkGray.cgColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        bgView.layer.insertSublayer(gradient, at: 0)
        // Background view for images collection
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowRadius = 3.0
        bgView.layer.shadowOpacity = 0.15
        
        // Customize default ImageView
        imageView.layer.masksToBounds = true;
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowRadius = 6.0
        if sourceType == nil {
            pickerController =  UIImagePickerController()
            pickerController!.delegate = self
            pickerController!.sourceType = UIImagePickerControllerSourceType.photoLibrary
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        // Btn Remover
        btnRemover.backgroundColor = UIColor.white
        btnRemover.layer.cornerRadius = 15.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(cancelPicker))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        navigationController?.isNavigationBarHidden = false
        navigationItem.setLeftBarButton(cancelButton, animated: true)
        navigationItem.setRightBarButton(doneButton, animated: true)
         collectionView.reloadData()
        selectLastImage()
        setCurrentImage()
    }
    
    func selectLastImage () {
        if loadedImages.count > 0  {
            selectedIndex = loadedImages.count-1 ;
        collectionView.selectItem(at: (IndexPath(item: selectedIndex, section: 0)), animated: true, scrollPosition: .right)
        } else {
            selectedIndex = -1;
        }
        
    }
    func setCurrentImage(){
        if selectedIndex == -1 {
            return
        }
        imageView.image = loadedImages[selectedIndex]
        let  height = (imageView.image?.size.height)!*imageView.frame.size.width/(imageView.image?.size.width)!
        imageView.bounds = CGRect(x: imageView.bounds.origin.x, y: imageView.bounds.origin.y, width: imageView.bounds.size.width, height: height)
        let btX = (imageView.center.x - (imageView.frame.size.width/2)) - 15
        let btY = (imageView.center.y - (imageView.frame.size.height/2)) - 15
        btnRemover.frame = CGRect(x: btX, y: btY, width: btnRemover.frame.size.width, height: btnRemover.frame.size.height)
        mainBgView.bringSubview(toFront: btnRemover)
    }
    internal func setSourceType (type: UIImagePickerControllerSourceType) {
        sourceType = type
        
        pickerController =  UIImagePickerController()
        pickerController!.delegate = self
        pickerController!.sourceType = type
        
        if type == UIImagePickerControllerSourceType.camera {
            pickerController!.showsCameraControls = true
        }
    }
    @IBAction func removeImage(sender: AnyObject) {
        if isuploading {
            return
        }
        if loadedImages.count>0 {
             loadedImages.remove(at: selectedIndex)
             collectionView.reloadData()
        }else{
            imageView.isHidden = true
            btnRemover.isHidden = true
        }
       
       
        if loadedImages.count>0 {
            selectLastImage()
            setCurrentImage()
        }else{
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedImages.count+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomGalleryCell
        if indexPath.row == loadedImages.count {
            cell.styleAddButton()
            cell.imageView.image = nil
        }else{
            cell.styleImage()
            cell.imageView.image =  loadedImages[indexPath.row] as UIImage
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == loadedImages.count {
            imageView.isHidden = false
            btnRemover.isHidden = false
           self.presentCameraView()
        }else{
            selectedIndex = indexPath.row;
            setCurrentImage()
        }
    }
    func presentCameraView() {
        let newpicker =  UIImagePickerController()
        newpicker.delegate = self
        newpicker.sourceType = sourceType!
        newpicker.isEditing = false
        
        if (newpicker.sourceType == UIImagePickerControllerSourceType.camera) {
            newpicker.showsCameraControls = true
        }
        collectionView.reloadData()
        self.present(newpicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {}
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage

            loadedImages.append(originalImage)
       
            picker.dismiss(animated: true, completion: nil)
        } else{
            picker.dismiss(animated: true) {}
        }
        
    }
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        
        navigationController.navigationBar.barStyle = UIBarStyle.black
    }
    
    
    @objc func cancelPicker () {
        if isuploading {return}
        loadedImages.removeAll()
       self.delegate?.cancelPicking(picker: self)
    }
    
   @objc func donePicker () {
        if isuploading {return}
        
        loadedUrls.removeAll()
             print("total Images selected is\(loadedImages.count)")
        doUpload()
    }
    func doUpload () {
        
        isuploading = true
        
        
        let date = NSDate()
        let timestamp = NSInteger(date.timeIntervalSince1970)
        let S3UploadKeyName = String(timestamp)
        
        print(S3UploadKeyName)
        
        //Create a test file in the temporary directory
        self.uploadFileURL = URL.init(fileURLWithPath: NSTemporaryDirectory() + S3UploadKeyName) as NSURL
        print(uploadFileURL as Any)
//       let error: NSError? = nil
        tempImage = loadedImages[tempIndex]
        let data = UIImageJPEGRepresentation(tempImage!, 0.5)
        
        if FileManager.default.fileExists(atPath: self.uploadFileURL!.path!) {
            do{
                try FileManager.default.removeItem(atPath: self.uploadFileURL!.path!)
            } catch {
                print(error)
            }
        }
        do{
            try data?.write(to: self.uploadFileURL! as URL)
            }catch{
            print(error)
        }
        
        self.delegate?.donePicking(picker: self, didPickedUrls: self.loadedUrls)
        //remove this code when you activate above commented code
        self.delegate?.donePicking(picker: self, didPickedUrls: self.loadedUrls)
        
    }
    internal func addImage (image:UIImage!)  {
        loadedImages.append(image)
    }
}
