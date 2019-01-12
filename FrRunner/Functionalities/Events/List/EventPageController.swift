//
//  EventPageController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 20/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

class EventPageController : BaseController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var pagesControllers : [EventListViewController]?
    
    var pageController : UIPageViewController?
    var selectedIndexPath : IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        
        
        self.registerCells()
        
        
        self.loadPager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let selectedIndexPath = self.selectedIndexPath else {
            self.collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
            
            return
        }
        
        self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: UInt(selectedIndexPath.row)))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pageController = segue.destination as? UIPageViewController;
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.setViewControllers([self.pagesControllers?.first ?? UIViewController.init()], direction: .forward, animated: false, completion: nil)
        
        self.selectedIndexPath = IndexPath.init(row: 0, section: 0)
        
    }
    
    //MARK - Properties
    
    func loadPager() {
        
        self.pagesControllers = [ EventListViewController.newInstanceWithEventListType(withType: EventListSectionType.EventListYourSection),
        
        EventListViewController.newInstanceWithEventListType(withType: EventListSectionType.EventListSponsoredSection),
         EventListViewController.newInstanceWithEventListType(withType: EventListSectionType.EventListSponsoredSection),
          EventListViewController.newInstanceWithEventListType(withType: EventListSectionType.EventListSponsoredSection),
                EventListViewController.newInstanceWithEventListType(withType: EventListSectionType.EventListOthersSection)
        
        ] as? [EventListViewController]
        
    }
    
    //MARK: - CollectioView
    
    func registerCells() {
        collectionView.register(UINib.init(nibName: "EventsListSectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventsListSectionCollectionViewCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventListSectionType.EventListSectionCount.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsListSectionCollectionViewCell", for: indexPath) as! EventsListSectionCollectionViewCell
        
        if(indexPath == selectedIndexPath){
            cell.isSelected = true
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            cell.isSelected = false
        }
        
        cell.loadWithSectionName(sectionType:indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 160, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 70 * 4
        let totalSpacingWidth = 10 * (4 - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let forward : Bool = self.selectedIndexPath?.row ?? 0 < indexPath.row
        
        var direction = UIPageViewController.NavigationDirection.forward
        
        self.selectedIndexPath = indexPath
        
        if(!forward){
            direction = UIPageViewController.NavigationDirection.reverse
        }
        
        guard let pageControllers = self.pagesControllers else {
            return
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.pageController?.setViewControllers([pageControllers[self.selectedIndexPath?.row ?? 0]], direction: direction, animated: false, completion: nil)
        
        self.collectionView.reloadData()
        
    }
    
    //MARK: - PageView
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index : Int = self.pagesControllers?.firstIndex(of:viewController as! EventListViewController) ?? 0
        
        if(index > 0){
            return self.pagesControllers?[index - 1]
        }
        
        self.collectionView.reloadData()
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index : Int = self.pagesControllers?.firstIndex(of: viewController as! EventListViewController) ?? 0
        
        if(index + 1 < self.pagesControllers?.count ?? 0){
            return self.pagesControllers?[index + 1]
        }
        
        self.collectionView.reloadData()
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let index = self.pagesControllers?.firstIndex(of: pageViewController.viewControllers?.first as! EventListViewController) else {
            return
        }
        
        self.selectedIndexPath = IndexPath.init(row: index, section: 0)
        
        collectionView.reloadData()
        
    }
    
}
