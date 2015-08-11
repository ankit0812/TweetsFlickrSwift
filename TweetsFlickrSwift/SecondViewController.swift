//
//  SecondViewController.swift
//  TweetsFlickrSwift
//
//  Created by optimusmac4 on 8/7/15.
//  Copyright (c) 2015 optimusmac4. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController{
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    let basicCellIdentifier = "FlickrCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
        // Dispose of any resources that can be recreated.
    
    }
 }

