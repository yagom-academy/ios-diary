//
//  DiaryProtocol.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/02.
//

protocol DiaryProtocol {
    var title: String { get set }
    var body: String { get set }
    var createdDate: Double { get set }
    var weatherState: String? { get set }
    var icon: String? { get set }
}
