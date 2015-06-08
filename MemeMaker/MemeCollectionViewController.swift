//
//  MemeCollectionViewController.swift
//  MemeMaker
//
//  Created by Atul Acharya on 6/7/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "showMemeEditor")
        
        self.navigationItem.title = "Sent Memes"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
        self.collectionView!.allowsMultipleSelection = false
        
        // reload the collection
        self.collectionView!.reloadData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Collection View Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // save ref to the selected Meme
        // currentIndex = indexPath.row
        
        
        let theMeme = appDelegate().memes[indexPath.row]
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        
        // pass the selected meme to the DetailVC
        detailVC.theMeme = theMeme
        // nav to detailVC
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as MemeCollectionViewCell
        
        let theMeme = appDelegate().memes[indexPath.row]
        
        cell.memeImageView.image = theMeme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate().memes.count
    }
    
    // MARK: - Utility
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    func showMemeEditor() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as EditorViewController
        
        // TODO: should we pass any selected Meme data?
        
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }


}
