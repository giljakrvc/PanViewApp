//
//  ItemOptionCell.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/29/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit

class ItemOptionCell: UITableViewCell {

    // MARK: - Properties
    let pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Title"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Description"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "Category"
        label.layer.cornerRadius = 25
        //label.layer.shadowOpacity = 0.7;
        //label.layer.shadowRadius = 2;
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "Created at"
        label.textAlignment = .left
        //label.layer.cornerRadius = 25
        //label.layer.shadowOpacity = 0.7;
        //label.layer.shadowRadius = 2;
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = .darkGray
        //selectionStyle = .none
        
        addSubview(pictureImageView)
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        pictureImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pictureImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        pictureImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        pictureImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //pictureImageView.layer.cornerRadius = 80 / 2
        
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: pictureImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: pictureImageView.rightAnchor, constant: 12).isActive = true
                
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: pictureImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(createdAtLabel)
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true
        createdAtLabel.leftAnchor.constraint(equalTo: pictureImageView.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    // MARK: - Handlers

}
