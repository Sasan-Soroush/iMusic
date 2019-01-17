//
//  DownloadViewController.swift
//  iMusic
//
//  Created by New User on 1/9/19.
//  Copyright © 2019 sasan soroush. All rights reserved.
//

import UIKit

extension DownloadViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addKeyboardNotifiactions()
        
    }
    
    
}

extension DownloadViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath) as! SearchResultTableViewCell
        
        setupCell(cell, indexPath)
        cell.searchResult = self.searchResults[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/8
    }
    
    fileprivate func setupCell(_ cell: SearchResultTableViewCell, _ indexPath: IndexPath) {
        let paddingForTexts : CGFloat = 10
        cell.line.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: cell.frame.width, height: 0.5)
        cell.musicImage.frame = CGRect(x: 0, y: 5, width: cell.frame.height-10, height: cell.frame.height-10)
        cell.musicName.frame = CGRect(x: cell.musicImage.frame.maxX + 10, y: paddingForTexts, width: cell.frame.width - cell.musicImage.frame.width - 10, height: cell.frame.height/2-paddingForTexts)
        cell.musicArtist.frame = CGRect(x: cell.musicImage.frame.maxX + 10, y: cell.frame.height/2, width: cell.frame.width - cell.musicImage.frame.width - 10, height: cell.frame.height/2-paddingForTexts)
        
        cell.selectionStyle = .none
    }
}

extension DownloadViewController {
    
    private func addKeyboardNotifiactions() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.searchBar.frame.origin.y = view.frame.height - 50 - keyboardSize.height
            self.searchResultTableView.frame = CGRect(x: 10, y: self.logo.frame.maxY , width: view.frame.width-20, height: self.searchBar.frame.minY - self.logo.frame.maxY - 10)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.searchBar.frame.origin.y = view.frame.height - 50
        self.searchResultTableView.frame = CGRect(x: 10, y: self.logo.frame.maxY , width: view.frame.width-20, height: self.searchBar.frame.minY - self.logo.frame.maxY - 10)
    }
    
}

extension DownloadViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else {
            Helper.shared.alert(self, title: "", body: "مشکلی با متن وارد شده وجود دارد.")
            return
        }
        
        API.search(text: text) { (success, searchResultArray) in
            self.searchResults = searchResultArray
            self.searchResultTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //TODO:- search after 1 second delay
    }
}

class DownloadViewController : BaseViewControllerPresented {
    
    private var searchResults : [SearchResult] = []
    
    private func setupView() {
        
        view.addSubview(searchBar)
        view.addSubview(searchResultTableView)
        
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 10, y: view.frame.height - 50, width: view.frame.width - 20, height: 40)
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
        searchResultTableView.separatorStyle = .none
        
        searchResultTableView.frame = CGRect(x: 10, y: logo.frame.maxY , width: view.frame.width-20, height: searchBar.frame.minY - logo.frame.maxY - 10)
        
        setupSearchBar()
        
    }
    
    private func setupSearchBar() {
        
        let cancelButtonAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        if let txtSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txtSearchField.borderStyle = .none
            txtSearchField.backgroundColor = UIColor.MyTheme.textFieldBG
            txtSearchField.layer.cornerRadius = 8
            txtSearchField.clipsToBounds = true
            txtSearchField.keyboardAppearance = .dark
            let attributedString = NSAttributedString(string: "  نام اهنگ یا خواننده", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray , NSAttributedStringKey.font : Font.IranYekanLight(size: 18) ])
            txtSearchField.attributedPlaceholder = attributedString
            
        }
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.MyTheme.textFieldTextColor
        }
    }
    
    //MARK:- UI Properties
    
    let searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.clipsToBounds = true
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    let searchResultTableView : UITableView = {
        let view = UITableView(frame: .zero, style: UITableViewStyle.plain)
        view.backgroundColor = .clear
        return view
    }()
    
}














