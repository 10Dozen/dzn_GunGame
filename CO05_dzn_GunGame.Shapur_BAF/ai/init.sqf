
call compile preprocessFileLineNumbers "ai\functions.sqf";


/*
	AI Component
	Server side 

*/

// Settings and constants
dzn_AI_NumberOfOpponentsMax = 10;
dzn_AI_Opponents = [];

dzn_AI_OpponentClass = "O_Soldier_F";
dzn_AI_OpponentLoadouts = [
	[[],[],[],["U_B_HeliPilotCoveralls",[["FirstAidKit",2]]],["V_PlateCarrier1_rgr_noflag_F",[]],["B_AssaultPack_khk",[]],"H_PASGT_basic_olive_F","G_Balaclava_blk",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]]
];


dzn_AI_OpponentSkill = [
	["general"			, 1]
	,["aimingShake"		, 0.5]
	,["aimingSpeed"		, 0.75]
	,["endurance"		, 1]
	,["spotDistance"	, 1]
	,["spotTime"		, 1]
	,["courage"			, 1]
	,["reloadSpeed"		, 0.5]
	,["commanding"		, 1]
];

dzn_AI_OpponentSpawnPositionsTemplate = ["marker_%1", 20];

dzn_AI_MainLoopAllowed = true;
dzn_AI_MainLoopTimeout = 5;

// Init
[] spawn dzn_fnc_ai_initMainLoop;