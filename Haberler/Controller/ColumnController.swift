//
//  ColumnController.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import UIKit
import RxSwift
class ColumnController: UICollectionViewController,
UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Dosis-SemiBold", size: 20)!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xc54545)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        collectionView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.delegate = self
        collectionView.register(ColumnNewsCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        self.title = "Köşe Yazıları"
        self.view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        getColumnNews()
        
    }
    
    
    func showColumnDetail(newsId: String, writerName:String){
        let controller = ColumnDetailController()
        controller.newsId = newsId
        controller.writerName = writerName
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    let indicator = UIActivityIndicatorView(style: .gray)
    private var selectingCount:Int = 0
    private var alreadyRoot:Bool = true //singleton
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex

        if tabBarIndex == 2 {
            selectingCount += 1

            if alreadyRoot{
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                alreadyRoot = false
                return
            }

            if selectingCount > 1{
                if tabBarController.selectedViewController?.navigationItem.title == "Köşe Yazıları"{
                    self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                }else{
                    selectingCount -= 1
                }

            }

        }else{
            selectingCount = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showColumnDetail(newsId: self.columnNews[indexPath.item].id, writerName: self.columnNews[indexPath.item].fullname)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columnNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ColumnNewsCollectionViewCell
        cell.columnNews = self.columnNews[indexPath.item]
        return cell
    }
    
    
    var columnNews:[ColumnModelElement] = []
    
    private let disposeBag = DisposeBag()
    func getColumnNews(){
        ApiClient.getColumnNews()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (news) in
                self.columnNews = news
            }, onError: { (error) in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            }, onCompleted: {
                self.indicator.stopAnimating()
                UIView.transition(with: self.collectionView,
                                  duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: { self.collectionView.reloadData() })
            })
            
            .disposed(by: disposeBag)
    }
    
}
