//
//  MemeTableViewController.swift
//  MemeMaker
//
//  Created by Atul Acharya on 6/6/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var currentIndex: Int?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "showMemeEditor")
                
        navigationItem.title = "Sent Memes"
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        tableView.rowHeight = 140.0
        
        tableView.reloadData()
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.appDelegate().memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath)as! UITableViewCell

        let theMeme = appDelegate().memes[indexPath.row]
        
        // txt and image
        cell.textLabel?.text        = theMeme.top
        cell.imageView?.image       = theMeme.memedImage
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.detailTextLabel?.text  = theMeme.bottom

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // save ref to the selected Meme
        currentIndex = indexPath.row
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let theMeme = appDelegate().memes[indexPath.row]
        detailVC.theMeme = theMeme
        // nav to detailVC
        self.navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            appDelegate().memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Utility
    func showMemeEditor() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        
        // TODO: should we pass any selected Meme data?
        
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }

}
