//
//  ArticleViewController.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIScrollViewDelegate, ArticleTableViewDelegate {
    
    @IBOutlet weak var TopLeftButton:UIButton!
    @IBOutlet weak var TopCenterButton:UIButton!
    @IBOutlet weak var TopLRightButton:UIButton!
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    var selectedArticle: Article?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isDirectionalLockEnabled = true
        
        setArticleTableView(0, siteName: Constant.classmethod, siteImageName: Constant.classmethodImageName, siteURL: Constant.classmethodURL)
        setArticleTableView(self.view.frame.width, siteName: Constant.lifehacker, siteImageName: Constant.lifehackerImageName, siteURL: Constant.lifehackerURL)
        setArticleTableView(self.view.frame.width*2, siteName: Constant.wired, siteImageName: Constant.wiredImageName, siteURL: Constant.wiredURL)
        
        //お気に入りの記事を起動時に取得
        ArticleStocks.sharedInstance.getMyArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTopButtonColor()
    }
    
    func setArticleTableView (_ x: CGFloat, siteName: String, siteImageName: String, siteURL: String){
        
        let frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let articleTableView = ArticleTableView(frame: frame, style: UITableViewStyle.plain)
        articleTableView.customDelegate = self
        articleTableView.siteName = siteName
        articleTableView.siteImageName = siteImageName
        articleTableView.loadURL(siteURL: siteURL)
        self.scrollView.addSubview(articleTableView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setTopButtonColor()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setTopButtonColor()
    }
    
    func setTopButtonColor () {
        let page = scrollView.contentOffset.x
        
        switch page {
        case 0:
            TopLeftButton.titleLabel?.textColor = UIColor.orange
            TopCenterButton.titleLabel?.textColor = UIColor.white
            TopLRightButton.titleLabel?.textColor = UIColor.white
        case self.view.frame.width:
            TopLeftButton.titleLabel?.textColor = UIColor.white
            TopCenterButton.titleLabel?.textColor = UIColor.orange
            TopLRightButton.titleLabel?.textColor = UIColor.white
        case self.view.frame.width*2:
            TopLeftButton.titleLabel?.textColor = UIColor.white
            TopCenterButton.titleLabel?.textColor = UIColor.white
            TopLRightButton.titleLabel?.textColor = UIColor.orange
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let articleWebViewController = segue.destination as! ArticleWebViewController
        articleWebViewController.article = selectedArticle
    }
    
    func didSelectTableViewCell(article: Article) {
        self.selectedArticle = article
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
    
    
    @IBAction func tapTopLeftButton(_ sender: Any) {
        let pointX = 0
        scrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
    }
    @IBAction func topCenterButton(_ sender: Any) {
        let pointX = self.view.frame.width
        scrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
    }
    @IBAction func topRightButton(_ sender: Any) {
        let pointX = self.view.frame.width*2
        scrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
    }


}
