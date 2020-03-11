//
//  SafariExtensionViewController.swift
//  QuickDown Extension
//
//  Created by Alex Perathoner on 10/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()
	
	@IBOutlet weak var tableView: NSTableView!
	var operations: [String]! = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	@IBOutlet weak var defaultFolderOutlet: NSTextField!
	var defaultFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads")

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//setting up tableview
		self.tableView.delegate = self
		self.tableView.dataSource = self
	}
	
	
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return operations.count
	}
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
	{
		return operations?[row]
	}
	
	@IBAction func downloadPage(_ sender: Any) {
		
		SFSafariApplication.getActiveWindow { (window) in
			window?.getActiveTab { (tab) in
				tab?.getPagesWithCompletionHandler({ (pages) in
					pages?.first?.getPropertiesWithCompletionHandler({ (prop) in
						if let link = prop?.url?.absoluteString {
							let asd = String(link)
							let slashIndex = asd.index(after: asd.lastIndex(of: "/")!)
							let title = asd[slashIndex...]
							DispatchQueue.main.async {
								self.operations.append(String(title))
							}
							shell(launchPath: "/usr/bin/curl", arguments: ["-o","\(self.defaultFolder.path)/\(title)","\(asd)"])
							DispatchQueue.main.async {
								//finished downloading
								self.operations.remove(at: self.operations.firstIndex(of: String(title))!)
								
								//comment this line if you don't want to automatically open the file after it has been downloaded
								NSWorkspace.shared.openFile("\(self.defaultFolder.path)/\(title)")
							}
						}
					})
				})
			}
		}
	}
	
	
	
}
