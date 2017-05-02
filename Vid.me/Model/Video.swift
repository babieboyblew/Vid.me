//
//  Video.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 5/1/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import ObjectMapper


class Videos: Mappable {
	var videos: [Video]?

	func mapping(map: Map) {
		videos <- map["videos"]
	}

	required init?(map: Map) { }


}

class Video: Mappable {

	var title: String?
	var pictureURLString: String?
	var likes: Int?
	var videoURLString: String?

	func mapping(map: Map) {
		title			  <- map["title"]
		pictureURLString  <- map["thumbnail_url"]
		likes			  <- map["likes_count"]
		videoURLString    <- map["complete_url"]

	}


	required init?(map: Map) { }



	
}



//{
//	page =     {
//		currentMarker = "<null>";
//		currentMarkerDate = "<null>";
//		currentMarkerDay = "<null>";
//		limit = 1;
//		nextMarker = "2017-04-30";
//		offset = 0;
//		total = 5421;
//	};
//	status = 1;
//	videos =     (
//		{
//			channel =             {
//				"avatar_url" = "<null>";
//				"channel_id" = 294;
//				"cover_url" = "https://d1wst0behutosd.cloudfront.net/channel_covers/294.jpg?v1r1491947489";
//				"date_created" = "2017-04-11 19:18:24";
//				description = "Videos about Vidme and the Vidme community...so meta.";
//				"follower_count" = 0;
//				"full_url" = "https://vid.me/c/vidme";
//				"hide_suggest" = 0;
//				"is_default" = 0;
//				nsfw = 0;
//				"show_unmoderated" = 0;
//				title = Vidme;
//				url = vidme;
//				"video_count" = 525;
//			};
//			"channel_id" = 294;
//			colors = "";
//			"comment_count" = 99;
//			complete = "s3://v.vidd.me/videos/15164781/49593627.mp4";
//			"complete_url" = "https://d1wst0behutosd.cloudfront.net/videos/15164781/49593627.mp4?Expires=1493646399&Signature=Aq0BGXkFFlei95WWy2-sMShXMePCvyYpuyn~rlTITtlXrZVyTJTP8BYh1F4DJ4yOwnTAfMWrACVoWRPErHlVOmXrnrIhWbaaxOSM7VeBHBV9S1z1SRnA5kYH4Fszph28TumsCyLW5xhAYSiXP-5AMsOONPO-BMnBYcJQ9PbeEdccZFmdfNPg7SdFlRR9odcMMneR6xLfoa-j~yuEuh-F~~o4U~DE9FYb3tT4dM3d~zpfavijMmHh2UakcfuzDpKtCQRhI9zYOdvYc2UcNKoi~JUg5YYQjKaB1J7b3de7V2FRIpaGj5jYST6~vMfUpMgq7lMRl8nA0wLZfyuZ7WS49Q__&Key-Pair-Id=APKAJJ6WELAPEP47UKWQ";
//			"date_completed" = "2017-04-29 17:31:58";
//			"date_created" = "2017-04-29 17:27:50";
//			"date_featured" = "2017-04-29 17:40:27";
//			"date_published" = "2017-04-29 17:36:14";
//			"date_stored" = "2017-04-29 17:30:12";
//			description = "How to join the Vidme IOS Beta:
//			\n
//			\n1. Go to: vidme-beta.herokuapp.com and sign up.
//			\n2. Be sure to use the password: VidmeApp#1
//			\n3. Download the \U201cTestflight\U201d app from the App Store.
//			\n4. Once the Vidme Beta is released, you\U2019ll receive an email with a redemption code.
//			\n5. Open the TestFlight app and enter the redemption code, and you\U2019ll be able to download the Vidme Beta.
//			\n6. Play with the Beta! Try to break @mcstacky\U2019s app!
//			\n7. Be sure to submit feedback for a chance to win a Vidme Shirt.
//			\n
//			\nThanks for participating
//				\n
//				\nNo one was hurt during the shooting";
//			duration = "174.19";
//			"embed_url" = "https://vid.me/e/ktQc";
//			formats =             (
//			{
//			height = "<null>";
//			type = hls;
//			uri = "https://api.vid.me/video/15164781/stream?format=hls";
//			version = 12;
//			width = "<null>";
//			}
//			);
//			"full_url" = "https://vid.me/ktQc";
//			height = 1080;
//			"is_featured" = 1;
//			latitude = 0;
//			"likes_count" = 236;
//			longitude = 0;
//			nsfw = 0;
//			"place_id" = "<null>";
//			"place_name" = "<null>";
//			private = 0;
//			"reddit_link" = "<null>";
//			scheduled = 0;
//			score = 236;
//			"share_count" = 37;
//			source = computer;
//			state = success;
//			storyboard = "https://d1wst0behutosd.cloudfront.net/videos/15164781/storyboards/{02}.jpg?v1r1493487143";
//			"subscribed_only" = 0;
//			thumbnail = "thumbnails/15164781.jpg?v1r1493489927";
//			"thumbnail_gif" = "<null>";
//			"thumbnail_gif_url" = "<null>";
//			"thumbnail_url" = "https://d1wst0behutosd.cloudfront.net/thumbnails/15164781.jpg?v1r1493489927";
//			title = "This Week at Vidme: Shooter on the Loose!";
//			url = ktQc;
//			user =             {
//				avatar = "avatars/36550.gif?gv2r1486098865";
//				"avatar_url" = "https://d1wst0behutosd.cloudfront.net/avatars/36550.gif?gv2r1486098865";
//				bio = "Our mission: build the world's most creator-friendly video community.";
//				"comments_scores" = 38;
//				cover = "channel_covers/36550.jpg?v1r1489541086";
//				"cover_url" = "https://d1wst0behutosd.cloudfront.net/channel_covers/36550.jpg?v1r1489541086";
//				displayname = "";
//				"follower_count" = 3081;
//				"full_url" = "https://vid.me/Vidme";
//				"is_followed_by" = 0;
//				"is_following" = 0;
//				"is_subscribed" = 0;
//				"is_subscribed_by" = 0;
//				"likes_count" = 190;
//				"receive_notifications_followed" = 0;
//				"receive_notifications_following" = 0;
//				"user_id" = 36550;
//				username = Vidme;
//				"video_count" = 31;
//				"video_views" = 2288169;
//				"videos_scores" = 8476;
//				vip = 1;
//			};
//			"user_id" = 36550;
//			version = 12;
//			"video_id" = 15164781;
//			"view_count" = 5251;
//			"watching_count" = 5;
//			width = 1920;
//			"youtube_override_source" = "<null>";
//		}
//	);
//	viewerVotes =     (
//	);
//	watching =     {
//		15164781 = 5;
//	};
//}
