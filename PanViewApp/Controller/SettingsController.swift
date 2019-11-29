//
//  SettingsController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/25/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: - Properties
    var username: String?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "joel-gil")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joel A. Gil"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "joelgil@gmail.com"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "PanView App for Thrift stores"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "version 01.00.00"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let copyRightLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2019 Joel Gil. All rights reserved."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rvcLabel: UILabel = {
        let label = UILabel()
        label.text = "Rock Valley College - CIS280"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let profileImageDimension: CGFloat = 100
        
        view.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        view.addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        view.addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        view.addSubview(appNameLabel)
        appNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 40).isActive = true
        appNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        view.addSubview(versionLabel)
        versionLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 60).isActive = true
        versionLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
       
        view.addSubview(copyRightLabel)
        copyRightLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 80).isActive = true
        copyRightLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        view.addSubview(rvcLabel)
        rvcLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 100).isActive = true
        rvcLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        if let username = username {
            print("Username is \(username)")
        } else {
            print("Username not found..")
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white

        //self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "About me..."
        //self.navigationController?.navigationBar.barStyle = .black
              
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
    }
    
}
