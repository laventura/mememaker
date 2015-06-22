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
    let animationDuration = 0.20

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "showMemeEditor")
        
        navigationItem.title = "Sent Memes"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        collectionView!.allowsMultipleSelection = false
        
        // reload the collection
        collectionView!.reloadData()
        
    }
    

    
    // MARK: - Collection View Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // save ref to the selected Meme
        currentIndex = indexPath.row
        
        let theMeme = appDelegate().memes[indexPath.row]
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        // pass the selected meme to the DetailVC
        detailVC.theMeme = theMeme
        // nav to detailVC
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let theMeme = appDelegate().memes[indexPath.row]
        
        cell.memeImageView.image = theMeme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate().memes.count
    }
    
    // Test - highlighting
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
        
        UIView.animateWithDuration(animationDuration, animations: {selectedCell.transform = CGAffineTransformMakeScale(4, 4)})
        
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell!
        
        UIView.animateWithDuration(animationDuration, animations: {selectedCell.transform = CGAffineTransformIdentity})
        
    }
    // end test
    
    // MARK: - Utility
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func showMemeEditor() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        
        // TODO: should we pass any selected Meme data?
        
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }


}
