//
//  BaseChatCell.swift
//  YLBaseChat
//
//  Created by yl on 17/5/25.
//  Copyright © 2017年 yl. All rights reserved.
//

import Foundation
import UIKit
import YYText
import SnapKit

protocol BaseChatCellDelegate: NSObjectProtocol {
    func epDidVoiceClick(_ message: Message)
    func epDidImageClick(_ message: Message)
}

class BaseChatCell: UITableViewCell {
    
    var isNeedBubbleBackground = true
    var messageTimeLabel:UILabel!
    var messageAvatarsImageView:UIImageView!
    var messageUserNameLabel:UILabel!
    var messagebubbleBackImageView:UIImageView?
    
    var message:Message?
    var indexPath:IndexPath?
    weak var delegate:BaseChatCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化
    func layoutUI() {
        
        contentView.backgroundColor = Definition.colorFromRGB(0xf2f2f2)
        
        // 消息时间
        messageTimeLabel = UILabel()
        messageTimeLabel.font = UIFont.systemFont(ofSize: 12)
        messageTimeLabel.textColor = UIColor.white
        messageTimeLabel.backgroundColor = Definition.colorFromRGB(0xd7d7d7)
        messageTimeLabel.layer.cornerRadius = 10
        messageTimeLabel.clipsToBounds = true
        messageTimeLabel.textAlignment = NSTextAlignment.center
        contentView.addSubview(messageTimeLabel)
        
        // 用户头像
        messageAvatarsImageView = UIImageView()
        messageAvatarsImageView.layer.cornerRadius = 18
        messageAvatarsImageView.clipsToBounds = true
        contentView.addSubview(messageAvatarsImageView)
        
        // 用户名
        messageUserNameLabel = UILabel()
        messageUserNameLabel.font = UIFont.systemFont(ofSize: 12)
        messageUserNameLabel.textColor = Definition.colorFromRGB(0xb9b9bb)
        contentView.addSubview(messageUserNameLabel)
        
        if isNeedBubbleBackground {
            // 气泡
            messagebubbleBackImageView = UIImageView()
            messagebubbleBackImageView?.isUserInteractionEnabled = true
            contentView.addSubview(messagebubbleBackImageView!)
        }
        
    }
    
    // 加载cell内容
    public func updateMessage(_ m: Message,idx: IndexPath) {
        
        message = m
        indexPath = idx
        
        if message?.direction == MessageDirection.send.rawValue {
            
            messageAvatarsImageView.snp.remakeConstraints({ (make) in
                
                make.top.equalTo(48)
                make.width.height.equalTo(36)
                make.right.equalTo(-8)
            })
            
            messageAvatarsImageView.image = UIImage(named: "ico_my_h")
            
            messageUserNameLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(messageAvatarsImageView)
                make.right.equalTo(messageAvatarsImageView.snp.left).offset(-8)
            })
            
            messageUserNameLabel.isHidden = true
            
            if isNeedBubbleBackground {
                
                messagebubbleBackImageView?.image = UIImage(named: "bg_bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: UIImageResizingMode.stretch)
                
                messagebubbleBackImageView?.snp.remakeConstraints({ (make) in
                    make.right.equalTo(messageAvatarsImageView.snp.left).offset(-8)
                    make.top.equalTo(messageAvatarsImageView)
                })
                
            }
            
        }else {
            
            messageAvatarsImageView.snp.remakeConstraints({ (make) in
                
                make.top.equalTo(48)
                make.width.height.equalTo(36)
                make.left.equalTo(8)
            })
            
            messageAvatarsImageView.image = UIImage(named: "ico_my_h")
            
            messageUserNameLabel.snp.remakeConstraints({ (make) in
                
                make.top.equalTo(messageAvatarsImageView)
                make.left.equalTo(messageAvatarsImageView.snp.right).offset(8)
            })
            
            messageUserNameLabel.text = "匿名"
            messageUserNameLabel.isHidden = false
            
            if isNeedBubbleBackground {
                
                messagebubbleBackImageView?.image = UIImage(named: "bg_bubble_white")?.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: UIImageResizingMode.stretch)
                
                messagebubbleBackImageView?.snp.remakeConstraints({ (make) in
                    make.left.equalTo(messageAvatarsImageView.snp.right).offset(8)
                    make.top.equalTo(messageUserNameLabel.snp.bottom).offset(4)
                })
                
            }
            
        }
        
        layoutIfNeeded()
    }
    
    // 检测是否显示时间
    public func updateTime(_ upTime: String?) {
        
        messageTimeLabel.isHidden = false
        
        if let upTime = upTime {
            if var upTime = TimeInterval(upTime) {
                if let time = message?.timestamp {
                    if var time = TimeInterval(time) {
                        
                        if upTime > 140000000000 {
                            upTime = upTime / 1000
                        }
                        
                        if time > 140000000000 {
                            time = time / 1000
                        }
                        
                        if time - upTime < 2 * 60 {
                            messageTimeLabel.isHidden = true
                        }else {
                            messageTimeLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let time = message?.timestamp {
            if let time = TimeInterval(time) {
                let date = Date(timeIntervalSince1970: time)
                let timeStr = date.getShowFormat()
                messageTimeLabel.text =  timeStr
                
                // 计算宽度
                let width = NSString(string: timeStr).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:messageTimeLabel.font], context: nil).size.width + 10
                
                messageTimeLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(20);
                    make.height.equalTo(20);
                    make.width.equalTo(width)
                    make.centerX.equalTo(contentView);
                })
            }
        }
    }
}
