//
//  LoadingView.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 19/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation

import UIKit

class LoadingView: UIView {
    
    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var loadingIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let defaultTitle = "loading"
    
    private var title: String?
    
    //
    // MARK: - Lifecycle
    //
    
    private static func newInstance() -> LoadingView? {
        return UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LoadingView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let title = title {
            titleLabel.text = title
        } else {
            titleLabel.text = defaultTitle
        }
    }
    
    static func showInView(_ view: UIView, title: String? = nil) -> LoadingView? {
        
        guard let loadingView = LoadingView.newInstance() else {
            return nil
        }
        
        loadingView.setupInView(view)
        loadingView.animateLoadingIcon()
        loadingView.animateViewShow()
        
        return loadingView
    }
    
    private func setupInView(_ view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        view.bringSubviewToFront(self)
    }
    
    private func animateLoadingIcon() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat], animations: { [weak self] in
            self?.loadingIconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: nil)
    }
    
    private func animateViewShow() {
        alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.alpha = 1
        })
    }
    
    func hide() {
        animateViewHide()
    }
    
    private func animateViewHide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
