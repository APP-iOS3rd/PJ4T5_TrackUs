//
//  Constants.swift
//  TrackUs
//
//  Created by SeokKi Kwon on 2024/01/29.
//

import Foundation
import Firebase

enum Constants {
    enum ViewLayout {
        static let VIEW_STANDARD_HORIZONTAL_SPACING: CGFloat = 16
        static let VIEW_STANDARD_VERTICAL_SPACING: CGFloat = 16
    }
    
    enum WebViewUrl {
        static let TERMS_OF_SERVICE_URL = "https://lizard-basketball-e41.notion.site/TrackUs-6015541452f14ed2b2f1541e5259ea72?pvs=4"
        static let OPEN_SOURCE_LICENSE_URL = "https://lizard-basketball-e41.notion.site/a57a3078e21c4821932d2189859b8bcb?pvs=4"
        static let SERVICE_REQUEST_URL = "https://forms.gle/drvCZV4kHdgZJonRA"
        static let TEAM_INTRO_URL = "https://lizard-basketball-e41.notion.site/Team-TrackUs-2d71e86df51f4bbba4b0b7a5b04ac947?pvs=4"
    }
    
    enum RunningStyle {
        
    }
    
    enum FirebasePath {
        static let RUNNING_RECORDS = Firestore.firestore().collection("runningRecords")
    }
}
