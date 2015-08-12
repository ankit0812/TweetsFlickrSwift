//
//  SecondViewController.swift
//  TweetsFlickrSwift
//
//  Created by optimusmac4 on 8/7/15.
//  Copyright (c) 2015 optimusmac4. All rights reserved.
//

import Foundation
import UIKit
import Accounts
import Social



class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tweetTableView: UITableView!
    
    var dataSource = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tweetTableView.estimatedRowHeight=200
        
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        self.getTimeLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
        // Dispose of any resources that can be recreated.
    
    }
   
    func getTimeLine() {
        
        let account = ACAccountStore()  // getting the account store
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)      // Getting the account of identifier type twitter
        
        account.requestAccessToAccountsWithType(accountType, options:nil, completion: {(success:Bool, error: NSError!)-> Void in
            
            if success {
                let arrayOfAccounts = account.accountsWithAccountType(accountType)
                
                if arrayOfAccounts.count>0 {
                    let twitterAccount = arrayOfAccounts.last as! ACAccount
                    
                    let requestURL = NSURL(string:"https://api.twitter.com/1.1/statuses/home_timeline.json")
                    
                    let parameters = ["include_entities":"1", "count":"20"]
                    
                    let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod:SLRequestMethod.GET, URL:requestURL, parameters: parameters)
                    
                    postRequest.account=twitterAccount
                    
                    postRequest.performRequestWithHandler(
                        {(responseData: NSData!, urlResponse: NSHTTPURLResponse!,error: NSError!)->Void in
                        
                        var err :NSError?
                        
                            self.dataSource = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as! [AnyObject]
                            
                            if self.dataSource.count != 0 {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tweetTableView.reloadData()
                                }
                            }

                    })
                }
                
            } else {
                println("Failed to Access Account ")
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tweetTableView.dequeueReusableCellWithIdentifier("TwitterCell")
            as! TwitterCell
        
        let row = indexPath.row
        
        let tweet = self.dataSource[row] as! NSDictionary
        let userInfo = tweet.objectForKey("user") as! NSDictionary
        
        cell.textTweet!.text = tweet.objectForKey("text") as? String
        cell.nameTweet!.text = userInfo.objectForKey("name") as? String
        var imageInfo : NSString = (userInfo.objectForKey("profile_image_url") as? String)!
        let url = NSURL(string: imageInfo as String)
        let data = NSData(contentsOfURL: url!)
        cell.imageSender.image = UIImage(data: data!)
       
        return cell
    }
}
