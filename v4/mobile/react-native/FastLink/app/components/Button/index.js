import React, { Component } from 'react'
import { StyleSheet, Text, TouchableOpacity, ViewPropTypes } from 'react-native'
import PropTypes from 'prop-types'

export default class Button extends Component {
	constructor(props) {
		super(props)
	}

	static propTypes = {
		buttonStyle: ViewPropTypes.style,
		buttonTextStyle: Text.propTypes.style,
		label: PropTypes.string.isRequired,
		onPress: PropTypes.func
	}

	static defaultProps = {
		label: ''
	}

	render() {
		const { onPress, label, buttonStyle, buttonTextStyle } = this.props

		return (
			<TouchableOpacity
				style={[Styles.button, buttonStyle]}
				onPress={onPress}
			>
				<Text style={[Styles.text, buttonTextStyle]}>{label}</Text>
			</TouchableOpacity>
		)
	}
}

const Styles = StyleSheet.create({
	button: {
		height: 40,
		alignItems: 'center',
		justifyContent: 'center',
		borderRadius: 3,
		paddingHorizontal: 20,
		elevation: 2,
		shadowColor: 'rgb(48,48,48)',
		shadowOffset: {
			width: 3,
			height: 3
		},
		shadowRadius: 3,
		shadowOpacity: 0.1,
		backgroundColor: '#267CB2'
	},

	text: {
		fontSize: 14,
		color: '#FFFFFF',
		fontWeight: 'bold'
	}
})
