local module = {
	mainMenuData = {
		isEmpty = true,
		saveName = "",
		gameplayTime = 0
	},
	gameSettings = {
		musicVolume = 1,
		menuSoundsVolume = 1,
	},
	achievements = {
		completedTutorial = false
	},
	isDead = true,
	location = "",

	--Character Creator stuff
	characterCreatorSettings = {
		character = "",
		saveCharacterToNextLife = false
	}
	
}

return module
