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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView.navigationDelegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white        
        setNavigationRightImage(imageName: "heart_on")
        
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
        barButtonItem.customView = rightImage
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

}
