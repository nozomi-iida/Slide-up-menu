//
//  ViewController.swift
//  slideUpMenu
//
//  Created by iida nozomi on 2022/01/23.
//

import UIKit

class ViewController: UIViewController {
    // Create the container view
    var containerView = UIView()
    
    var slideUpView = UITableView()
    
    let slideUpViewHeight: CGFloat = 200
    
    let slideUpViewDataSource: [Int: (UIImage?, String)] = [
        0: (UIImage(named: "star"), "Save this tutorial"),
        1: (UIImage(named: "share"), "Share it"),
        2: (UIImage(named: "copy"), "Make a copy"),
        3: (UIImage(named: "apploud"), "Apploud it"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        slideUpView.isScrollEnabled = true
        slideUpView.delegate = self
        slideUpView.dataSource = self
        slideUpView.register(SlideUpViewCell.self, forCellReuseIdentifier: "SlideUpViewCell")
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        // 最前画面クラスを取得する
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let screenSize = UIScreen.main.bounds.size
        slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: slideUpViewHeight)
        slideUpView.separatorStyle = .none

        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        
        window?.addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideUpViewTapped))
        // addGestureRecognizer: タップジェスチャーを追加
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0.8
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.slideUpViewHeight, width: screenSize.width, height: self.slideUpViewHeight)
        },
                       completion: nil)
        
        window?.addSubview(slideUpView)
    }
    
    // On closing
    @objc
    func slideUpViewTapped() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
        },
                       completion: nil)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        slideUpViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlideUpViewCell", for: indexPath) as? SlideUpViewCell else {
            fatalError("unable to deque SlideUpViewCell")
        }
        
        cell.iconView.image = slideUpViewDataSource[indexPath.row]?.0
        cell.labelView.text = slideUpViewDataSource[indexPath.row]?.1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
