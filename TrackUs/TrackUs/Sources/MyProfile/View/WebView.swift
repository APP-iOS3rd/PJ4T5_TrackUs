//
//  WebView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/31.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}



