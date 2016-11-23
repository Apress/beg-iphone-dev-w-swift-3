//
//  ViewController.swift
//  DialogViewer
//
//  Created by Molly Maskrey on 7/12/16.
//  Copyright © 2016 MollyMaskrey. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout   {
    private var sections = [
        ["header": "First Witch",
         "content" : "Hey, when will the three of us meet up later?"],
        ["header" : "Second Witch",
         "content" : "When everything's straightened out."],
        ["header" : "Third Witch",
         "content" : "That'll be just before sunset."],
        ["header" : "First Witch",
         "content" : "Where?"],
        ["header" : "Second Witch",
         "content" : "The dirt patch."],
        ["header" : "Third Witch",
         "content" : "I guess we'll see Mac there."]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView?.register(ContentCell.self, forCellWithReuseIdentifier: "CONTENT")

        var contentInset = collectionView!.contentInset
        contentInset.top = 20
        collectionView!.contentInset = contentInset
        
        let layout = collectionView!.collectionViewLayout
        let flow = layout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 20, 30, 20)
        
        self.collectionView?.register(HeaderCell.self,
                                      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                      withReuseIdentifier: "HEADER")
     
        flow.headerReferenceSize = CGSize(width: 100, height: 25)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func wordsInSection(section: Int) -> [String] {
        let content = sections[section]["content"]
        let spaces = NSCharacterSet.whitespacesAndNewlines
        let words = content?.components(separatedBy: spaces)
        return words!
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let words = wordsInSection(section: section)
        return words.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let words = wordsInSection(section: indexPath.section)
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CONTENT", for: indexPath) as! ContentCell
        cell.maxWidth = collectionView.bounds.size.width
        cell.text = words[indexPath.row]
        return cell
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let words = wordsInSection(section: indexPath.section)
        let size = ContentCell.sizeForContentString(s: words[indexPath.row],
                                                    forMaxWidth: collectionView.bounds.size.width)
        return size

    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let cell =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: "HEADER",
                    for: indexPath) as! HeaderCell
            cell.maxWidth = collectionView.bounds.size.width
            cell.text = sections[indexPath.section]["header"]
            return cell
        }
        abort()
    }


}

