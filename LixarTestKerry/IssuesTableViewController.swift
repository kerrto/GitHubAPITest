//
//  IssuesTableViewController.swift
//  LixarTestKerry
//
//  Created by Kerry Toonen on 2016-10-18.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

import Foundation
import UIKit

class IssuesTableViewController : UITableViewController {
    
    var issues : [Issue] = []
    
    @IBOutlet var issuesTableView: UITableView!
   
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        issuesTableView.rowHeight = UITableViewAutomaticDimension
        issuesTableView.estimatedRowHeight = 145

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let issue = issues[indexPath.row]
        
        if let url = NSURL(string: issue.link!){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IssueCell", forIndexPath: indexPath) as! IssueCell
        
        let issue = issues[indexPath.row]
        
        cell.titleLabel.text = issue.title
        
        cell.openClosedLabel.text = issue.state
        
        cell.ageLabel.text = "Age in hours: \(String(issue.age!))"
        
        cell.authorLabel.text = issue.author
        
        return cell
    }
}