//
//  ArticleWebViewController.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import WebKit


class ArticleWebViewController: UIViewController, WKNavigationDelegate{

    var article: Article!
    let wkWebView = WKWebView()
    let rightImage = UIImageView()
    
    var articleStocks = ArticleStocks.sharedInstance
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView.navigationDelegate = self
        
        if(isStockedArticle()){
            setNavigationRightImage(imageName: "heart_on")
        }else {
            setNavigationRightImage(imageName: "heart_off")
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white        
        
        //記事タイトル表示の色
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HirakakuProN-W6", size: 13)!, NSForegroundColorAttributeName: UIColor.white]

        //サイト表示のために必要な箇所
        let URL = Foundation.URL(string: article.link)
        let URLReq = URLRequest(url: URL!)
        self.wkWebView.frame = self.view.frame
        self.wkWebView.load(URLReq)
        self.view.addSubview(wkWebView)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.navigationItem.title = "Now Loading・・・"
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = wkWebView.title
    }
    
    func setNavigationRightImage(imageName: String){
        
        rightImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightImage.image = UIImage(named: imageName)
        rightImage.isUserInteractionEnabled = true
        
        let barButtonItem = UIBarButtonItem()
        let myTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ArticleWebViewController.heartTapped))
        self.rightImage.addGestureRecognizer(myTap)
        
        barButtonItem.customView = rightImage
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func heartTapped(){
    
        if (isStockedArticle()){
            setNavigationRightImage(imageName: "heart_off")
            articleStocks.removeMyArticle(count)
        } else {
            setNavigationRightImage(imageName: "heart_on")
            articleStocks.addArticleStocks(article: self.article)
        }
    }
    
    //お気に入り
    func isStockedArticle () ->Bool {
        self.count = 0 //これ使って配列の場所見つけて削除機能つけれそう（ハートimage 使用の場合のはなし）
        for myArticle in self.articleStocks.articles {
            
            if myArticle.link == self.article.link {
                return true
            }
            
            count += 1
            
        }
        
        return false
    }

}
