youtubedl-watchos is a standalone WatchOS youtube player utilizing a youtube-dl python server for intermediate requests. It's based off of Ziph0n's original Wristplayer, but aims to achieve the following:

1. Porting from a classic iOS+WatchOS app communicating via AppDelegate in favor for standalone WatchOS app communicating to a youtube-dl service to allow untethered use of the application, especially for LTE watch users that want to leave their phones at home.

2. Refactoring to reduce library dependencies due to libraries not being updated/abandoned and long deploy times.
This means replacing:
- Alamofire with Foundation
- XCDYoutubeKit by leveraging a service

3. Force people to provide their own Youtube API token. The previous Wristplayer used the same API key, which frequently lead to max query requests.

# Installation

1. Create your own Youtube API key
2. Deploy your own [youtube-dl python server](https://github.com/akissu/youtubedl-watchos-server)
3. Use details from steps 1 and 2 to fill out the stubs in `Settings.swift`.
4. Install the pods in the youtubedl-watchos folder
5. Replace all of the signing and team identifiers in XCode
6. Build and deploy WatchOS app
7. Exhale 😮‍💨
