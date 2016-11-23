//
//  DetailViewController.swift
//  Presidents
//
//  Created by Molly Maskrey on 7/13/16.
//  Copyright © 2016 MollyMaskrey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    private var languageListController: LanguageListController?
    private var languageButton: UIBarButtonItem?
    var languageString = "" {
        didSet {
            if languageString != oldValue {
                configureView()
            }
        }
    }


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let dict = detail as! [String: String]
//                let urlString = dict["url"]!
                let urlString = modifyUrlForLanguage(url: dict["url"]!, language: languageString)
                label.text = urlString
                
                let url = URL(string: urlString)!
                let request = URLRequest(url: url )
                webView.loadRequest(request)
                let name = dict["name"]!
                title = name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        languageButton = UIBarButtonItem(title: "Choose Language", style: .plain,
                                         target: self, action: #selector(DetailViewController.showLanguagePopover))
        navigationItem.rightBarButtonItem = languageButton

    }
    
    func showLanguagePopover() {
        if languageListController == nil {
            // Lazy creation when used for the first time
            languageListController = LanguageListController()
            languageListController!.detailViewController = self
            languageListController!.modalPresentationStyle = .popover
        }
        present(languageListController!, animated: true, completion: nil)
        if let ppc = languageListController?.popoverPresentationController {
            ppc.barButtonItem = languageButton
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: AnyObject?  {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    private func modifyUrlForLanguage(url: String, language lang: String?) -> String {
        var newUrl = url
        
        // We're relying on a particular Wikipedia URL format here. This
        // is a bit fragile!
        if let langStr = lang {
            // URL is like https://en.wikipedia…
            let range = NSMakeRange(8, 2)
            if !langStr.isEmpty && (url as NSString).substring(with: range) != langStr {
                newUrl = (url as NSString).replacingCharacters(in: range,
                                                               with: langStr)
            }
        }
        
        return newUrl
    }


}

