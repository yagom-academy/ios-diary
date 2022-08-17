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
                border.frame = CGRect.init(
                    x: 8,
                    y: 0,
                    width: frame.width - 16,
                    height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(
                    x: 8,
                    y: frame.height - width,
                    width: frame.width - 16,
                    height: width
                )
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(
                    x: 0,
                    y: 0,
                    width: width,
                    height: frame.height
                )
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(
                    x: frame.width - width,
                    y: 0, width: width,
                    height: frame.height
                )
                break
            default:
                break
            }
            
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
