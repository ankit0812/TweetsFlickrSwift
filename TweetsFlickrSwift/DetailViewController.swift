//
//  DetailViewController.swift
//  TweetsFlickrSwift
//
//  Created by optimusmac4 on 8/11/15.
//  Copyright (c) 2015 optimusmac4. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var imageElement : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image=imageElement
    }
    @IBAction func saveButton(sender: AnyObject) {
        
        var saveImg : UIImage = imageView.image!
        UIImageWriteToSavedPhotosAlbum(saveImg, nil, nil, nil)
        var msgView = UIAlertView()
        msgView.title="Message"
        msgView.message="Photo Saved Successfully"
        msgView.addButtonWithTitle("OK")
        msgView.show()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}