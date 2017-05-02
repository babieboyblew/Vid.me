//
//  FeaturedViewModel.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 5/1/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import Foundation

class FeaturedViewModel {

	var dataSource = [Video]()

	func loadVideo(offset: Int, completion:@escaping (_ success: Bool) -> Void) {
		if !ApiManager.sharedInstance.isInternetAvailable() {
			completion(false)
			return
		}


		ApiManager.sharedInstance.loadVideo(offset: offset, api: .apiFeature) { [unowned self] (videoArray) in

			if offset == 0 {
				self.dataSource = [Video]()
			}

			for video in videoArray {
				self.dataSource.append(video)

			}
			completion(true)
		}
	}


	//MARK: - Data for view
	func itemsCount() -> Int {
		return dataSource.count
	}

	func dataAt(index: Int) -> (title: String, like: Int, urlString: String) {
		let video = dataSource[index]
		return (video.title!, video.likes!, video.pictureURLString!)
	}

	func urlVideoAt(index: Int) -> String {
		let video = dataSource[index]
		return video.videoURLString!
	}




}
