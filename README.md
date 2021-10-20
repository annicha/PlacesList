### Todo
- [x] try out foursquareAPI on Postman
- [x] setup venue json object
- [x] implement fetching data
- [x] implement icon image caching
- [x] make a draft of view constraints
- [x] create storyboard
- [x] populate results
- [x] add a navigation bar please!!
- [x] fetch next results
- [x] add something to launchscreen
- [x] add a loading alert when app is fetching current location
- [x] make app icon
- [x] clean up
- [x] All done 🎉🎉


### Initial planning
**Reading Foursquare API**
- [correctly query offset](https://stackoverflow.com/questions/8526798/foursquare-venue-api-number-of-results-in-a-more-efficient-way)
- [parameters](https://developer.foursquare.com/docs/api-reference/venues/explore/#parameters)
- [getting photo file](https://developer.foursquare.com/docs/api-reference/venues/photos/)

**Testing with Postman's Foursquare collection**
<table>
<tr>
	<td>
		<img src="topshot.png" alt="Top Dictionary" width="250px"><br>
		json object = swift dictionary `[String:Any]`
	</td>
	<td>
		<img src="itemsshot.png" alt="Items Dictionary" width="250px"><br>
		Array of json object = swift array of dictionary `[[String:Any]`
	</td>
	<td>
		<img src="venueshot.png" alt="Venue Dictionary" width="250px"><br>
		Venue is a json object, we need 2 type of things from venue
		1. properties from location object
		2. properties in icon, which is inside categories of type `[[String:Any]]` we only want to get the one with primary value = true
	</td>
<tr>
</table>

**Drafts**
<table>
<tr>
	<td>
		<img src="draft.jpeg" alt="draft" width="350px">
	</td>
	<td>
		<img src="draft2.jpeg" alt="draft2" width="350px">
	</td>
<tr>
</table>

**Other main resources**
- [getting current location]( https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/using_the_significant-change_location_service)
- [about fetching nested json](https://developer.apple.com/swift/blog/?id=37)
- [activity view](https://www.hackingwithswift.com/example-code/uikit/how-to-use-uiactivityindicatorview-to-show-a-spinner-when-work-is-happening)


### Screenshots
<table>
<tr>
	<td>
		<img src="screenshot-light.png" alt="Screenshot-light" width="200px">
	</td>
	<td>
		<img src="screenshot-dark.png" alt="Screenshot-dark" width="200px">
	</td>
</tr>
</table>

[![Typing SVG](https://my-typing-svg-denvercoder1.herokuapp.com?color=%23A5DEF7&multiline=true&lines=Thank+you+for+reading+%F0%9F%99%8F)](https://git.io/typing-svg)
[![Typing SVG](https://my-typing-svg-denvercoder1.herokuapp.com?color=%237BC0F7&multiline=true&lines=Have+a+nice+day!+)](https://git.io/typing-svg)


![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white) ![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
