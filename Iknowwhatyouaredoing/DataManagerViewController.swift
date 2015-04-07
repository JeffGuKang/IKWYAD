//
//  DataManagerViewController.swift
//  Iknowwhatyouaredoing
//
//  Created by Jeff Kang on 4/6/15.
//  Copyright (c) 2015 jeffgukang. All rights reserved.
//

import UIKit

class DataManagerViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dataManagerTableView: UITableView!
    
    let cellIdentifier = "CellIdentifer"
    var fileNames = [String]()
    
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
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as  UITableViewCell

        // set cell's textLabel.text property
        cell.textLabel?.text = self.fileNames[indexPath.row]
        // set cell's detailTextLabel.text property
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
    
    func listFilesFromDocumentsFolder() -> [String]
    {
        var theError = NSErrorPointer()
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        if dirs != nil {
            let dir = dirs![0]
            let fileList = NSFileManager.defaultManager().contentsOfDirectoryAtPath(dir, error: theError)
            return fileList as [String]
        }else{
            let fileList = [""]
            return fileList
        }
    }
}