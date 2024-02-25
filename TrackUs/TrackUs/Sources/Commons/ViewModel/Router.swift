//
//  Router.swift
//  TrackUs
//
//  Created by 석기권 on 2024/01/30.
//

import SwiftUI

// MARK: - PAGE
enum Page: Hashable, Identifiable {
    // Root
    case running
    case chat
    case report
    case profile
    // Profile
    case profileEdit
    case runningRecorded
    case faq
    case setting
    case withDrawal
    // Home
    case runningStart
    case runningResult(TrackingViewModel)
    case courseDetail(Course)
    case courseDrawing
    case courseRegister(CourseRegViewModel)
    // Chat
    case chatting(ChatViewModel)
    // Report
    case recordDetail(Runninglog)
    // UserProfileView
    case userProfile(String)
}

extension Page {
    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var id: String {
        String(describing: self)
    }
}

// MARK: - FULL SCREEN
enum FullScreenCover: String, Identifiable {
    case payment
    
    var id: String {
        self.rawValue
    }
}

// MARK: - SHEET
enum Sheet: Hashable, Identifiable {
    static func == (lhs: Sheet, rhs: Sheet) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case webView(url: String)
    
    var id: String {
        String(describing: self)
    }
}

enum Tab {
    case running, recruitment, chat, report, profile
}

final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var selectedIndex: Tab = .running
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func pop() {
        if path.count != 0 {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    
    @ViewBuilder
    func buildScreen(page: Page) -> some View {
        switch page {
        case .running:
            RunningHomeView()
        case .chat:
            ChattingListView()
        case .report:
            ReportView()
        case .profile:
            MyProfileView()
        case .profileEdit:
            ProfileEditView()
        case .runningRecorded:
            RunningRecordView()
        case .courseDetail(let course):
            CourseDetailView(course: course)
        case .courseDrawing:
            CourseDrawingView()
        case .courseRegister(let courseRegViewModel):
            CourseRegisterView(courseRegViewModel: courseRegViewModel)
        case .faq:
            FAQView()
        case .setting:
            SettingsView()
        case .withDrawal:
            Withdrawal()
        case .runningStart:
            RunningStartView()
        case .runningResult(let trackingViewModel):
            RunningResultView(trackingViewModel: trackingViewModel)
        case .recordDetail(let myRecord):
            MyRecordDetailView(runningLog: myRecord)
        case .userProfile(let userId):
            UserProfileView(userUid: userId)
        case .chatting(let chatViewModel):
            ChattingView(chatViewModel: chatViewModel)
        }
    }
    
    @ViewBuilder
    func buildScreen(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .payment:
            PremiumPaymentView()
        }
    }
    
    @ViewBuilder
    func buildScreen(sheet: Sheet) -> some View {
        switch sheet {
        case .webView(url: let url):
            WebViewSurport(url: url)
        }
    }
}

extension Page {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
