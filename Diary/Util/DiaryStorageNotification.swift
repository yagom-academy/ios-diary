//
//  DiaryStorageNotification.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/24.
//

import Foundation

enum DiaryStorageNotification {
  static let diaryWasSaved = NSNotification.Name("DiaryStorageWasSavedNotification")
  static let diaryWasDeleted = NSNotification.Name("DiaryStorageWasDeletedNotification")
}
