//
//  CALayer+Extensions.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/17.
//

import UIKit

extension CALayer {
    
    // MARK: - Methods
    
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(
                    x: 8,
                    y: 0,
                    width: frame.width - 16,
                    height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect(
                    x: 8,
                    y: frame.height - width,
                    width: frame.width - 16,
                    height: width
                )
            case UIRectEdge.left:
                border.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: width,
                    height: frame.height
                )
            case UIRectEdge.right:
                border.frame = CGRect(
                    x: frame.width - width,
                    y: 0, width: width,
                    height: frame.height
                )
            default:
                break
            }
            
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
