//
//  ViewItemController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/29/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import AVFoundation

class ViewItemController: UIViewController{
    
    // MARK: - Properties
    var fullItem: String?
    
    //Add ManagedObject Data Context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Add variable itemdb (used from UITableView
    var itemdb:NSManagedObject!
    
    let defaults: UserDefaults = UserDefaults.standard
        
    var delegate: AddItemDelegate?
    
    let storeImageView: UIImageView = {
           let iv = UIImageView()
           iv.image = #imageLiteral(resourceName: "thriftstore")
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.borderWidth = 3
           return iv
    }()
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let lblCategory: UILabel = {
           let label = UILabel()
           label.text = "Category"
           label.font = UIFont.boldSystemFont(ofSize: 18 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()
    
    let lblSelectedCategory: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()
    
    let lblStore: UILabel = {
        let label = UILabel()
        label.text = "Store"
        label.textAlignment = .justified
        label.font = UIFont.boldSystemFont(ofSize: 18 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblSelectedStore: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblSubCategory: UILabel = {
           let label = UILabel()
           label.text = "Sub Category:"
           label.font = UIFont.boldSystemFont(ofSize: 18 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()
    
    let lblSelectedSubCategory: UILabel = {
           let label = UILabel()
           label.text = "Sub Category"
           label.font = UIFont.systemFont(ofSize: 14 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()
    
    let lblNote: UILabel = {
           let label = UILabel()
           label.text = "Comment"
           label.font = UIFont.boldSystemFont(ofSize: 18 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()
    
    let lblSelectedNote: UILabel = {
        let label = UILabel()
        label.text = "Comment:"
        label.textAlignment = .justified
        label.font = UIFont.boldSystemFont(ofSize: 20 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblCreatedAt: UILabel = {
        let label = UILabel()
        label.text = "Comment:"
        label.textAlignment = .justified
        label.font = UIFont.boldSystemFont(ofSize: 12 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
       
        view.addSubview(lblCategory)
        view.addSubview(lblSubCategory)
        //view.addSubview(lblNote)
        view.addSubview(lblSelectedStore)
        view.addSubview(lblStore)
        view.addSubview(photoImageView)
        //
        view.addSubview(lblSelectedCategory)
        view.addSubview(lblSelectedSubCategory)
        view.addSubview(lblSelectedNote)
        view.addSubview(lblCreatedAt)
               
        lblStore.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        lblStore.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -350).isActive = true
        
        lblSelectedStore.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        lblSelectedStore.centerYAnchor.constraint(equalTo: lblStore.centerYAnchor, constant: 20).isActive = true
        
        lblSelectedNote.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblSelectedNote.centerYAnchor.constraint(equalTo: lblSelectedStore.centerYAnchor, constant: 30).isActive = true
        //lblSelectedNote.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: lblSelectedStore.centerYAnchor, constant: 220).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        photoImageView.layer.shadowColor = UIColor.darkGray.cgColor
        photoImageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        photoImageView.layer.shadowRadius = 25.0
        photoImageView.layer.shadowOpacity = 0.9
        
        //lblCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        //lblCategory.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor, constant: 200).isActive = true
               
        lblSelectedCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblSelectedCategory.centerYAnchor.constraint(equalTo: lblCategory.centerYAnchor, constant: 550 ).isActive = true
        //lblSelectedCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        //txtCategory.addConstraint(txtCategory.heightAnchor.constraint(equalToConstant: 25))
               
        //lblSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -122).isActive = true
        //lblSubCategory.centerYAnchor.constraint(equalTo: lblSelectedCategory.centerYAnchor, constant: 25).isActive = true
               
        //lblSelectedSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        //lblSelectedSubCategory.centerYAnchor.constraint(equalTo:  lblSubCategory.centerYAnchor , constant: 20).isActive = true
        //lblSelectedSubCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        //lblSelectedSubCategory.addConstraint(txtSubCategory.heightAnchor.constraint(equalToConstant: 25))
        
        lblCreatedAt.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        lblCreatedAt.centerYAnchor.constraint(equalTo: lblSelectedCategory.centerYAnchor, constant: 30).isActive = true
      
                
        if let _item = itemdb {
           
            lblSelectedNote.text = _item.value(forKey: "note") as! String?
            lblSelectedStore.text = _item.value(forKey: "store") as! String?
            lblSelectedCategory.text = _item.value(forKey: "category") as! String?
            //
            lblSelectedSubCategory.text = _item.value(forKey: "subcategory") as! String?
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
            let createdAt = _item.value(forKey: "createdat") as! Date?
            let createdAtFormatted = dateFormatter.string(from: createdAt ?? Date())
            
            lblCreatedAt.text = "Created at \(createdAtFormatted)"
                     
            photoImageView.image = storeImageView.image
            
            if let imageData = _item.value(forKey: "video") as? NSData {
               if let image = UIImage(data:imageData as Data) as? UIImage {
                photoImageView.image = image
               }
            }


        } else {
            print("fullItem not found..")
        }
        
    }
    
    //MARK: Configure Navigation Bar
    func configureNavigationBar() {
        
        view.backgroundColor = .white
        
        self.navigationItem.title = "View an Item Info"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCancel))
    }
    
    // MARK: - Selectors
   
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
       
   
}

