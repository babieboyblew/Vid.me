//
//  ApiManager.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 4/30/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SystemConfiguration


let clientID = "lkZo37ZzN6gSLpxwythliWqrleC2gyNR"
let key		 = "iABWsIqHjv24rSaiBJei0ZNmBHkDXioY"
let secret   = "dYQv9gAfEuuBxM9cDf7RBDTjxBcWtXWejqoY0IAq"


let baseURL      = "https://api.vid.me/"
let apiLogin     = "auth/create"





enum API: String {
	case apiFeature = "videos/featured"
	case apiNew     = "videos/new"
}


class ApiManager {

	var userID: String?
	var token: String?

	var followingIDs: [Dictionary<String, String>]?


	static let sharedInstance: ApiManager = {
		let instance = ApiManager()

		return instance
	}()

	init() {
		let userData = UserDefaults.standard.value(forKey: "user")
		if let data = userData {
			let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! User
			userID  = user.user_id!
			token   = user.token!
		} else {
			userID = nil
			token = nil
		}


	}


	//MARK: - Login
	func loginWith(_ parameters: [String: Any], completion: @escaping (_ result: String?) -> Void) {

		Alamofire.request(baseURL + apiLogin, method: .post, parameters: parameters, encoding: URLEncoding.default).responseObject { [unowned self] (response: DataResponse<User>) in
			guard let user = response.result.value else { return }

			if user.error == nil {
				self.userID = user.user_id!
				self.token  = user.token!
				let userData = NSKeyedArchiver.archivedData(withRootObject: user)
				UserDefaults.standard.set(userData, forKey: "user")
			}
			completion(user.error)
		}
	}


	//MARK: - Video
	func loadVideo(offset: Int, api: API, completion: @escaping (_ videosArray: [Video]) -> Void) {

		let params = ["offset": offset, "limit": 5]

		Alamofire.request(baseURL + api.rawValue, method: .get, parameters: params, encoding: URLEncoding.default).responseObject {  (response: DataResponse<Videos>) in
			guard let responseResult = response.result.value else { return }

			var tempArray = [Video]()
			if let array = responseResult.videos {
				for video in array {
					tempArray.append(video)
				}
				completion(tempArray)
			}
		}
	}


	//MARK: - Following
	func loadFollowingUsers(completion: @escaping (_ array: [Dictionary<String, [Video]>]) -> Void) {
		let apiString = "user/\(ApiManager.sharedInstance.userID!)/following"

		Alamofire.request(baseURL + apiString, method: .get, parameters: [:], encoding: URLEncoding.default).response { [unowned self] (response) in
			guard let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any] else { return }

			var tempArray = [Dictionary<String, String>]()
			if let object = json["users"] as? Array<Any>  {
				for user in object {
					if let obj = user as? [String: Any] {
						let user = [obj["username"] as! String: obj["user_id"]! as! String]
						tempArray.append(user)
					}
				}
			}

			self.followingIDs = tempArray
			self.loadUserData(completion:) { (array) in
				completion(array)
			}

		}

	}


	func loadUserData(completion: @escaping (_ array: [Dictionary<String, [Video]>]) -> Void) {
		let myGroup = DispatchGroup()

		var sourceArray = [Dictionary<String, [Video]>]()
		for user in followingIDs! {
			let apiString = "https://api.vid.me/user/\(user.values.first!)/videos"

			myGroup.enter()

			Alamofire.request(apiString, method: .get, parameters: [:], encoding: URLEncoding.default).responseObject { (response: DataResponse<Videos>) in
				guard let responseResult = response.result.value else { return }

				var tempArray = [Video]()
				if let array = responseResult.videos {
					for video in array {
						tempArray.append(video)
					}
				}

				let section = [user.keys.first!: tempArray]
				sourceArray.append(section)
				myGroup.leave()
			}
		}

		myGroup.notify(queue: .main) {
			print("Finished all requests.")
			print(sourceArray.count)
			completion(sourceArray)
		}
	}

	func isInternetAvailable() -> Bool {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)

		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}

		var flags = SCNetworkReachabilityFlags()
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
			return false
		}
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		return (isReachable && !needsConnection)
	}




}




























