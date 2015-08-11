//
//  FirstViewController.swift
//  TweetsFlickrSwift
//
//  Created by optimusmac4 on 8/7/15.
//  Copyright (c) 2015 optimusmac4. All rights reserved.
//

import Foundation
import UIKit

//let reuseIdentifier = "FlickrCell"

class FirstViewController: UICollectionViewController {
    
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
}



/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/

// MARK: UICollectionViewDataSource

// MARK: UICollectionViewDelegate

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
return true
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
return true
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
return false
}

override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
return false
}

override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

}
*/



extension FirstViewController : UICollectionViewDataSource {
    
    //number of sections is the count of the searches array
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    //number of items in a section is the count of the searchResults array
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        //This will call photoForIndexPath with indexPath for each photo found
        let flickrPhoto = photoForIndexPath(indexPath)
        
        cell.imageView.image = flickrPhoto.thumbnail
        //Populating the imageView with photos fetched
        return cell
        
    }
}


extension FirstViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.delegate=self
        self.searches.removeAll(keepCapacity: Bool())
        //Will be called when user press enter in text field
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        collectionView!.addSubview(activityIndicator)            //adding activity indicator on collection view
        activityIndicator.frame = collectionView!.bounds
        activityIndicator.startAnimating()               //starting animation of activity indicator
        flickr.searchFlickrForTerm(textField.text) {
            
            results, error in
            activityIndicator.removeFromSuperview()        //When search is done then removing the activity indicator
            
            if error != nil {
                println("Error searching : \(error)")
            }
            
            if results != nil {                         //Printing the count of number of images found
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                self.collectionView?.reloadData()
            }
        }
        
        textField.resignFirstResponder()

        return true
    }
    
    
}


extension FirstViewController : UICollectionViewDelegateFlowLayout {
    //It is for managing layout
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let flickrPhoto =  photoForIndexPath(indexPath)
            return CGSize(width: 100, height: 100)
            
            
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPaths : NSArray = collectionView!.indexPathsForSelectedItems()
        var imgForDetail : DetailViewController = segue.destinationViewController as! DetailViewController
        var thisPath : NSIndexPath = indexPaths[0] as! NSIndexPath
        
        let flickrPhoto = photoForIndexPath(thisPath) as FlickrPhoto
        
        imgForDetail.imageElement=flickrPhoto.thumbnail!
    }

    
}


