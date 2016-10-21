//
//  APIRequestManager.swift
//  LixarTestKerry
//
//  Created by Kerry Toonen on 2016-10-16.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

import Alamofire



protocol RepoDelegate {
    func repoDidLoad(repo:Repo)
}

protocol IssuesDelegate {
    func issuesDidLoad(issues: [Issue])
}

class APIRequestManager {
    
    var username = ""
    var repoName = ""
    var repoDelegate:RepoDelegate?
    var issuesDelegate: IssuesDelegate?
    
    
    init(username: String, repoName: String) {
        self.username = username
        self.repoName = repoName
    }
    
    

func getRepoInfo(viewController: UIViewController)  {
    
    
    Alamofire.request(.GET, "https://api.github.com/repos/\(username)/\(repoName)").validate().responseJSON { response in
        
        switch response.result {
            
        case .Success(let JSON):
            
                    let newURL = "https://raw.githubusercontent.com/\(self.username)/\(self.repoName)/master/README.md"
            
                    guard let jsonDict : [String: AnyObject] = JSON as? [String : AnyObject] else { return }
            
                    Alamofire.request(.GET, newURL).responseData { response in
                        //debugPrint("All Response Info: \(response)")
                        
                        if let data = response.result.value, let utf8Text = String(data: data, encoding: NSUTF8StringEncoding) {

                            
                            var markdownEngine = Markdown()
                            let outputHTML = markdownEngine.transform(utf8Text)
                            
                            let attributedString = outputHTML.html2String
                            
                            self.createRepo(jsonDict, readme: attributedString)
                          
                        }
            }
                case .Failure(let error):
                    self.showErrorAlert(viewController, error: error)
                    
                }
            }
    
        }
    
    func showErrorAlert(viewController: UIViewController, error: NSError) {
        print("Request failed with error: \(error)")
        
        let alertController = UIAlertController(title: "Loading Error", message: "There was a network problem. Please check your internet connection and try again", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createRepo(json: [String: AnyObject], readme: String) {
       let title = json["name"] as! String
       let stargazersCount = json["stargazers_count"] as! Int
        let repo = Repo(title: title, stars: stargazersCount, readme: readme)
        repoDelegate!.repoDidLoad(repo)
        
    }
    
    func createIssueArray(json: [NSDictionary]) {
        var issueArray : [Issue] = []
        for dict in json {
            guard let title = dict["title"] as? String else { break }
            guard let userDict = dict["user"] else { break }
            guard let usernameFromDict = userDict["login"]  else { break }
            guard let username = usernameFromDict as? String else { break }
            guard let link = dict["html_url"] as? String else { break }
            guard let state = dict["state"] as? String else { break }
            guard let dateFromDict = dict["created_at"] as? String else { break }
            
            let dateArray = dateFromDict.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let newDateString = dateArray.joinWithSeparator("")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMDDHHmmss"
            if let date = dateFormatter.dateFromString(newDateString) {
                
                let age = NSDate().hoursFrom(date)
            
            let issue = Issue(title: title, author: username, link: link, state: state, age: age)
                issueArray.append(issue)
        }
    }
        let newIssueArray = issueArray.sort({ $0.age < $1.age })
        
        issuesDelegate!.issuesDidLoad(newIssueArray)
        }
    
    func getIssues(viewController: UIViewController) {
        Alamofire.request(.GET, "https://api.github.com/repos/\(username)/\(repoName)/issues?").validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                guard let JSONArray = JSON as? [NSDictionary] else { return }
                
                self.createIssueArray(JSONArray)
                
                
            case .Failure(let error):
                self.showErrorAlert(viewController, error: error)
    }
    
    }
    }
}



extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func base64Decoded() -> String {
        let decodedData = NSData(base64EncodedString: self, options:NSDataBase64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
        return decodedString! as String
    }
}

extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

