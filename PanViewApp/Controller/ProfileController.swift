//
//  ProfileController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/26/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

let stores = ["Salvation Army - Alpine Rd", "Rockford Rescue Mission - Harrison Ave", "Goodwill - State E"]

// MARK: Profile

struct Profile {
    var fullname: String
    var email: String
    var store: String
}

let itemVerticalSpace:CGFloat = 30

// Get screen size, width and height value.
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class ProfileController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row] // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedStore = stores[row] // selected item
        txtStore.text = selectedStore
    }
    
    
    // MARK: - Properties
    
        let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "profile")
        return iv
    }()
    let txtFullName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Full Name:"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        //tf.layer.cornerRadius = 8.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let lblFullName: UILabel = {
        let label = UILabel()
        label.text = "Full Name:"
        label.font = UIFont.systemFont(ofSize: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let txtStore: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Store Name"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        //tf.layer.cornerRadius = 8.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let lblStore: UILabel = {
        let label = UILabel()
        label.text = "Favorite Store:"
        label.font = UIFont.systemFont(ofSize: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let txtEmail: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Email account"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        //tf.layer.cornerRadius = 8.0
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let lblEmail: UILabel = {
        let label = UILabel()
        label.text = "Email account:"
        label.font = UIFont.systemFont(ofSize: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
        
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImageDimension: CGFloat = 100
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "User Profile"
                 
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
              
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = .white
      
        view.addSubview(txtFullName)
        view.addSubview(txtEmail)
        view.addSubview(txtStore)
        
        view.addSubview(lblFullName)
        view.addSubview(lblStore)
        view.addSubview(lblEmail)
        
        view.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        lblFullName.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138).isActive = true
        lblFullName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        
        txtFullName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtFullName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100 ).isActive = true
        txtFullName.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        lblEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -122).isActive = true
        lblEmail.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        txtEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        txtEmail.centerYAnchor.constraint(equalTo:  view.centerYAnchor , constant: -50).isActive = true
        txtEmail.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        lblStore.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -122).isActive = true
        lblStore.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
        txtStore.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtStore.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        txtStore.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtStore.inputView = pickerView
                
        
        let defaults: UserDefaults = UserDefaults.standard
        if defaults.string(forKey: "fullname") != nil{
              txtFullName.text = defaults.string(forKey: "fullname")
        }
        if defaults.string(forKey: "email") != nil{
            txtEmail.text = defaults.string(forKey: "email")
        }
        if defaults.string(forKey: "store") != nil{
                   txtStore.text = defaults.string(forKey: "store")
               }
        
       txtFullName.becomeFirstResponder()
        
    }
    
    // MARK: - Selectors

    @objc func handleDone() {
           
        guard let fullname = txtFullName.text, txtFullName.hasText else {
               print("Handle error here..")
               return
        }
           
        guard let email = txtEmail.text, txtEmail.hasText else {
                print("Handle error here..")
                return
        }
        
        guard let store = txtStore.text, txtStore.hasText else {
                print("Handle error here..")
                return
        }
        
        let profile = Profile(fullname: fullname, email: email, store: store)
          
        let defaults: UserDefaults = UserDefaults.standard
                     defaults.set(self.txtFullName.text, forKey: "fullname")
                     defaults.set(self.txtEmail.text, forKey: "email")
                     defaults.set(self.txtStore.text, forKey: "store")
        
        //delegate?.addProfile(profile: profile)
        self.dismiss(animated: true)
        
    }
       
    @objc func handleCancel() {
           self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - UITableView
    
}

// MARK: - AddContactDelegate

