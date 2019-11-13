//
//  ViewController.swift
//  Project 4
//
//  Created by William Fernandez on 10/10/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    // list of "safe" websites
    var websites = ["apple.com", "hackingwithswift.com"]

    // load the webView
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add navigation bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        // add webView observer to track the progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        // instantiate the UIProgressView
        progressView = UIProgressView(progressViewStyle: .default)
        // resize the progressView so that it optimizes space
        progressView.sizeToFit()
        // instantiate the progressButton to hold the progressView
        let progressButton = UIBarButtonItem(customView: progressView)
        // make the spacer and refresh buttons
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // refresh button that reloads the web page
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        // add all the items to the webView toolbar
        toolbarItems = [progressButton, spacer, refresh]
        // show the toolbar
        navigationController?.isToolbarHidden = false
        // wrap the website string into a URL
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
    }
    
    // this function is called whenever the open barButtonItem is clicked
    @objc func openTapped() {
        // instantiate the action sheet
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        // add an action for each website
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // configure for iPad popovers
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // function to open page when website option is clicked in action sheet
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // when done loading the web page, change the title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // configure the progress of the progressView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            // progress property of progressView is a float, so convert to float
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // decide which links on the websites are able to be opened
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        // not all URL's have a host
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }


}

