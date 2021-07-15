// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import React, { useState } from 'react'
import { View, Text, TextInput, StyleSheet, Image } from 'react-native'
import Button from './../components/Button'
import Config from './../Config'

const LoginView = props => {
	const navigation = props.navigation

	const [_fastlinkURL, setFastlinkURL] = useState(Config.fastLinkURL)
	const [_fastlinkURLError, setFastlinkURLError] = useState(false)

	//Generate the AccessToken from client credentials
	const [_accessToken, setAccessToken] = useState('')
	const [_accessTokenError, setAccessTokenError] = useState(false)

	const [_extraParams, setExtraParams] = useState(
		'configName=Aggregation&intentUrl=yodlee://backtofastlink'
	)
	const [_extraParamsError, setExtraParamsError] = useState(false)

	const handleNextBtnPress = async value => {
		if (!_fastlinkURL) {
			setFastlinkURLError(true)
			return
		} else {
			setFastlinkURLError(false)
		}

		if (!_accessToken) {
			setAccessTokenError(true)
			return
		} else {
			setAccessTokenError(false)
		}

		navigation.navigate('FastLink', {
			fastlinkURL: _fastlinkURL,
			accessToken: _accessToken,
			extraParams: _extraParams
		})
	}

	return (
		<>
			<View style={Styles.container}>
				<View style={Styles.logoContainer}>
					<Image
						style={Styles.logoStyle}
						source={require('./../assets/yodlee.png')}
						resizeMode={'contain'}
					/>
				</View>

				<View style={Styles.inputContainer}>
					<View style={Styles.inputWrap}>
						<TextInput
							style={Styles.inputStyle}
							autoCapitalize="none"
							autoCorrect={false}
							value={_fastlinkURL}
							placeholder="FastLink URL"
							onChangeText={value => setFastlinkURL(value)}
						/>
					</View>
				</View>
				{_fastlinkURLError ? (
					<Text style={Styles.errorMessage}>
						This feild is Required
					</Text>
				) : null}

				<View style={Styles.inputContainer}>
					<View style={Styles.inputWrap}>
						<TextInput
							style={Styles.inputStyle}
							autoCapitalize="none"
							autoCorrect={false}
							value={_accessToken}
							placeholder="Access Token"
							onChangeText={value => setAccessToken(value)}
						/>
					</View>
				</View>
				{_accessTokenError ? (
					<Text style={Styles.errorMessage}>
						This feild is Required
					</Text>
				) : null}

				<View style={Styles.inputContainer}>
					<View style={Styles.inputWrap}>
						<TextInput
							style={Styles.inputStyle}
							autoCapitalize="none"
							ref={el => (this.element = el)}
							autoCorrect={false}
							value={_extraParams}
							placeholder="Extra Params"
							onChangeText={value => setExtraParams(value)}
						/>
					</View>
				</View>

				<View style={{ marginTop: 24 }}>
					<Button label="Sign In" onPress={handleNextBtnPress} />
				</View>
			</View>
		</>
	)
}

const Styles = StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: '#FFFFFF',
		padding: 16
	},

	logoStyle: {
		width: 200,
		height: 150,
		resizeMode: 'contain'
	},

	logoContainer: {
		minHeight: 180,
		alignItems: 'center'
	},

	inputContainer: {
		marginTop: 24,
		flexDirection: 'column',
		minHeight: 40
	},

	inputWrap: {
		borderBottomColor: '#e0dddc',
		borderBottomWidth: 1,
		flex: 1
	},

	inputStyle: {
		flex: 1,
		height: 40,
		marginLeft: 4,
		borderRadius: 0
	},

	errorMessage: {
		color: 'red',
		marginTop: 8
	}
})

export default LoginView
