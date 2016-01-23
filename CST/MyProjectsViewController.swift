//
//  MyProjectsViewController.swift
//  
//
//  Created by henry on 16/1/20.
//
//

import UIKit
import MMDrawerController
import HMSegmentedControl

class MyProjectsViewController: UIViewController {
    
    var segmentedControl: HMSegmentedControl!
    var scrollView: UIScrollView!
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLeftButton()
        
        // 设置滑动tab
        viewWidth = CGRectGetWidth(view.bounds)
        viewHeight = CGRectGetHeight(view.bounds)
        segmentedControl = HMSegmentedControl.init(frame: CGRectMake(0, 64, viewWidth, 40))
        segmentedControl.sectionTitles = [Words.prjsNotFinish, Words.prjsFinished]
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : Style.tintColor]
        segmentedControl.selectionIndicatorColor = Style.tintColor
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.tag = 101
        
        segmentedControl.indexChangeBlock = { [weak self] in self?.segmentIndexChanged($0) }
        view.addSubview(segmentedControl)
        
        // 设置scrollView
        scrollView = UIScrollView.init(frame: CGRectMake(0, 104, viewWidth, viewHeight - 148))
        scrollView.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(viewWidth * CGFloat(segmentedControl.sectionTitles.count), viewHeight - 148)
        scrollView.delegate = self
//        scrollView.scrollRectToVisible(CGRectMake(viewWidth, 0, viewWidth, viewHeight - 148), animated: false)
        view.addSubview(scrollView)
        
        let label1 = UILabel.init(frame: CGRectMake(0, 0, viewWidth, viewHeight-148))
        setApperanceForLabel(label1)
        label1.text = Words.prjsNotFinish
        scrollView.addSubview(label1)
        
        let label2 = UILabel.init(frame: CGRectMake(viewWidth, 0, viewWidth, viewHeight-148))
        setApperanceForLabel(label2)
        label2.text = Words.prjsFinished
        scrollView.addSubview(label2)
        

    }
    
    func setApperanceForLabel(label: UILabel){
        
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(21)
        label.textAlignment = .Center
    }
    
    func segmentIndexChanged(index: Int){
        //        print("Selected index: \(index)")
        self.scrollView.scrollRectToVisible(CGRectMake(viewWidth * CGFloat(index), 0, viewWidth, viewHeight - 148), animated: true)
    }
    
    func setupLeftButton(){
        let btn = MMDrawerBarButtonItem.init(target: self, action: "hideMenuButtonTapped")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setLeftBarButtonItem(btn, animated: true)
    }
    
    func hideMenuButtonTapped() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyProjectsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let page = scrollView.contentOffset.x / pageWidth
        segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
    }
}