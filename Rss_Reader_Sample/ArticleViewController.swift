//
//  ArticleViewController.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var TopLeftButton:UIButton!
    @IBOutlet weak var TopCenterButton:UIButton!
    @IBOutlet weak var TopLRightButton:UIButton!
    
    @IBOutlet weak var scrollView:UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        self.scrollView.isPagingEnabled = true
        
        setArticleTableView(0, siteName: "classmethod", siteImageName: "classmethodImage", siteURL: "http://dev.classmethod.jp/category/smartphone/feed/")
    }
    
    func setArticleTableView (_ x: CGFloat, siteName: String, siteImageName: String, siteURL: String){
        
        let frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let articleTableView = ArticleTableView(frame: frame, style: UITableViewStyle.plain)
        articleTableView.siteImageName = siteImageName
        self.scrollView.addSubview(articleTableView)
    }

}
