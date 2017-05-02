//
//  FeedViewModel.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 5/2/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import Foundation



class FeedViewModel {

	var delegate: FollowingVideoDelegate?
	var dataSource = [Dictionary<String, [Video]>]()

	func loadFollowingUserVideo() {
		


		ApiManager.sharedInstance.loadFollowingUsers { [unowned self] (array) in
			self.dataSource = array
			self.delegate?.updateData()
		}
	}

	func numberOfSection() -> Int {
		return dataSource.count
	}

	func numberOfRowAt(_ section: Int) -> Int {
		let item = dataSource[section]
		return (item.values.first?.count)!
	}


	func titleForHeaderIn(_ section: Int) -> String {
		let item = dataSource[section]
		return item.keys.first!
	}


	func dataForCellAt(_ indexPath: IndexPath) -> (title: String, likes: Int, picture: String, video: String) {
		let item = dataSource[indexPath.section]
		let key = item.keys.first!
		let videosArray = item[key]
		let video = videosArray?[indexPath.row]

		return (video!.title! , video!.likes!, video!.pictureURLString!, video!.videoURLString!)
	}






	
}
