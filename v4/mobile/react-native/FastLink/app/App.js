// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import 'react-native-gesture-handler'
import React from 'react'
import { SafeAreaView, StatusBar } from 'react-native'

import { NavigationContainer } from '@react-navigation/native'
import { createStackNavigator } from '@react-navigation/stack'

import LoginView from './views/LoginView'
import EventsInfoView from './views/EventsInfoView'
import FastLinkView from './views/FastLinkView'

const Stack = createStackNavigator()

const App = () => {
	return (
		<>
			<StatusBar barStyle="dark-content" />
			<SafeAreaView style={{ flex: 1, backgroundColor: '#FFFFFF' }}>
				<NavigationContainer>
					<Stack.Navigator
						initialRouteName={'Login'}
						screenOptions={{
							headerShown: true,
							headerLeft: null
						}}
					>
						<Stack.Screen name="Login" component={LoginView} />
						<Stack.Screen
							name="EventsInfo"
							component={EventsInfoView}
							options={{
								headerShown: false
							}}
						/>
						<Stack.Screen
							name="FastLink"
							component={FastLinkView}
						/>
					</Stack.Navigator>
				</NavigationContainer>
			</SafeAreaView>
		</>
	)
}

export default App
