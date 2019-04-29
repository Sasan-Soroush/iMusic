//
//  ProfileViewController.swfit
//  myBook-iOS
//
//  Created by Frederic Quenneville on 17-11-03.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentPlansTableViewCell.id, for: indexPath) as! PaymentPlansTableViewCell
            cell.paymentPlans.frame = cell.frame
            cell.selectionStyle = .none
            
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? view.frame.height/4 : view.frame.height/10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateHeaderView()
    }
    
    
}

class ProfileViewController: BaseViewControllerNormal {
    
    // MARK : - Attributes
    let headerTitle = "title"
    
    let headerSubtitle = "subtitle"
    
    let image = #imageLiteral(resourceName: "Screen Shot 2019-04-27 at 5.30.32 PM")
    
    var minHeaderHeight: CGFloat {
        return view.frame.height/5
    }
    
    var maxHeaderHeight: CGFloat {
        return view.frame.height/2.5
    }
    
    let tintColor: UIColor = .black
    
    let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 32)
    
    let subtitleFont: UIFont = UIFont.systemFont(ofSize: 20)
    
    let shadowColor: CGColor = UIColor.black.cgColor
    
    let shadowOffset: CGSize = .zero
    
    let shadowRadius: CGFloat = 0
    
    let shadowOpacity: Float = 0
    
    var progress : CGFloat {
        return (imageView.frame.height - minHeaderHeight)/(maxHeaderHeight - minHeaderHeight)
    }
    
    var headerCollapsingAnimationDuration: Double = 1
    var headerExpandingAnimationDuration: Double = 1
    
    // Defining margin in this file in order to reuser the class in multiple projects
    fileprivate let margin: CGFloat = 10
    
    // MARK : - UI Elements
    fileprivate lazy var imageView: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate lazy var imageMaskView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "Rectangle")
        view.clipsToBounds = true
        return view
    }()
    
    lazy var settingLabel : CustomLabel = {
        let label = CustomLabel(customFont: Font.IranYekanLight(size: 25))
        label.text = "تنظیمات پروفایل"
        label.alpha = 0
        return label
    }()
    
    let scrollView : UITableView = {
        let view = UITableView(frame: .zero, style: UITableViewStyle.plain)
        view.backgroundColor = .clear
        view.separatorColor = .clear
        return view
    }()
    
    // MARK :  - Lifecycle methods
    
    fileprivate func setupGeneral() {
        
        imageView.image = image
        
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGeneral()
        
        scrollView.delegate = self
        scrollView.dataSource = self
        scrollView.register(PaymentPlansTableViewCell.self, forCellReuseIdentifier: PaymentPlansTableViewCell.id)
       
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        view.layer.sublayers = nil
        view.backgroundColor = UIColor.MyTheme.backgroundColor
        
        view.addSubview(imageView)
        imageView.frame.size = CGSize(width: view.frame.width, height: maxHeaderHeight)
        
        view.addSubview(imageMaskView)
        imageMaskView.frame.size = CGSize(width: view.frame.width, height: maxHeaderHeight)
        
        view.addSubview(scrollView)
        scrollView.frame = view.frame
        scrollView.frame.size.height = view.frame.height - helper.getTabBarHeight()
        
        view.addSubview(settingLabel)
        settingLabel.frame = CGRect(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height/5 - 20)
        
        view.bringSubview(toFront: imageView)
        view.bringSubview(toFront: imageMaskView)
        
        scrollView.contentInset.top = imageView.frame.height
        scrollView.contentOffset.y = -imageView.frame.height
        
        scrollView.contentInset.top = imageMaskView.frame.height
        scrollView.contentOffset.y = -imageMaskView.frame.height
        
        view.bringSubview(toFront: settingLabel)
    }
    
    func expandHeader() {
        UIView.animate(withDuration: headerExpandingAnimationDuration) {
            self.scrollView.contentOffset.y = -self.maxHeaderHeight
            self.imageView.frame.size.height = self.maxHeaderHeight
            self.imageMaskView.frame.size.height = self.maxHeaderHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func collapseHeader() {
        UIView.animate(withDuration: headerCollapsingAnimationDuration) {
            self.scrollView.contentOffset.y = -self.minHeaderHeight
            self.imageView.frame.size.height = self.minHeaderHeight
            self.imageMaskView.frame.size.height = self.maxHeaderHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func updateHeaderView() {
        
        if scrollView.contentOffset.y < -maxHeaderHeight {
            imageView.frame.size.height = -scrollView.contentOffset.y
            imageMaskView.frame.size.height = imageView.frame.size.height
        } else if scrollView.contentOffset.y >= -maxHeaderHeight && scrollView.contentOffset.y < -minHeaderHeight {
            imageView.frame.size.height = -scrollView.contentOffset.y
            imageMaskView.frame.size.height = imageView.frame.size.height
        } else {
            imageView.frame.size.height = minHeaderHeight
            imageMaskView.frame.size.height = minHeaderHeight
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        imageView.alpha = progress
        
        if progress == 0.0 {
            imageMaskView.alpha = 0.0
        } else {
            imageMaskView.alpha = 1.0
        }
        
        settingLabel.alpha = 1.0 - progress
    }
}

