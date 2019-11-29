//
//  MenuOption.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/25/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//
import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Profile
    //case Inbox
    case AddBlast
    case Settings
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        //case .Inbox: return "Inbox"
        case .AddBlast: return "Add Item"
        case .Settings: return "About me"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "ic_person_outline_white_2x") ?? UIImage()
        //case .Inbox: return UIImage(named: "ic_mail_outline_white_2x") ?? UIImage()
        case .AddBlast: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Settings: return UIImage(named: "baseline_settings_white_24dp") ?? UIImage()
        }
    }
}
