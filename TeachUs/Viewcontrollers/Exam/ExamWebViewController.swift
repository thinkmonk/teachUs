//
//  ExamWebViewController.swift
//  TeachUs
//
//  Created by iOS on 20/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit
import WebKit
import UserNotifications

enum AppStateLog: String {
    case Minimised = "minimize"
    case Terminated = "terminate"
}

class ExamWebViewController: BaseViewController {
    weak var parentNavigationController : UINavigationController?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private lazy var progressView :UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        return progressView
    }()

    private lazy var manager : NetworkHandler = {
        let handler = NetworkHandler()
        return handler
    }()

    
    private var estimatedProgressObserver: NSKeyValueObservation? = nil
    var urlString:String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        navigationItem.hidesBackButton = true
        self.title = "EXAM"
        setUpWebView()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        setupProgressView()
        setupEstimatedProgressObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.frame =  CGRect(x: 0.0, y: self.navBarHeight+self.statusBarHeight, width: self.view.width(), height:self.view.height()-(self.navBarHeight+self.statusBarHeight))
    }
    
    deinit {
        if let observer = estimatedProgressObserver{
            observer.invalidate()
            estimatedProgressObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
        progressView.removeFromSuperview()
    }

    
    fileprivate func setUpWebView() {
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupProgressView() {
        //add progresbar to navigation bar
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(progressView)
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        progressView.frame = CGRect(x: 0, y: navigationBarBounds!.size.height - 2, width: navigationBarBounds!.size.width, height: 2)
    }
        
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func appMovedToBackground() {
        submitAppLog(type: .Minimised)
        triggerNotificaitons(type: .Minimised)
    }
    
    @objc func appWillTerminate() {
        submitAppLog(type: .Terminated)
        triggerNotificaitons(type: .Terminated)
    }
    
    
    func submitAppLog(type:AppStateLog)
    {
        manager.url = URLConstants.Login.examLog

        let parameters = [
            "event":"\(type.rawValue)",
            "reason":"NA",
            "device_type":"ios",
            "student_id": "\(UserManager.sharedUserManager.getStudentExamId())",
            "timestamo": "\(NSDate().timeIntervalSince1970)"
        ]

        manager.apiPost(apiName: "Submit Appstate log", parameters:parameters, completionHandler: { (result, code, response) in
            print(response)
            if let status = response["status"] as? Int,
                status == 200
            {
                let message = response["message"] as? String
                print("Log resposne \(message ?? "")")
            }else{
                print("Logging failed")
            }
        }) { [weak self] (error, code, message) in
            self?.showAlertWithTitle(nil, alertMessage: message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    func triggerNotificaitons(type:AppStateLog){
        let content = UNMutableNotificationContent()
        content.title = type == .Minimised ?  "Alert ‼️" : "Alert ‼️"
        content.body = type == .Minimised ? "You've minimized the App, this will be notified to the college \nReturn to exam" : "You've closed the App, this will be notified to the college \nReturn to exam"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Notificaiton trigger failed \(error.localizedDescription)")
            }
        })

    }
}

extension ExamWebViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if (urlStr.contains(URLConstants.Exam.examCompletionURL)) { //using if check here, so that once the button is enabled it wont be hidden if the check fails for othet URL
                navigationItem.hidesBackButton = false
            }
        }
        decisionHandler(.allow)
    }
}
