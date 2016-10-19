//
//  ViewController.swift
//  LixarTestKerry
//
//  Created by Kerry Toonen on 2016-10-16.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RepoDelegate, IssuesDelegate {

    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
   
    @IBOutlet weak var issuesLabel: UIButton!
    
    var issuesLink = ""
    
    var issues : [Issue] = []
    
    let manager = APIRequestManager(username: "cocoapods", repoName: "cocoapods")
    
    @IBAction func issuesButtonPressed(sender: AnyObject) {
        manager.getIssues(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.issuesDelegate = self
        manager.repoDelegate = self
        manager.getRepoInfo(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func repoDidLoad(repo:Repo) {
        //now you have users object array
        //populate a table view
        var readme = repo.readme
        
        if let startRange = repo.readme?.rangeOfString("Links") {
           readme?.removeRange(startRange.startIndex..<(readme?.endIndex)!)
        }
        
        self.newLabel.text = readme
        self.starsLabel.text = "Stars: \(repo.stars!)"
        self.titleLabel.text = repo.title
        
    }
    
    func issuesDidLoad(issues: [Issue]) {
       self.issues = issues
        performSegueWithIdentifier("toIssuesVC", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toIssuesVC"{
            let issuesVC = segue.destinationViewController as! IssuesTableViewController
            issuesVC.issues = self.issues
        }
    }


}

