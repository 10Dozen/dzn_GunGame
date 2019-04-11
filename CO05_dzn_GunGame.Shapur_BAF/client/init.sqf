/*
	Client side stuff 
		- handlers 
		- sfx 
*/

// Settings
dzn_Client_InitPosition = getMarkerPos "mrk_initPlayers";
dzn_Client_ArsenalText = "Select outfit and press ""START"" to join the game!<br/>Guns and grenades are NOT allowed!";

dzn_Client_SpawnPositionsTemplate = ["marker_%1", 20];
dzn_Client_GearBackpack = "B_AssaultPack_khk";

dzn_Client_GearLoadout = [];

// Functions 
call compile preprocessFileLineNumbers "client\functions.sqf";

// Init
[] spawn dzn_fnc_Client_onMissionStart;