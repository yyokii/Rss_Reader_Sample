//
//  ArticleTableView.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class ArticleTableView: UITableView, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

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
            return 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTopTableViewCell", for: indexPath) as! ArticleTopTableViewCell
            
            cell.siteImageView.image = UIImage(named: self.siteImageName)
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 60
        }else{
            return 85
        }
    }
    
    func loadURL(siteURL: String){
        //オプショナルバインディング
        if let url = URL(string: siteURL){
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (
                data, response, error) in
                
                print(data!)
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
}
