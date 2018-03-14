//
//  PostTableViewCell.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import RxSwift
import SnapKit
import UIKit

public class PostTableViewCell: UITableViewCell {
  private var titleLabel: UILabel!
  private var subredditLabel: UILabel!
  private var userLabel: UILabel!
  private var scoreLabel: UILabel!
  
  public var title: String {
    get {
      return titleLabel.text ?? ""
    } set {
      titleLabel.text = newValue
    }
  }
  
  public var subreddit: String {
    get {
      return subredditLabel.text ?? ""
    } set {
      subredditLabel.text = "in /r/\(newValue)"
    }
  }
  
  public var user: String {
    get {
      return userLabel.text ?? ""
    } set {
      userLabel.text = "by /u/\(newValue) "
    }
  }
  
  public var score: Int64 {
    get {
      return 0
    } set {
      scoreLabel.text = newValue.coloquialString()
    }
  }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    prepareScoreLabel()
    prepareTitleLabel()
    prepareSubredditLabel()
    prepareUserLabel()
  }
  
  private func prepareScoreLabel() {
    scoreLabel = UILabel()
    scoreLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .heavy)
    scoreLabel.textAlignment = .center
    scoreLabel.textColor = .salt
    
    scoreLabel.backgroundColor = .azure
    scoreLabel.layer.cornerRadius = 32.0
    scoreLabel.clipsToBounds = true
    
    contentView.addSubview(scoreLabel)
    
    scoreLabel.snp.makeConstraints { maker in
      maker.height.equalTo(64)
      maker.width.equalTo(64)
      
      maker.top.equalToSuperview().offset(16)
      maker.left.equalToSuperview().offset(16)
      maker.bottom.lessThanOrEqualTo(contentView).offset(-48)
    }
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    titleLabel.numberOfLines = 0
    titleLabel.textColor = .slate
    
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { maker in
      maker.height.greaterThanOrEqualTo(24)
      maker.top.equalToSuperview().offset(8)
      maker.left.equalTo(scoreLabel.snp.right).offset(16)
      maker.right.equalToSuperview().offset(-16)
    }
  }
  
  private func prepareSubredditLabel() {
    subredditLabel = UILabel()
    subredditLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    subredditLabel.textColor = .cloudy
    
    contentView.addSubview(subredditLabel)
    
    subredditLabel.snp.makeConstraints { maker in
      maker.top.equalTo(titleLabel.snp.bottom).offset(8)
      maker.right.bottom.equalToSuperview().offset(-16)
    }
  }
  
  private func prepareUserLabel() {
    userLabel = UILabel()
    userLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    userLabel.textColor = .cloudy
    
    contentView.addSubview(userLabel)
    
    userLabel.snp.makeConstraints { maker in
      maker.top.equalTo(titleLabel.snp.bottom).offset(8)
      maker.bottom.equalToSuperview().offset(-16)
      maker.right.equalTo(subredditLabel.snp.left)
    }
  }
}
