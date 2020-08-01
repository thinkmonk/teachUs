//
//  DocumentsViewController.swift
//  TeachUs
//
//  Created by ios on 6/9/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit
import WebKit

class DocumentsViewController: BaseViewController {
    
    
    var webView:WKWebView!
    var filepath:String!
    var fileURL:String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        webView = WKWebView()
        webView.navigationDelegate = self
        let filepathURL = URL(fileURLWithPath: filepath)
        webView.loadFileURL(filepathURL, allowingReadAccessTo: filepathURL)
        self.title = "\(URL(string: fileURL)?.lastPathComponent ?? "")"
        self.view.addSubview(webView)
        LoadingActivityHUD.showProgressHUD(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.frame =  CGRect(x: 0.0, y: self.navBarHeight+self.statusBarHeight, width: self.view.width(), height:self.view.height()-(self.navBarHeight+self.statusBarHeight))
    }
    
}

extension DocumentsViewController:WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished")
        LoadingActivityHUD.hideProgressHUD()
    }
}
