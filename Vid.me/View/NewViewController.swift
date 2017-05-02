//
//  NewViewController.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 5/1/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class NewViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityView: UIActivityIndicatorView!

	let viewModel = NewViewModel()
	var offset = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		let refreshControll = UIRefreshControl()
		refreshControll.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

		tableView.refreshControl = refreshControll
		tableView.tableFooterView = UIView()

		loadVideo(offset: offset)


    }

	//MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "playVideo" {
			let indexPath = sender as! IndexPath
			let urlVideo = viewModel.urlVideoAt(index: indexPath.row)

			let playerController = segue.destination as! AVPlayerViewController
			let playerItem = AVPlayerItem(url: URL(string: urlVideo)!)
			playerController.player = AVPlayer(playerItem: playerItem)
			playerController.player?.play()
		}

	}

	//MARK: - Helper
	func loadVideo(offset: Int) {
		activityView.startAnimating()
		viewModel.loadVideo(offset: offset) { [unowned self] success in
			DispatchQueue.main.async {

				if success {
					self.tableView.reloadData()
					self.tableView.isScrollEnabled = true
				} else {
					self.showAlert("Ooops!", "Check internet connection and try again.")
				}

				self.activityView.stopAnimating()
				if (self.tableView.refreshControl?.isRefreshing)! {
					self.tableView.refreshControl?.endRefreshing()
				}
			}
		}
	}

	func showAlert(_ title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}



	func pullToRefresh() {
		offset = 0
		loadVideo(offset: offset)
	}

}



extension NewViewController: UITableViewDataSource, UITableViewDelegate {
	//MARK: - UITableViewDataSorce
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.itemsCount()
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoCell

		let tuple = viewModel.dataAt(index: indexPath.row)

		cell.titleLabel.text = tuple.title
		cell.likeLabel.text  = "\(tuple.like) likes"
		cell.activityView.startAnimating()
		let url = URL(string: tuple.urlString)
		if let URL = url {
			cell.pictureImageView.sd_setImage(with: URL) { (complited) in  cell.activityView.stopAnimating() }
		}

		return cell
	}

	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "playVideo", sender: indexPath)
	}



}



extension NewViewController: UIScrollViewDelegate {

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

		if maximumOffset - currentOffset <= 200.0 {
			scrollView.isScrollEnabled = false
			offset = viewModel.itemsCount()
			loadVideo(offset: viewModel.itemsCount())
		}
	}
}










