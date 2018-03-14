//
//  FeedViewModel.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import Foundation
import Moya
import RxOptional
import RxSwift
import SwiftyJSON

public protocol FeedViewModelProtocol {
  var posts: BehaviorSubject<[Post]> { get }
  var shouldFetchNext: PublishSubject<Void> { get }
  var title: Observable<String> { get }
}

public final class FeedViewModel: FeedViewModelProtocol {
  public var posts: BehaviorSubject<[Post]>
  public var shouldFetchNext: PublishSubject<Void> = PublishSubject()
  
  public let disposeBag = DisposeBag()
  private let provider: MoyaProvider<Reddit>
  
  private let subreddit: String
  private var after: String = ""
  private var isIdle: Bool = true
  
  public init(provider: MoyaProvider<Reddit>, subreddit: String) {
    self.provider = provider
    self.subreddit = subreddit
    
    posts = BehaviorSubject<[Post]>(value: [])
    shouldFetchNext = PublishSubject()
    
    setup()
  }
  
  public var title: Observable<String> {
    return Observable.just("/r/\(subreddit)")
  }
  
  private func setup() {
    let fetchNext = shouldFetchNext
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .map { [weak self] _ in self?.isIdle ?? true }
      .filter { $0 }
      
    fetchNext
      .do(onNext: { [weak self] _ in self?.isIdle = false })
      .flatMap { [weak self] _ in self?.fetchListing() ?? Observable.just(Data() as Any) }
      .map { JSON($0) }
      .map { Listing($0) }
      .filterNil()
      .do(onNext: { [weak self] listing in
        guard let this = self else { return }
        this.after = listing.after
      })
      .map { [weak self] listing in
        guard let this = self else { return [] }
        guard var totalPosts: [Post] = try? this.posts.value() else { return listing.children }
        totalPosts.append(contentsOf: listing.children)
        return totalPosts
      }
      .do(onNext: { [weak self] _ in self?.isIdle = true })
      .bind(to: posts)
      .disposed(by: disposeBag)
  }
  
  private func fetchListing() -> Observable<Any> {
    return provider.rx.request(.subreddit(name: subreddit, after: after))
      .filterSuccessfulStatusCodes()
      .asObservable()
      .mapJSON()
  }
}
