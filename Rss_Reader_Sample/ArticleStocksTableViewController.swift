//
//  ArticleStocksTableViewController.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/10/01.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class ArticleStocksTableViewController: UITableViewController {

    var articleStocks = ArticleStocks.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ArticleTableViewCell", bundle:nil), forCellReuseIdentifier: "ArticleTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleStocks.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as!
        ArticleTableViewCell
        
        let myArticle = self.articleStocks.articles[(indexPath as NSIndexPath).row]
        cell.title.text = myArticle.title
        cell.descript.text = myArticle.descript
        let date: Date = Date.convertDateFromString(myArticle.date)
        cell.date.text = date.convertStringFromDate()
        
        if myArticle.siteName == "classmethod"{
            cell.thumbnail.image = UIImage(named: "classMethod")
        } else {
            let urlString = myArticle.image
            
            ArticleTableView().self.downloadWithDataTask(urlString: urlString, cell: cell)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
 

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            articleStocks.removeMyArticle((indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articleStocks.articles[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "toWebView", sender: article)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let articleWebViewController = segue.destination as! ArticleWebViewController
        articleWebViewController.article = sender as! Article!
    }
}
