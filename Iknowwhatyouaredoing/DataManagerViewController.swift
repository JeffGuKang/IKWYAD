//
//  DataManagerViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 4/6/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import UIKit

class DataManagerViewController: UITableViewController {
    @IBOutlet weak var dataManagerTableView: UITableView!
    
    let CellIdentifier = "CellIdentifer"
    var fileNames = [NSURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataManagerTableView.delegate = self
        self.dataManagerTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fileNames = listFilesFromDocumentsFolder()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableViewDelegate, tableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)!
        // set cell's textLabel.text property
        cell.textLabel?.text = self.fileNames[indexPath.row].absoluteString
        // set cell's detailTextLabel.text property
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
    
    func listFilesFromDocumentsFolder() -> [NSURL]
    {
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            return directoryContents
        } catch let error as NSError {
            print(error.localizedDescription)
            return [documentsUrl]
        }
    }
}