
//
//  FeedViewController.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 4/30/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol FollowingVideoDelegate {
	func updateData()
}

class FeedViewController: UIViewController {


	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityView: UIActivityIndicatorView!

	let viewModel = FeedViewModel()
	var dataSource = [Dictionary<String, [Video]>]()


    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel.delegate = self
		tableView.tableFooterView = UIView()

		let refreshControll = UIRefreshControl()
		refreshControll.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
		tableView.refreshControl = refreshControll

		loginButton.layer.cornerRadius = 5
		loginButton.clipsToBounds = true
    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)


		if (ApiManager.sharedInstance.token != nil) && (ApiManager.sharedInstance.userID != nil) {
			stackView.isHidden = true
			tableView.isHidden = false
			activityView.startAnimating()
			viewModel.loadFollowingUserVideo()
			addLogOutButton()
		} else {
			stackView.isHidden = false
			tableView.isHidden = true
			activityView.stopAnimating()
		}
	}


	//MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "playVideo" {
			let indexPath = sender as! IndexPath
			let urlVideo = viewModel.dataForCellAt(indexPath).video

			let playerController = segue.destination as! AVPlayerViewController
			let playerItem = AVPlayerItem(url: URL(string: urlVideo)!)
			playerController.player = AVPlayer(playerItem: playerItem)
			playerController.player?.play()
		}

	}

	//MARK: - Action
	@IBAction func loginAction(_ sender: UIButton) {
		if let userName = usernameTextField.text, let password = passwordTextField.text {
			if userName.characters.count > 0 && password.characters.count > 0 {
				let parameters = ["username": userName,
				                  "password": password]

				ApiManager.sharedInstance.loginWith(parameters) { [unowned self] result in
					DispatchQueue.main.async {
						if result == "invalid_username" || result == "invalid_password" {
							self.showAlert("Error", result)

						} else {
							self.stackView.isHidden = true
							self.tableView.isHidden = false

							self.activityView.startAnimating()
							self.viewModel.loadFollowingUserVideo()
							self.addLogOutButton()
						}
					}
				}


			} else if userName.characters.count == 0 && password.characters.count == 0 {
				showAlert("Error", "No username and password")
			} else if userName.characters.count == 0 {
				showAlert("Error", "No username")
			} else if password.characters.count == 0 {
				showAlert("Error", "No password")
			}
		}
	}

	func logoutAction(_ sender: UIButton) {
		ApiManager.sharedInstance.token = nil
		ApiManager.sharedInstance.userID = nil

		tableView.isHidden = true
		stackView.isHidden = false

		UserDefaults.standard.removeObject(forKey: "user")
		sender.removeFromSuperview()
	}

	func pullToRefresh() {
		tableView.refreshControl?.beginRefreshing()
		viewModel.loadFollowingUserVideo()
	}

	//MARK: - Helpers
	func showAlert(_ title: String, _ message: String?) {
		let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}

	func addLogOutButton() {
		let button = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 89, width: UIScreen.main.bounds.size.width, height: 45))
		button.setTitle("LogOut", for: .normal)
		button.backgroundColor = UIColor.gray
		button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)

		view.addSubview(button)
	}

}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
	//MARK: - UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.numberOfSection()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRowAt(section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoCell

		let tuple = viewModel.dataForCellAt(indexPath)

		cell.likeLabel.text  = "\(tuple.likes) likes"
		cell.titleLabel.text = tuple.title

		cell.activityView.startAnimating()
		let url = URL(string: tuple.picture)
		if let URL = url {
			cell.pictureImageView.sd_setImage(with: URL) { (complited) in  cell.activityView.stopAnimating() }
		}

		return cell
	}

	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
		header.backgroundColor = UIColor.black
		let label = UILabel(frame: CGRect(x: 8, y: 0, width: header.bounds.size.width - 8, height: 30))
		label.textColor = UIColor.white
		header.addSubview(label)

		label.text = viewModel.titleForHeaderIn(section)

		return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "playVideo", sender: indexPath)
	}


}

//MARK: - FollowingVideoDelegate
extension FeedViewController: FollowingVideoDelegate {
	func updateData() {
		tableView.reloadData()
		activityView.stopAnimating()
		if (tableView.refreshControl?.isRefreshing)! {
			tableView.refreshControl?.endRefreshing()
		}

	}
}





