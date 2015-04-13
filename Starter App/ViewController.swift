//
//  ViewController.swift
//  Starter App
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Joseph Montanez
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
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
    @IBOutlet weak var scrollView: UIScrollView!
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

