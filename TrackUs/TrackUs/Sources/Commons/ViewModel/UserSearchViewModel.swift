//
//  UserSearchViewModel.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/25.
//

import Foundation

/**
 유저 검색 뷰모델
 */

class UserSearchViewModel: ObservableObject {
    let id = UUID()
    @Published var users = [UserInfo]()
    
    init() {
        fetchUsersData()
    }
    
    /// 모든 유저 가져오기
    func fetchUsersData() {
        Constants.FirebasePath.COLLECTION_UESRS.getDocuments { snapShot, error in
            if let error = error {
                print("DEBUG: Failed Login \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapShot?.documents else { return }
            self.users = documents.compactMap {try? $0.data(as: UserInfo.self)}
        }
    }
    
    /// uid를 받아서 유저데이터 반환
    func filterdUserData(uid: [String]) -> [UserInfo] {
        return users.filter {uid.contains($0.uid)}
    }
}

extension UserSearchViewModel: Hashable {
    static func == (lhs: UserSearchViewModel, rhs: UserSearchViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
