//
//  User.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 4/30/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import ObjectMapper

class User: NSObject, Mappable, NSCoding {

	var username: String?
	var	user_id: String?

	var token: String?
	var error: String?


	func mapping(map: Map) {
		username <- map["user.username"]
		user_id  <- map["user.user_id"]
		token <- map["auth.token"]
		error <- map["code"]
	}


	required init?(map: Map) { }

	init(_ username: String,_  user_id: String,_ token: String,_ error: String?) {
		self.username = username
		self.user_id = user_id
		self.token = token
		self.error = error
	}

	required convenience init(coder aDecoder: NSCoder) {
		let username = aDecoder.decodeObject(forKey: "username")  as! String
		let user_id = aDecoder.decodeObject(forKey: "user_id") as! String
		let token = aDecoder.decodeObject(forKey: "token") as! String
		let error = aDecoder.decodeObject(forKey: "error") as? String
		self.init(username, user_id, token, error)
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(username, forKey: "username")
		aCoder.encode(user_id, forKey: "user_id")
		aCoder.encode(token, forKey: "token")
		aCoder.encode(error, forKey: "error")
	}

}



//	avatar = "<null>";
//	"avatar_url" = "https://cdn.vid.me/images/default-avatars/5.png?602-2-12-4-5";
//	bio = "<null>";
//	"comments_scores" = 0;
//	cover = "<null>";
//	"cover_url" = "https://cdn.vid.me/images/default-covers/05.jpg?602-2-12-4-5";
//	displayname = "<null>";
//	email = "shuttleswort@yandex.ua";
//	"follower_count" = 0;
//	"full_url" = "https://vid.me/Shuttleswort";
//	"likes_count" = 0;
//
//	"video_count" = 0;
//	"video_views" = 0;
//	"videos_scores" = 0;







