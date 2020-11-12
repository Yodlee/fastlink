import React from 'react'
import { View, Linking } from 'react-native'
import { WebView } from 'react-native-webview'

//This class shows how you can load FastLink in the WebView
//Note that you need to use the community supported WebView, the base webview which was part of react-native has been deprecated.

const FastLinkContainerView = ({ route, navigation }) => {
	//Read the data passed from Login View to this view
	const { fastlinkURL, accessToken, extraParams } = route.params

	let messageData = []

	//Create the PostData which will be passed to the WebView
	let postData =
		'accessToken=Bearer ' +
		accessToken +
		'&extraParams=' +
		encodeURIComponent(extraParams)

	//WebView post message handler
	let handleMessage = data => {
		if (data) {
			let parsedMessageData = JSON.parse(data)
			messageData.push(parsedMessageData)

			//Account Addition status will be passed to native through the POST_MESSAGE event
			//If the 'action' is 'exit', in that case user have clicked on the close/finish button in the FastLink,
			//You can close the FastLink WebView and navigate to the other views in your Application
			if (parsedMessageData.type == 'POST_MESSAGE') {
				let data = parsedMessageData.data

				if (data.action == 'exit') {
					navigation.navigate('EventsInfo', {
						messageData: messageData
					})
				}
			}

			//When user clicks on any External Link 'OPEN_EXTERNAL_URL' event will be triggered.
			if (parsedMessageData.type == 'OPEN_EXTERNAL_URL') {
				let url = parsedMessageData.data.url

				//In this Sample App we are using the Linking module to open the URL in the default browser
				Linking.canOpenURL(url).then(supported => {
					if (supported) {
						Linking.openURL(url)
					} else {
						Alert.alert('Alert', 'Opening url not supported')
					}
				})
			}
		}
	}

	return (
		<View style={{ flex: 1 }}>
			<WebView
				source={{
					uri: fastlinkURL,
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded'
					},
					body: postData,
					method: 'POST'
				}}
				javaScriptEnabled={true}
				style={{ flex: 1 }}
				onMessage={event => {
					//onMessage property needs to be set of you want to recieve the Events from FastLink application
					handleMessage(event.nativeEvent.data)
				}}
			/>
		</View>
	)
}

export default FastLinkContainerView
