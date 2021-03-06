//
//  ArticleTableView.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

@objc protocol ArticleTableViewDelegate {
    func didSelectTableViewCell (article: Article)
}

class ArticleTableView: UITableView, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    //デリゲート
    weak var customDelegate: ArticleTableViewDelegate?
    
    var siteName: String!
    var siteImageName: String!
    
    //parseで用いる変数
    var elementName = ""
    var articles : Array<Article> = []
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: "ArticleTopTableViewCell", bundle:nil), forCellReuseIdentifier: "ArticleTopTableViewCell")
        
        self.register(UINib(nibName: "ArticleTableViewCell", bundle:nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        } else {
            return articles.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTopTableViewCell", for: indexPath) as! ArticleTopTableViewCell
            
            cell.siteImageView.image = UIImage(named: self.siteImageName)
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
            
            let article = self.articles[(indexPath as NSIndexPath).row]
            cell.title.text = article.title
            cell.descript.text = article.descript
            let date: Date = Date.convertDateFromString(article.date)
            cell.date.text = date.convertStringFromDate()
            
            if self.siteName == "classmethod"{
                cell.thumbnail.image = UIImage(named: "classMethod")
            } else{
                let urlString = article.image
                self.downloadWithDataTask(urlString: urlString, cell: cell)
            }

            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let article = articles[indexPath.row]
            self.customDelegate?.didSelectTableViewCell(article: article)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 60
        }else{
            return 100
        }
    }
    
    func loadURL(siteURL: String){
        //オプショナルバインディング
        if let url = URL(string: siteURL){
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (
                data, response, error) in
                
                let parser = XMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                
            })
            task.resume()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
        
        if self.elementName == "item" {
            let article = Article()
            self.articles.append(article)
        } else if self.elementName == "enclosure" {
            let lastArticle = self.articles.last
            lastArticle?.image = attributeDict["url"]!
        }

        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let lastArticle = self.articles.last
        
        if self.elementName == "title" {
            lastArticle?.title += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        }else if self.elementName == "description" {
            lastArticle?.descript += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        }else if self.elementName == "pubDate" {
            lastArticle?.date += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        }else if self.elementName == "link" {
            lastArticle?.link += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        }else if self.elementName == "image" {
            
            lastArticle?.image += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async(execute: {
            self.reloadData()
        })
    }
    
    func downloadWithDataTask(urlString: String, cell: ArticleTableViewCell){
        
        let fiveSecondsCache: TimeInterval = 5 * 60
        
        //urlをエンコーディングして無効なURLが入ったら処理を抜ける
        guard let encURL = URL(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else {
            print("urlをエンコード出来なかったよ!")
            return
        }
        let req = URLRequest(url: encURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: fiveSecondsCache)
        
        let conf = URLSessionConfiguration.default
        let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main)
        
        session.dataTask(with: req, completionHandler:
            { (data, resp, err) in
                if (err == nil){
                    
                    let image = UIImage(data: data!)
                    cell.thumbnail.image = image
                } else {
                    print("Error：　画像の取得に失敗しました")
                }
        }).resume()
        
        
    }
    
}
