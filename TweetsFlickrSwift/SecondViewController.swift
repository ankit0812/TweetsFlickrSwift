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
    
//    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tweetTableView: UITableView!
    
    var dataSource = [AnyObject]()
    
    let basicCellIdentifier = "TwitterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tweetTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier:basicCellIdentifier)
        
        self.getTimeLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
        // Dispose of any resources that can be recreated.
    
    }
//    
//    func getTimeLine() {
//        
//        let account = ACAccountStore()
//        let accountType = account.accountTypeWithAccountTypeIdentifier(
//            ACAccountTypeIdentifierTwitter)
//        
//        account.requestAccessToAccountsWithType(accountType, options: nil,
//            completion: {(success: Bool, error: NSError!) -> Void in
//                
//                if success {
//                    let arrayOfAccounts =
//                    account.accountsWithAccountType(accountType)
//                    
//                    if arrayOfAccounts.count > 0 {
//                        let twitterAccount = arrayOfAccounts.last as! ACAccount
//                        
//                        let requestURL = NSURL(string:
//                            "https://api.twitter.com/1.1/statuses/user_timeline.json")
//                        
//                        let parameters = ["screen_name" : "@techotopia",
//                            "include_rts" : "0",
//                            "trim_user" : "1",
//                            "count" : "20"]
//                        
//                        let postRequest = SLRequest(forServiceType:
//                            SLServiceTypeTwitter,
//                            requestMethod: SLRequestMethod.GET,
//                            URL: requestURL,
//                            parameters: parameters)
//                        
//                        postRequest.account = twitterAccount
//                        
//                        postRequest.performRequestWithHandler(
//                            {(responseData: NSData!,
//                                urlResponse: NSHTTPURLResponse!,
//                                error: NSError!) -> Void in
//                                var err: NSError?
//                                self.dataSource = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as! [AnyObject]
//                                
//                                if self.dataSource.count != 0 {
//                                    dispatch_async(dispatch_get_main_queue()) {
//                                        self.tableView.reloadData()
//                                    }
//                            }
//                        })
//                    }
//                } else {
//                    println("Failed to access account")
//                }
//        })
//    }
    
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
        
        let cell =
        self.tweetTableView.dequeueReusableCellWithIdentifier(basicCellIdentifier)
            as! UITableViewCell
        
        let row = indexPath.row
        let tweet = self.dataSource[row] as! NSDictionary
        
        cell.textLabel!.text = tweet.objectForKey("text") as? String
        cell.textLabel!.numberOfLines = 0
        
        return cell
    }
}
