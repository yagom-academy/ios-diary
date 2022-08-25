//
//  NameSpace.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import CoreGraphics

enum NameSpace {
    static let placeHolder = "여기에 내용을 입력하세요"
    static let close = "닫기"
    static let diary = "일기장"
    static let lineChange = "\n"
    static let twiceLineChange = "\n\n"
    static let share = "공유"
    static let noneTitle = "제목없음"
    static let delete = "삭제"
    static let whiteSpace = ""
    static let cellIdentifier = "diaryCell"
    static let shareActionTitle = "share..."
    static let deleteActionTitle = "Delete"
    static let cancel = "취소"
    static let deleteAlertTitle = "진짜요?"
    static let deleteAlertMessage = "정말로 삭제하시겠어요?"
    static let cancelActionTitle = "Cancel"
    static let newDiary = "새로운일기장"
}

enum CoreDataKeys {
    static let title = "title"
    static let body = "body"
    static let createdAt = "createdAt"
}

enum Number {
    static let sectionCount = 1
    static let spacing: CGFloat = 10
}

enum SystemName {
    static let shareIcon = "person.crop.circle.badge.plus"
    static let deleteIcon = "trash"
    static let moreViewIcon = "ellipsis.circle"
    static let documentIcon = "doc.text"
}
