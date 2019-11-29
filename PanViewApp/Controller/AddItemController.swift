//
//  AddItemController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/28/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//  References: https://fluffy.es/store-image-coredata/
//              https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
//              https://stackoverflow.com/questions/40342196/how-do-i-save-and-show-a-image-with-core-data-swift-3
//

import UIKit
import CoreData
import Foundation
import AVFoundation

// MARK: - AddItemDelegate Protocol

protocol AddItemDelegate {
    func addItem(item: Item)
}

let categories = ["Blast", "Clothing Women", "Clothing Men", "Clothing Chilren", "Furniture", "Miscellaneous"]
let subCategories = ["Blast", "Shirts", "Pants", "Sweaters", "Jackets/Vests"]
let genders = ["", "Man", "Women"]

var category: String?
var subCategory: String?
var gender: String?

class AddItemController: UIViewController{
    
    // MARK: - Properties
    var fullItem: String?
    
    //Add ManagedObject Data Context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Add variable itemdb (used from UITableView
    var itemdb:NSManagedObject!
    
    let defaults: UserDefaults = UserDefaults.standard
        
    var delegate: AddItemDelegate?
    
    let photoImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.translatesAutoresizingMaskIntoConstraints = false
           //iv.image = #imageLiteral(resourceName: "thriftstore")
           return iv
    }()
    
    var imagePicker: ImagePicker!
    
    let txtCategory: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select category"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let txtSubCategory: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select category"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let txtNote: UITextField  = {
        let tf = UITextField ()
        tf.placeholder = "What's new?"
        tf.textAlignment = .left
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let lblCategory: UILabel = {
           let label = UILabel()
           label.text = "Category:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let lblStore: UILabel = {
              let label = UILabel()
              label.text = "Selected Store (Profile):"
              label.font = UIFont.systemFont(ofSize: 16 )
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
      }()
    
    let lblSelectedStore: UILabel = {
        let label = UILabel()
        label.text = "Selected store:"
        label.font = UIFont.systemFont(ofSize: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblSubCategory: UILabel = {
           let label = UILabel()
           label.text = "Sub Category:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let lblNote: UILabel = {
           let label = UILabel()
           label.text = "Comment:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let btnTakePhoto: UIButton = {
        let btn = UIButton()
        btn.setTitle("Pick Image", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
                
        view.addSubview(txtCategory)
        view.addSubview(txtSubCategory)
        view.addSubview(txtNote)
        
        view.addSubview(lblCategory)
        view.addSubview(lblSubCategory)
        view.addSubview(lblNote)
        view.addSubview(lblSelectedStore)
        view.addSubview(lblStore)
        view.addSubview(photoImageView)
        view.addSubview(btnTakePhoto)
        
        lblStore.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -85).isActive = true
        lblStore.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -320).isActive = true
        
        lblSelectedStore.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25).isActive = true
        lblSelectedStore.centerYAnchor.constraint(equalTo: lblStore.centerYAnchor, constant: 20).isActive = true
        
        lblCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138).isActive = true
        lblCategory.centerYAnchor.constraint(equalTo: lblSelectedStore.centerYAnchor, constant: 30).isActive = true
               
        txtCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtCategory.centerYAnchor.constraint(equalTo: lblCategory.centerYAnchor, constant: 20 ).isActive = true
        txtCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
               
        lblSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -122).isActive = true
        lblSubCategory.centerYAnchor.constraint(equalTo: txtCategory.centerYAnchor, constant: 30).isActive = true
               
        txtSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        txtSubCategory.centerYAnchor.constraint(equalTo:  lblSubCategory.centerYAnchor , constant: 20).isActive = true
        txtSubCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
               
        lblNote.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138).isActive = true
        lblNote.centerYAnchor.constraint(equalTo: txtSubCategory.centerYAnchor, constant: 30).isActive = true
               
        txtNote.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtNote.centerYAnchor.constraint(equalTo: lblNote.centerYAnchor, constant: 20).isActive = true
        txtNote.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        btnTakePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -128).isActive = true
        btnTakePhoto.centerYAnchor.constraint(equalTo: txtNote.centerYAnchor, constant: 40).isActive = true
        btnTakePhoto.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        btnTakePhoto.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        
        if defaults.string(forKey: "store") != nil{
            let _store = UserDefaults.standard.value(forKey: "store")!
            print(_store)
            lblSelectedStore.text = "\(_store) "
        }
        
        if let fullItem = fullItem {
            print("fullItem is \(fullItem)")
            
            if fullItem.contains("No"){
                txtCategory.text = categories[0]
                txtCategory.isEnabled = false
                txtSubCategory.text = subCategories[0]
                txtSubCategory.isEnabled = false
                txtNote.becomeFirstResponder()
            } else {
                txtCategory.becomeFirstResponder()
            }
        } else {
            print("fullItem not found..")
            txtCategory.becomeFirstResponder()
        }
        
    }
    
    //MARK: Configure Navigation Bar
    func configureNavigationBar() {
        
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))]
        self.navigationItem.title = "Add an Item"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        //UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(handleVideo))
       
    }
    
    // MARK: - Video Capture
   
    
    // MARK: - Selectors
    
    @objc func handleDone() {
        
        guard let _category = txtCategory.text, txtCategory.hasText else {
            print("Handle error here..")
            return
        }
        
        //let item = Item(fullname: fullname)
        //delegate?.addItem(item: item)
        
        let _store = UserDefaults.standard.value(forKey: "store")!
        
        if (itemdb != nil){
                
           itemdb.setValue(txtCategory.text, forKey: "category")
           itemdb.setValue(txtSubCategory.text, forKey: "subcategory")
           itemdb.setValue(txtNote.text, forKey: "note")
           itemdb.setValue(_store, forKey: "store")
           itemdb.setValue(Date(), forKey: "createdat")
           itemdb.setValue(true, forKey: "status")
           itemdb.setValue(_store as! String, forKey: "store")
                   
       }
       else{
           let entityDescription =
               NSEntityDescription.entity(forEntityName: "Item",in: managedObjectContext)
           
           let item = Item(entity: entityDescription!,
                                 insertInto: managedObjectContext)
           
           let imageData = photoImageView.image
           let imgData = imageData!.jpegData(compressionQuality: 1)
            
           item.category = txtCategory.text!
           item.subcategory = txtSubCategory.text!
           item.note = txtNote.text!
           item.status = true
           item.store = _store as? String
           item.createdat = Date()
           item.video = imgData
       }
        
        var error: NSError?
        do {
           try managedObjectContext.save()
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            
        } catch let error1 as NSError {
           error = error1
           print("\(error)")
        }
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        print("Button Clicked!")
        self.imagePicker.present(from: sender)
    }
    
    @objc func handleVideo() {
        //self.dismiss(animated: true, completion: nil)
        print("record the video...")
    }
   
}

// MARK: — ImagePickerDelegate
extension AddItemController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.photoImageView.image = image
    }
}
