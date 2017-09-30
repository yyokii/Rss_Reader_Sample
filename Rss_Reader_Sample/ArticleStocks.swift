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
        var tmpArticles: Array<Dictionary<String,AnyObject>> = []
        for myArticle in self.articles {
            let articleDic = ArticleStocks.convertDictionary(myArticle)
            tmpArticles.append(articleDic)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(tmpArticles, forKey: "Articles") //Array<Article>をArray<辞書型>の配列に直してそれを保存
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
        //キャストしなかったらAny型、定義元見ればわかる
        if let articles = defaults.object(forKey: "Articles") as? Array<Dictionary<String,String>> {
            for dic in articles {
                let article = ArticleStocks.convertArticleModel(dic as Dictionary<String, AnyObject>)
                self.articles.append(article)
            }
            
        }
    }
    
    class func convertArticleModel (_ dic: Dictionary<String,AnyObject>) -> Article {
        let article = Article()
        article.siteName = dic["siteName"] as! String
        article.title = dic["title"] as! String
        article.descript = dic["descript"] as! String
        article.date = dic["date"] as! String
        article.link = dic["link"]! as! String
        article.image = dic["image"]! as! String
        
        return article
    }
    
    class func convertDictionary (_ article: Article) -> Dictionary<String,AnyObject> {
        var dic = Dictionary<String,AnyObject>()
        dic["siteName"] = article.siteName as AnyObject?
        dic["title"] = article.title as AnyObject?
        dic ["descript"] = article.descript as AnyObject?
        dic["date"] = article.date as AnyObject?
        dic["link"] = article.link as AnyObject?
        dic["image"] = article.image as AnyObject?
        
        return dic
    }

    
}
