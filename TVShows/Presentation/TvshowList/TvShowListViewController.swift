//
//  TvShowListViewController.swift
//  TVShows
//
//  Created by Christos Kaktsis on 10/5/23.
//

import UIKit
import RxSwift

class TvShowListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: TvShowListViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: TvShowListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        viewModel.fetchData()
    }
    
    func setupView(){
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "#001d3dff")
        //        tableView.delegate = self
        //        tableView.dataSource = self
        let cellnib = UINib(nibName: "TvShowTableViewCell", bundle: Bundle(for: type(of: self)))
        
        tableView.register(cellnib, forCellReuseIdentifier: "TvShowTableViewCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.backgroundColor = UIColor(hex: "#001d3dff")
        tableView.sectionIndexBackgroundColor = UIColor(hex: "#001d3dff")
        tableView.sectionIndexTrackingBackgroundColor = UIColor(hex: "#001d3dff")
//        viewModel.delegate = self
        setUpObservers()
    }
    
    @objc func handleRefreshControl(){
        viewModel.fetchTVShows()
        
    }
    private func setUpObservers(){
        viewModel.stateObserver.map { newState -> Bool in
            return newState.isLoading
        } .distinctUntilChanged()
            .bind(onNext: { [weak self] (isLoading) in
                if isLoading {
                    print("Isloading")
                    self?.tableView.refreshControl?.beginRefreshing()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }).disposed(by: disposeBag)
        
        viewModel.stateObserver.map { newState -> [TvShow] in
            return newState.tvShows
        }
        .distinctUntilChanged()
        .bind(to: tableView.rx.items(cellIdentifier: "TvShowTableViewCell", cellType: TvShowTableViewCell.self)) { [weak self] (_, item, cell) in
            self?.viewModel.fetchImage(url: item.thumbUrl) { data in
                cell.setup(tvShow: item, image: data)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.navigate(index: indexPath.item)
        })
        .disposed(by: disposeBag)
    }
}
//
//extension TvShowListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.tvShows.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TvShowTableViewCell", for: indexPath)
//                as? TvShowTableViewCell else {
//            fatalError("DequeueReusableCell failed while casting")
//        }
//        let item = viewModel.getTvShow(index: indexPath.row)
//        viewModel.fetchImage(url: item.image.medium) { data in
//            cell.setup(tvShow: item, image: data)
//        }
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        navigate(index: indexPath.item)
//    }
//
//}
//extension TvShowListViewController: TvShowListDelegate{
//    func didGetData() {
//        tableView.reloadData()
//        tableView.refreshControl?.endRefreshing()
//    }
//}

extension TvShowListViewController {
    
    func navigate(index: Int){
        let selectedShow = viewModel.getTvShow(index: index)
        viewModel.handleAction(action: .GO_TO_DETAIL(SHOW: selectedShow))
    }
}

