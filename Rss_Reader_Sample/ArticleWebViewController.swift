//
//  ArticleWebViewController.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import WebKit


class ArticleWebViewController: UIViewController {

    var article: Article!
    let wkWebView = WKWebView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //サイト表示のために必要な箇所
        let URL = Foundation.URL(string: article.link)
        let URLReq = URLRequest(url: URL!)
        self.wkWebView.frame = self.view.frame
        self.wkWebView.load(URLReq)
        self.view.addSubview(wkWebView)
    }
}
