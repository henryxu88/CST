//
//  WebViewController.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var strTitle = ""
    var strUrl = ""
    
    @IBOutlet weak var webView: UIWebView!
    let indicator = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    func loadWebPageWithString(strUrl: String){
        let url = NSURL.init(string: strUrl)
        if let url = url {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupReturnButton()
        
        title = strTitle
        
        indicator.activityIndicatorViewStyle = .White
        view.addSubview(indicator)
        
        indicator.center = view.center

        webView.delegate = self
        webView.userInteractionEnabled = true
        webView.scalesPageToFit = true
        
        loadWebPageWithString(strUrl)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - delegate methods
    func webViewDidStartLoad(webView: UIWebView) {
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        indicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        displayMessage("显示页面出错！")
    }
    
    
}