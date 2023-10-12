//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 26/07/23.
//

import UIKit

extension UIView {
     func addSubviews(_ views: UIView...) {
         views.forEach({
             addSubview($0)
         })
    }
}
