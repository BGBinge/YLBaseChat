//
//  YLFaceView.swift
//  YLBaseChat
//
//  Created by yl on 17/5/22.
//  Copyright © 2017年 yl. All rights reserved.
//

import UIKit

protocol YLFaceViewDelegate:NSObjectProtocol {
    
    func epInsertFace(_ image:UIImage) // 插入表情
    func epDeleteTextFromTheBack()     // 从最后面开始删除
    func epSendMessage()               // 发送消息
}

class YLFaceView: UIView {
    
    weak var delegate:YLFaceViewDelegate?
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    fileprivate var pageControl:UIPageControl!
    
    fileprivate var emojiDic:NSDictionary!
    fileprivate var emojiImages = Array<String>()
    
    override func awakeFromNib() {
        layoutUI()
    }
    
    fileprivate func layoutUI() {
        backgroundColor = UIColor.white
        
        let path = Bundle.main.path(forResource: "emojiImage.plist", ofType: nil)
        emojiDic = NSDictionary(contentsOfFile: path!)
        
        for i in 0...25 {
            emojiImages.append("emot_ic_\(i)")
        }
        
        // UIScrollView
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: YLScreenWidth*2, height: 0)
        
        pageControl = UIPageControl()
        pageControl.center = CGPoint(x: yl_width / 2 , y: 170 - 15)
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.colorFromRGB(0xdfdfdf)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 245/255.0, green: 62/255.0, blue: 102/255.0, alpha: 1.0)
        pageControl.numberOfPages = 2
        pageControl.backgroundColor = UIColor.clear
        
        addSubview(pageControl)
        
        for index in 0...1 {
            
            let view:UIView = UIView(frame: CGRect(x: 10 + YLScreenWidth * CGFloat(index), y: 5, width: YLScreenWidth - 20, height: 170))
            view.backgroundColor = UIColor.clear
            scrollView.addSubview(view)
            
            let everypages:Int = 20
            let everyrows:Int = 7
            let row:Int = 3
            
            let w:CGFloat = 38.0
            let space = (view.yl_width - CGFloat(everyrows) * w)/CGFloat(everyrows + 1)
            let y:CGFloat = 10.0
            
            for i in 0...(row - 1) {
                
                for j in 0...(everyrows - 1) {
                    
                    let btn:UIButton = UIButton(frame: CGRect(x:space + (space + w) * CGFloat(j), y: CGFloat(i) * (w + y) + y, width: ceil(w), height: ceil(w)))
                    btn.backgroundColor = UIColor.clear
                    
                    if i * everyrows + j + index * everypages > emojiImages.count {
                        return
                    }else{
                        
                        if (i * everyrows + j == everypages) ||
                            (i * everyrows + j + index * everypages == emojiImages.count) {
                            
                            btn.setImage(UIImage(named: "delete_expression"), for: UIControlState.normal)
                            btn.tag = 10000
                        }else{
                            
                            btn.setImage(UIImage(named: emojiImages[i * everyrows + j + index * everypages]), for: UIControlState.normal)
                            btn.tag = i * everyrows + j + index * everypages
                        }
                        
                        btn.addTarget(self, action: #selector(YLFaceView.emojiSelected(_:)), for: UIControlEvents.touchUpInside)
                        
                        view.addSubview(btn)
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    @objc fileprivate func emojiSelected(_ btn:UIButton){
        
        if btn.tag == 10000 {
            delegate?.epDeleteTextFromTheBack()
        }else{
            
            let image = UIImage(named: emojiImages[btn.tag])
            
            for (key,value) in emojiDic {
                if String(describing: value) == emojiImages[btn.tag] {
                    image?.yl_tag = String(describing: key)
                }
            }
            
            delegate?.epInsertFace(image!)
        }
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        delegate?.epSendMessage()
    }
}


// MARK: - UIScrollViewDelegate
extension YLFaceView:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x / YLScreenWidth
        pageControl.currentPage = Int(page)
        
    }
    
}
