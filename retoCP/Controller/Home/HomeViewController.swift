//
//  ViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var moviesList: [MovieModel] = []
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getMovieList()
        setControllerStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    private func setControllerStyle() {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundB"))
        UITabBar.setTransparentTabbar()
        UITabBar.appearance().barTintColor = .white
        self.tabBarItem.image = UIImage(systemName: "house.fill")
        tabBarController?.tabBar.items![1].image = UIImage(systemName: "star.fill")
        tabBarController?.tabBar.items![2].image = UIImage(systemName: "person.fill")
        userImage.layer.cornerRadius = 22.5
    }
    
    private func getUserData() {
        let userData = User.sharedInstance.recoverUserData()
        
        userLabel.text = userData.name != "" ? userData.name : "Invitado"
        
        if userData.avatarUrl != "" {
            let url = URL(string: userData.avatarUrl)
            if let data = try? Data(contentsOf: url!){
                self.userImage.image = UIImage(data: data)!
            } else {
                self.userImage.image = UIImage(systemName: "person.circle")!
            }
        } else {
            self.userImage.image = UIImage(systemName: "person.circle")!
        }
    }
    private func getMovieList() {
        PremieresWS.sharedService.getMoviesData(self) { movies in
            self.moviesList = movies
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
        } failureResponse: { errorMsg in
            print(errorMsg)
        }
    }
    
    func showHomePopUp(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "PopUpHomeViewController") as! PopUpHomeViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        self.present(popupVC, animated: true, completion: nil)
    }
    
    @objc func changeImage() {
     
     if counter < moviesList.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         counter = 1
     }
    }

}
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        cell.movieTitleLabel.text = moviesList[indexPath.row].description
        cell.movieImageView.image = moviesList[indexPath.row].image
        cell.movieImageView.layer.cornerRadius = 30
        return cell
    }
    
    // CONFIGURAR COLLECTIONVIEW SIZES
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-30, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userData = User.sharedInstance.recoverUserData()
        if userData.name == "" {
            showHomePopUp()
        }
    }
    
}

extension HomeViewController: PopUpHomeDelegate {
    func didTappedLogin() {
        self.tabBarController?.selectedIndex = 2
    }
    func didTappedStore() {
        self.tabBarController?.selectedIndex = 1
    }
}


