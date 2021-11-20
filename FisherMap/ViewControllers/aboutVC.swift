//
//  aboutVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 17.01.2021.
//

import UIKit
import NVActivityIndicatorView
import StoreKit
import MessageUI

struct AboutData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}

class aboutVC: UIViewController {
    
    @IBOutlet weak var backImageView: UIImageView!
    
    //Create about vc object index data
    fileprivate let data = [
        AboutData(title: "Version: 1.0.0", url: "version", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        AboutData(title: "Rate and review Fishing Map app", url: "rateapp", backgroundImage: #imageLiteral(resourceName: "islandThree")),
        AboutData(title: "Share app with friends", url: "shareapp", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        AboutData(title: "Report bugs and problems", url: "sendbugs", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        AboutData(title: "Make a feature request", url: "sendrequest", backgroundImage: #imageLiteral(resourceName: "islandOne")),
        AboutData(title: "How to use", url: "howtouse", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        AboutData(title: "Privacy Policy", url: "privacy", backgroundImage: #imageLiteral(resourceName: "islandThree")),
        AboutData(title: "Terms of Use", url: "termofuse", backgroundImage: #imageLiteral(resourceName: "islandZero")),
        AboutData(title: "License", url: "license", backgroundImage: #imageLiteral(resourceName: "islandOne")),
    ]
    //setup CollectionView
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(AboutCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballGridPulse, color: .darkGray, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            //create collectionview
            loading.stopAnimating()
            self.view.addSubview(self.collectionView)
            //collectionView.backgroundColor = .white
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
            self.collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backImageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    
    }
    
    //Send email func
    func showMailComposer(subject: String) {
        guard MFMailComposeViewController.canSendMail() else {
            //show alert informing the user
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["firatgulecc@icloud.com"])
        composer.setSubject(subject)
        present(composer, animated: true)
    }
}

// MARK: - Compose Mail Delegate

extension aboutVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            //show error alert
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        case .failed:
            print("Failed to send")
        @unknown default:
            print("Failed to send")
        }
        controller.dismiss(animated: true)
    }
}


// MARK: - Collection View properties


extension aboutVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 6)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AboutCell
        cell.data = self.data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(data[indexPath.row].url)")
        //Write actions
        let selection = data[indexPath.row].url
        if selection == "rateapp" {
            //Rate APP
            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1586186748?action=write-review")
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }else if selection == "shareapp" {
            //Share APP
            let postText: String = "You should install this app!"
            let postURL = URL(string: "https://apps.apple.com/app/id1586186748?action=write-review")!
            let activityItems = [postText, postURL] as [Any]
            let activityController = UIActivityViewController(
                activityItems: activityItems,
                applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.view
            activityController.popoverPresentationController?.sourceRect = CGRect(x: self.view!.bounds.midX, y: self.view!.bounds.midY,width: 0,height: 0)
            activityController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
        }else if selection == "sendbugs" {
            self.showMailComposer(subject: "Help This Bugs!")
        }else if selection == "sendrequest" {
            self.showMailComposer(subject: "I need This Func!")
        }else if selection == "howtouse" {
            
        }else if selection == "privacy" {
            
        }else if selection == "termofuse" {
            
        }else if selection == "license" {
            
        }
    }
    
}



    
class AboutCell: UICollectionViewCell {

    var data: AboutData? {
        didSet {
            guard let data = data else { return }
            bg.image = data.backgroundImage
            titleLabel.text = data.title
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 12
        return iv
    }()
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: bg.frame.size.width, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


