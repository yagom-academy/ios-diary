//
//  DiaryScrollView.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/28.
//

import UIKit

final class DiaryScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}
