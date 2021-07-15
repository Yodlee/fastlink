// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import React from 'react'
import { View, StyleSheet, Text, ScrollView, Button } from 'react-native'

//This class prints all the events which are sent from FastLink
const EventsInfoView = ({ route, navigation }) => {
	const { messageData } = route.params || {}

	let handleLogoutPress = () => {
		navigation.navigate('Login')
	}

	return (
		<View style={Styles.container}>
			<View
				style={{
					height: 48,
					backgroundColor: '#FFFFFF',
					flexDirection: 'row'
				}}
			>
				<View style={{ flex: 1 }} />
				<View style={{ flex: 2 }}>
					<Text
						style={{
							fontSize: 16,
							textAlign: 'center',
							marginTop: 12,
							fontWeight: 'bold'
						}}
					>
						Events Info
					</Text>
				</View>
				<View style={{ flex: 1 }}>
					<Button title="Logout" onPress={handleLogoutPress} />
				</View>
			</View>
			<ScrollView contentContainerStyle={{ flexGrow: 1, padding: 16 }}>
				<View
					style={{
						borderTopColor: '#ececec',
						borderTopWidth: 1,
						marginTop: 16
					}}
				>
					<Text style={{ marginBottom: 12 }}>
						Following is the Native communication events Info:
					</Text>
					<Text>{JSON.stringify(messageData, undefined, 4)}</Text>
				</View>
			</ScrollView>
		</View>
	)
}

const Styles = StyleSheet.create({
	container: {
		flex: 1
	}
})

export default EventsInfoView
