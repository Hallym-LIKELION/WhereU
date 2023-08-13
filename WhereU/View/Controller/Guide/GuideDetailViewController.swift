//
//  GuideDetailViewController.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/11.
//

import UIKit
import WebKit

class GuideDetailViewController: UIViewController {
    
    private var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        return view
    }()
    
    let viewModel: GuideDetailViewModel
    
    init(viewModel: GuideDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        requestURL()
        setupWebView()
    }

    private func configureUI() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func requestURL() {
        guard let request = viewModel.urlRequest else { return }
        webView.load(request)
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
    }
    
}

extension GuideDetailViewController: WKNavigationDelegate {
    // 로드 시작
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoader(true)
    }
    // 로드 종료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showLoader(false)
    }
    // 로드 오류
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.showLoader(false)
    }
    
}
