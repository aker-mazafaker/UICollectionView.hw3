//
//  ViewController.swift
//  UICollectionView.hw3
//
//  Created by Akerke on 11.09.2023.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let imageURLs: [String] = [
        "https://random.dog/9f297526-70cc-432b-a00e-2198e9eccfe8.jpg",
        "https://random.dog/8f969962-5ca9-418c-95e0-7b37817294b1.jpg",
        "https://random.dog/C35XPEgVUAEUkCm.jpg",
        "https://random.dog/00186969-c51d-462b-948b-30a7e1735908.jpg",
        "https://random.dog/4e460068-825d-4277-a269-00e0675b0faf.jpg",
        "https://random.dog/046e5758-d1ef-436f-b7e2-530134562445.jpg",
        "https://random.dog/f355626a-5868-4a22-b173-a7c8571abb80.jpg",
        "https://random.dog/6129aa24-e224-4f7b-8058-e33cca8bfab0.JPG"
    ]
    
    let backImage: UIImageView = {
        let image = UIImageView(frame: UIScreen.main.bounds)
        image.image = UIImage(named: "dogsnLove")
        image.contentMode = .scaleAspectFit
       
        return image
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var images: [UIImage?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collection)
       // view.addSubview(backImage)
//        self.view.insertSubview(backImage, at: 0)
        view.addSubview(activityIndicator)
      loadImages(from: imageURLs)
        setup()
       
    }
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        collection.setCollectionViewLayout(layout, animated: false)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collection.backgroundView = backImage

        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
//        backImage.snp.makeConstraints {
//            $0.edges.equalTo(collection)
//        }
    }
    
    func loadImages(from links: [String]) {
        var loadedImages: [UIImage?] = []
        let group = DispatchGroup()
        activityIndicator.startAnimating()
        
        for link in links {
            group.enter()
            AF.request(link).responseData { response in
            group.leave()
                switch response.result {
                case .success(let data):
                    if let imageData = UIImage(data: data) {
                        loadedImages.append(imageData)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        group.notify(queue: .main) {
            self.images.append(contentsOf: loadedImages)
            self.activityIndicator.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
         let backImage = UIImageView(frame: UIScreen.main.bounds)
        backImage.image = UIImage(named: "dogsnLove")
        backImage.contentMode = .scaleToFill
        collection.backgroundView = backImage
           
        
        if let imageView = cell.contentView.viewWithTag(1) as? UIImageView {
            imageView.image = images[indexPath.item]
        } else {
            let imageView = UIImageView(image: images[indexPath.item])
            imageView.tag = 1
            imageView.contentMode = .scaleAspectFit
            imageView.frame = cell.contentView.bounds
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(imageView)
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 250)
    }
}


