//
//  ArticleStocks.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import Foundation

class ArticleStocks: NSObject{
    static let sharedInstance = ArticleStocks()
    var articles: Array<Article> = []
    
    //save
    func saveArticle () {
        let defaults = UserDefaults.standard
        defaults.set(articles, forKey: "Articles")
        defaults.synchronize()
    }
    
    //add
    func addArticleStocks(article: Article){
        articles.insert(article,at: 0)
        saveArticle()
    }
    
    //delete
    func removeMyArticle  (_ row: Int) {
        self.articles.remove(at: row)
        saveArticle()
    }
    
    //get
    func getMyArticles(){
        
        let defaults = UserDefaults.standard
        if let articles = defaults.object(forKey: "Articles") as? Array<Article> {
            self.articles = articles
        }
    }
    
}
