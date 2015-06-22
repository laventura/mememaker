//
//  DetailViewController.swift
//  MemeMaker
//
//  Created by Atul Acharya on 6/7/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var theMeme: Meme!

    @IBOutlet weak var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide the tab bar
        self.tabBarController?.tabBar.hidden = true
        // TODO: set the image view
        self.memeImageView!.image = theMeme.memedImage
        
        // right ADD button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "showMemeEditor")
        
        // TODO: show a Delete button?
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Utility
    func showMemeEditor() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        
        // TODO: should we pass any selected Meme data?
        
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }


}
