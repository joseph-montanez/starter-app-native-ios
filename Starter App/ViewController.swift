//
//  ViewController.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/5/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var previousPage = 0
    var images:[UIImageView?] = [
        UIImageView(image: UIImage(named: "photo0")),
        UIImageView(image: UIImage(named: "photo1")),
        UIImageView(image: UIImage(named: "photo2"))
    ]
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    @IBOutlet weak var scrollView: HomeScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var loaded = 0
        for index in 0..<images.count {
            if let image = images[index] {
                frame.origin.x = view.frame.size.width * CGFloat(index)
                frame.size = view.frame.size
                image.frame = view.frame
                image.contentMode = UIViewContentMode.ScaleAspectFill
                
                var subView = UIView(frame: frame)
                subView.addSubview(image)
                scrollView.addSubview(subView)
                loaded += 1
            }
        }
        
        scrollView.contentSize = CGSizeMake(view.frame.size.width * CGFloat(images.count), self.scrollView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width;
        let fractionalPage = scrollView.contentOffset.x / pageWidth;
        let page = lround(Double(fractionalPage));
        pageControl.currentPage = page
        if (previousPage != page) {
            previousPage = page;
        }
    }

}

