//
//  SafariExtensionViewController.swift
//  QuickDown Extension
//
//  Created by Alex Perathoner on 10/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
