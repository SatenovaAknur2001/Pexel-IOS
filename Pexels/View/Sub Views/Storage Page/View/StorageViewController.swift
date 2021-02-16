//
//  StorageViewController.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/18/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import UIKit

class StorageViewController: UIViewController {
    private var cacheSize: String = "" {
        willSet {
            cacheLabel.text = "Cache: \(newValue == "Zero KB" ? " 0.0 KB" : newValue)"
        }
    }
    private var cleanButton: UIButton = {
        let temp = UIButton()
        temp.layer.borderColor = UIColor(hex: "#20B483").cgColor
        temp.layer.borderWidth = 4.5
        temp.setTitle("CLEAR CACHE", for: .normal)
        temp.setTitleColor(UIColor(hex: "#20B483"), for: .normal)
        temp.titleLabel?.font = UIFont(name: "GillSans", size: 30)
        return temp
    }()
    private var cacheLabel = UILabel()
    private let storageViewModel = StorageViewModel()
    private let spacing: CGFloat = {
        let labelHeight = UIScreen.main.bounds.height * 0.06
        let total = UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.4 - UIScreen.main.bounds.width * 0.55 / 2
        return (total - 2 * labelHeight) / 3
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Storage"
        
        view.addSubview(cleanButton)
        updateCleanButton()
        
        view.addSubview(cacheLabel)
        updateCashLabel()
        
        storageViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCacheAmount()
    }
    
    private func updateCleanButton() {
        cleanButton.backgroundColor = .white
        cleanButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view.frame.height * 0.4)
            make.width.equalTo(view.frame.width * 0.55)
            make.height.equalTo(view.frame.width * 0.55)
        }
        cleanButton.layer.cornerRadius = view.frame.width * 0.55 / 2
        cleanButton.addTarget(self, action: #selector(clearButtonCLicked), for: .touchUpInside)
    }
    
    @objc func clearButtonCLicked() { storageViewModel.clearCache() }
    
    private func updateCashLabel() {
        cacheLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(cleanButton.snp.bottom).offset(spacing)
            make.width.equalTo(view.frame.width * 0.8)
            make.height.equalTo(view.frame.height * 0.1)
        }
        cacheLabel.textAlignment = .center
        cacheLabel.font = UIFont(name: "GillSans", size: 42)
    }
    
}

extension StorageViewController: StorageViewModelDelegate {
    func updateCacheAmount() {
        cacheSize = storageViewModel.getUpdatedCacheAmount()
    }
}
