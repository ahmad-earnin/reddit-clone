//
//  ViewController.swift
//  RedditClone
//
//  Created by Ahmad Husseini on 2018-03-13.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class FeedViewController: UIViewController {
  public var viewModel: FeedViewModelProtocol!
  public var router: FeedRouter!
  
  public let disposeBag = DisposeBag()
  
  private var tableView: UITableView!
  private var searchController: UISearchController!
  
  public convenience init(viewModel: FeedViewModelProtocol, router: FeedRouter) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.router = router
  }
  
  public override func viewDidLoad() {
    prepareView()
    prepareBindings()
  }
  
  private func prepareView() {
    prepareNavigationItem()
    prepareTableView()
    prepareSearchController()
  }
  
  private func prepareNavigationItem() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.barTintColor = .salt
    navigationController?.navigationBar.tintColor = .slate
    navigationController?.navigationBar.largeTitleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.slate
    ]
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.slate
    ]
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { maker in
      maker.edges.equalToSuperview()
    }
  }
  
  private func prepareSearchController() {
    searchController = UISearchController()
    searchController.searchBar.placeholder = "Search by subreddit"
    
    navigationItem.searchController = searchController
  }
  
  private func prepareBindings() {
    viewModel.title
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    viewModel.posts
      .subscribeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "postCell", cellType: PostTableViewCell.self)) { index, model, cell in
        cell.score = model.score
        cell.title = model.title
        cell.subreddit = model.subreddit
        cell.user = model.user
      }
      .disposed(by: disposeBag)
    
    tableView.rx.didScroll
      .filter { [weak self] _ in
        guard let this = self else { return false }
        let tableViewHeight = this.tableView.frame.height
        let contentHeight = this.tableView.contentSize.height
        let contentYOffset = this.tableView.contentOffset.y
        return ((contentHeight - tableViewHeight) - contentYOffset) <= 200
      }
      .throttle(0.3, scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let this = self else { return }
        this.viewModel.shouldFetchNext.onNext(())
      })
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Post.self)
      .subscribe(onNext: { [weak self] post in
        guard let this = self else { return }
        this.router.route(
          to: FeedRouter.Routes.viewPost.rawValue,
          from: this,
          parameters: post.url
        )
      })
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let this = self else { return }
        this.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.shouldFetchNext.onNext(())
  }
}
