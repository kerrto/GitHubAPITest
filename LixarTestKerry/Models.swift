//
//  RepoModels.swift
//  LixarTestKerry
//
//  Created by Kerry Toonen on 2016-10-16.
//  Copyright © 2016 Kerry Toonen. All rights reserved.
//

import Foundation

struct Repo {
    
    let title: String?
    let stars: Int?
    let readme: String?
    
    
    init(title: String, stars: Int, readme: String){
        self.title = title
        self.stars = stars
        self.readme = readme
    }
    
}

struct Issue {
    let title: String?
    let author: String?
    let link: String?
    let state: String?
    let age: Int?
    
    init(title: String, author: String, link: String, state: String, age: Int) {
        self.title = title
        self.author = author
        self.link = link
        self.state = state
        self.age = age
    }
}

