//
//  WebView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/31.
//

import SwiftUI
import WebKit

struct WebViewSurport: View {
    @ObservedObject var model: WebViewModel
    //    @StateObject var model = WebViewModel(url: "http://www.google.com")
    
    init(url: String) {
        self.model = WebViewModel(url: url)
    }
    var body: some View {
        LoadingView(isShowing: self.$model.isLoading) {
            WebView(viewModel: self.model)
        }
    }
}

class WebViewModel: ObservableObject {
    @Published var url: String
    @Published var isLoading: Bool = true
    
    init (url: String) {
        self.url = url
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    let webView = WKWebView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self.viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel
        
        init(_ viewModel: WebViewModel) {
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.viewModel.isLoading = false
        }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WebView>) { }
    
    func makeUIView(context: Context) -> UIView {
        self.webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: self.viewModel.url) {
            self.webView.load(URLRequest(url: url))
        }
        
        return self.webView
    }
}

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                    .foregroundColor(Color.main)
                    .cornerRadius(20)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        activityIndicatorView.color = .main
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
