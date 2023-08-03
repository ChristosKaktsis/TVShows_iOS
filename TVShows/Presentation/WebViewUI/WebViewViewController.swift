//
//  WebViewViewController.swift
//  TVShows
//
//  Created by Christos Kaktsis on 12/5/23.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    var viewModel: WebViewViewModel
    
    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        // Do any additional setup after loading the view.
    }


    private func setUp(){
        let myURL = URL(string: viewModel.url)
                let myRequest = URLRequest(url: myURL!)
                webView.load(myRequest)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
