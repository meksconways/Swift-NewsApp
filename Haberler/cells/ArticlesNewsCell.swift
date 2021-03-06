//
//  ArticleNewsCell.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class ArticlesNewsCell: UICollectionViewCell,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    var mainViewController: MainViewController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = newsList?[indexPath.item]{
            mainViewController?.showNewsDetail(newsID: model.id)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.width * 10 / 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = newsList?.count{
            return count
        }
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ArticleNewsCollectionViewCell
        cell.news = self.newsList?[indexPath.item]
        return cell
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var newsList:[ArticleNewsModelElement]?{
        didSet{
            UIView.transition(with: self.articleCollectionView,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: { self.articleCollectionView.reloadData() })
         // self.articleCollectionView.reloadData()
            
        }
    }
    let title: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 20)
        label.textColor = UIColor(rgb: 0x323232)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tüm Haberler"
        label.numberOfLines = 0
        return label
        
    }()
    
    let articleCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.flashScrollIndicators()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    func setupUI(){
        
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.register(ArticleNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        
        addSubview(articleCollectionView)

        articleCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
    }
    
}

class ArticleNewsCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    
    override func layoutSubviews() {
        gradient.frame = newsImage.frame
        newsImage.layer.addSublayer(gradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var news: ArticleNewsModelElement?{
        didSet{
            
            let imageURL = URL(string: (news?.files[0].fileURL)!)!
            newsImage.kf.setImage(with: imageURL)
            title.text = news?.title
        }
    }
    
    private var gradient: CAGradientLayer!
    
    
    
    func setupUI(){
        addSubview(mainView)
        mainView.addSubview(subView)
        subView.addSubview(newsImage)
        subView.addSubview(graView)
        subView.addSubview(title)
        
        gradient = CAGradientLayer()
        gradient.frame = newsImage.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.locations = [0,1]
        
        
        
        mainView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        subView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        graView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        newsImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        newsImage.clipsToBounds = true
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 12.0
    }
    
    let mainView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    
    
    let subView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let graView : UIView = {
        
        let view = UIView()
        //view.backgroundColor = UIColor(rgb: 0x000000).withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    let newsImage : UIImageView = {
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        
        
    }()
    
    let title: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "Dosis-SemiBold", size: 22)
        label.textColor = UIColor(rgb: 0xffffff)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
}
