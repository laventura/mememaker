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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Add button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "showMemeEditor")
        
        // TODO: Edit button on Left?
        
        self.navigationItem.title = "Sent Memes"
        
        if self.appDelegate().memes.count == 0 {
            self.showMemeEditor()
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
        self.tableView.rowHeight = 140.0
        
        self.tableView.reloadData()
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.appDelegate().memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as UITableViewCell

        let theMeme = appDelegate().memes[indexPath.row]
        
        // txt and image
        cell.textLabel?.text        = theMeme.top
        cell.imageView?.image       = theMeme.memedImage
        cell.detailTextLabel?.text  = theMeme.bottom

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO
        // do the detailVC
        
        // save ref to the selected Meme
        currentIndex = indexPath.row
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        let theMeme = appDelegate().memes[indexPath.row]
        detailVC.theMeme = theMeme
        // nav to detailVC
        self.navigationController!.pushViewController(detailVC, animated: true)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Utility
    func showMemeEditor() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as EditorViewController
        
        // TODO: should we pass any selected Meme data?
        
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }

}
