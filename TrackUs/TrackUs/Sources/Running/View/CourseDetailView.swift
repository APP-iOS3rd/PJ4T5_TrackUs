//
//  CourseDetailView.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/22.
//

import SwiftUI
import MapboxMaps

struct CourseDetailView: View {
    enum MenuValue: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case edit = "수정"
        case delete = "삭제"
    }
    
    private let authViewModel = AuthenticationViewModel.shared
    
    @State private var showingAlert = false
    
    @EnvironmentObject var router: Router
    @StateObject var userSearchViewModel = UserSearchViewModel()
    @ObservedObject var courseViewModel: CourseViewModel
    
    var isOwner: Bool {
        courseViewModel.course.ownerUid == authViewModel.userInfo.uid
    }
    
    var body: some View {
        VStack {
            PathPreviewMap(
                mapStyle: .numberd,
                coordinates: courseViewModel.course.toCoordinates
            )
            .frame(height: 230)
            
            ScrollView {
                VStack(spacing: 0)   {
                    RunningStats(
                        estimatedTime: courseViewModel.course.estimatedTime,
                        calories: courseViewModel.course.estimatedCalorie,
                        distance: courseViewModel.course.toCoordinates.caculateTotalDistance()
                    )
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    
                    courseDetailLabels
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    
                    participantList
                        .padding(.top, 20)
                        .padding(.leading, 16)
                }
                .padding(.bottom, 30)
            }
            VStack {
                let memberContains = courseViewModel.course.members.contains(authViewModel.userInfo.uid)
                let isOwner = courseViewModel.course.ownerUid == authViewModel.userInfo.uid
                let exceedsCapacity = courseViewModel.course.members.count >= courseViewModel.course.numberOfPeople
                
                if exceedsCapacity && !memberContains {
                    MainButton(active: false, buttonText: "해당 러닝은 마감되었습니다.") {
                    }
                }
                else if !memberContains {
                    MainButton(buttonText: "러닝 참가하기") {
                        courseViewModel.addParticipant()
                    }
                } else if memberContains {
                    MainButton(active: !isOwner, buttonText: "러닝 참가취소", buttonColor: .Caution) {
                            courseViewModel.removeParticipant()
                    }
                }
                
            }
            .padding(.horizontal, 16)
        }
        .customNavigation {
            NavigationText(title: "모집글 상세보기")
        } left: {
            NavigationBackButton()
        } right: {
            VStack {
               if isOwner { editMenu }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("알림"),
                message: Text("모집글이 삭제됩니다.\n해당 모집글을 삭제 하시겠습니까?"),
                primaryButton: .default (
                    Text("취소"),
                    action: { }
                ),
                secondaryButton: .destructive (
                    Text("삭제"),
                    action: {
                        courseViewModel.removeCourse {
                            router.popToRoot()
                        }
                    }
                )
            )
        }
    }
}

extension CourseDetailView {
    
    // 제목, 부가설명 등등
    var courseDetailLabels: some View {
        VStack {
            HStack {
                Text(courseViewModel.course.startDate.formattedString())
                    .customFontStyle(.gray2_R12)
                Spacer()
                RunningStyleBadge(style: .init(rawValue: courseViewModel.course.runningStyle) ?? .running)
            }
            
            VStack(alignment: .leading) {
                Text(courseViewModel.course.title)
                    .customFontStyle(.gray1_B20)
                
                HStack(spacing: 10) {
                    HStack {
                        Image(.pin)
                        
                        Text(courseViewModel.course.address)
                            .customFontStyle(.gray1_R12)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Image(.arrowBoth)
                        Text(courseViewModel.course.distance.asString(unit: .kilometer))
                            .customFontStyle(.gray1_R12)
                    }
                }
                
                Text(courseViewModel.course.content)
                    .customFontStyle(.gray1_R14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // 참여자 리스트
    
    var participantList: some View {
        VStack(alignment: .leading) {
            UserList(
                users: userSearchViewModel.filterdUserData(uid: courseViewModel.course.members),
                ownerUid: courseViewModel.course.ownerUid
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var editMenu: some View {
        Menu {
            ForEach(MenuValue.allCases) { menu in
                let role: ButtonRole = menu == .delete ? .destructive : .cancel
                Button(role: role) {
                    switch menu {
                    case .delete:
                        deleteButtonTapped()
                    case .edit:
                        editButtonTapped()
                    }
               } label: {
                   Text(menu.rawValue)
                       
               }
           }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(.black)
        }
    }
}

extension CourseDetailView {
    func editButtonTapped() {
        router.push(.courseRegister(CourseRegViewModel(
            docID: courseViewModel.course.uid,
            style: RunningStyle(rawValue: courseViewModel.course.runningStyle)!,
            coorinates: courseViewModel.course.toCoordinates,
            title: courseViewModel.course.title,
            content: courseViewModel.course.content,
            selectedDate: courseViewModel.course.startDate,
            estimatedTime: courseViewModel.course.estimatedTime,
            estimatedCalorie: courseViewModel.course.estimatedCalorie,
            numberOfPeople: courseViewModel.course.numberOfPeople,
            image: UIImage()
        )))
    }
    
    func deleteButtonTapped() {
        showingAlert = true
    }
}
