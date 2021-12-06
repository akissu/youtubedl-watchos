youtube-watchos is a standalone WatchOS youtube player utilizing [Download API](https://github.com/llsc12/download-api) for search data and video streaming. The app is based off of [Ziph0n's original Wristplayer](https://github.com/Ziph0n/WristPlayer) and is a fork of [akissu's youtubedl-watchos](https://github.com/akissu/youtubedl-watchos), it aims to achieve the following:

1. Fully standalone usage of the app relying on Download API to not use the official YouTube API and prevent ratelimits

2. Not require people to provide a YouTube API Key for usage.

# Installation

1. OPTIONAL: Setup your own [Download API](https://github.com/llsc12/download-api) instance
2. Use your instance's address from step 1 to fill in `Settings.swift` or use llsc12.ml as default.
3. Replace all of the signing and team identifiers in XCode
4. Build and deploy WatchOS app
5. Exhale 😮‍💨
