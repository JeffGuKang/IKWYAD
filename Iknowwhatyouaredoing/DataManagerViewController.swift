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
    var fileNames = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataManagerTableView.delegate = self
        self.dataManagerTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fileNames = listFilesFromDocumentsFolder()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableViewDelegate, tableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)!
        
        // set cell's textLabel.text property
        var filename = self.fileNames[(indexPath as NSIndexPath).row].absoluteString
        filename = filename!.components(separatedBy: "/").last
        
        cell.textLabel?.text = filename
        
        // set cell's detailTextLabel.text property
        cell.detailTextLabel?.text = "Detail"
        return cell
    }
    
    // Editable Tableview Cells.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let uploadAction = UITableViewRowAction(
            style: .normal,
            title: "Upload",
            handler: {(action, indexPath) in
                let uploadMenu = UIAlertController(title: "Upload", message: "This file will be uploaded", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    fileUploadToServer(filepath: self.fileNames[indexPath.row])
                })
                let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
                
                uploadMenu.addAction(okAction)
                uploadMenu.addAction(cancelAction)
                
                self.present(uploadMenu,
                             animated: true,
                             completion: nil)
            }
        )
    
        let deleteAction = UITableViewRowAction(
            style: .default,
            title: "Delete",
            handler: {
                (action, indexPath) in
                let fileManager = FileManager.default()
                let path = self.fileNames[indexPath.row]
                do {
                    try fileManager.removeItem(at: path)
                    self.fileNames.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                catch {
                    print("Error: File delete -> \(error)")
                }
        })
        
        return [uploadAction, deleteAction]
    }

    
    func listFilesFromDocumentsFolder() -> [URL]
    {
        
        let documentsUrl =  FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!
        
        do {
            let directoryContents = try FileManager.default().contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            return directoryContents
        } catch let error as NSError {
            print(error.localizedDescription)
            return [documentsUrl]
        }
    }
}
