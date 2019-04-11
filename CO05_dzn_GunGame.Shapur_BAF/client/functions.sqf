

dzn_fnc_Client_onMissionStart = {
	player setPos dzn_Client_InitPosition;

	waitUntil { time > 0 };

	[] spawn dzn_fnc_Client_handleArsenalDisplay;

	waitUntil { !isNil "dzn_Client_HandleArsenal" && { dzn_Client_HandleArsenal } };
	["Open",true] call BIS_fnc_arsenal;

	waitUntil { !dzn_Client_HandleArsenal };
	0 cutText ["", "WHITE OUT", 0.1];

	// Remove unnecessary items from inventory (weapon and mags), add backpack and medkits
	removeBackpack player;
	{ player removeMagazines _x; } forEach (magazines player);
	player removeWeapon (secondaryWeapon player);
	player removeWeapon (handgunWeapon player);
	player removeWeapon (primaryWeapon player);

	player addBackpack dzn_Client_GearBackpack;
	player addItem "FirstAidKit";
	player addItem "FirstAidKit";

	dzn_Client_GearLoadout = getUnitLoadout player;

	sleep 0.25;
	[player, 0] call dzn_fnc_Gun_initUnit;
	player addEventHandler ["Respawn", { call dzn_fnc_Client_onRespawn }];

	dzn_Client_SpawnPositionsTemplate params ["_mrkName","_idxMax"];
	private _pos = getMarkerPos (format [_mrkName, ceil (random _idxMax)]);
	player setPos _pos;

	0 cutText ["", "WHITE IN", 1];
	[] spawn dzn_fnc_Client_ShowPromoteNewGunSFX;
};

dzn_fnc_Client_handleArsenalDisplay = {
	dzn_Client_HandleArsenal = true;
	
	while { uiSleep 0.1; dzn_Client_HandleArsenal } do {
		waitUntil { !isNull ( uinamespace getvariable "RSCDisplayArsenal") || !dzn_Client_HandleArsenal };
		if (!dzn_Client_HandleArsenal) exitWith {};
		
		private _display = uinamespace getvariable "RSCDisplayArsenal";
		private _ctrlTxt = _display ctrlCreate ["RscStructuredText", -1];
		
		_ctrlTxt ctrlSetStructuredText (parseText format["<t shadow='2' color='#e6c300' align='center' font='PuristaBold'> %1 </t>", dzn_Client_ArsenalText]);
		_ctrlTxt ctrlSetPosition [0,0.92,1,0.15];
		_ctrlTxt ctrlCommit 0;
		
		private _ctrlBtn = _display ctrlCreate ["RscButton", -1];
		_ctrlBtn ctrlSetText  "START";
		_ctrlBtn ctrlSetPosition [0.375,1,0.25,0.05];
		_ctrlBtn ctrlCommit 0;

		_ctrlBtn ctrlAddEventHandler ["ButtonClick", {
			(uinamespace getvariable "RSCDisplayArsenal") closeDisplay 2;
			dzn_Client_HandleArsenal = false;
		}];
		
		waitUntil { isNull ( uinamespace getvariable "RSCDisplayArsenal") };
		dzn_Client_HandleArsenal = false;
	};
};

dzn_fnc_Client_onRespawn = {
	0 cutText ["", "WHITE OUT", 0];
	player setUnitLoadout dzn_Client_GearLoadout;
	[player, player getVariable "Gun_Score", true] call dzn_fnc_Gun_promoteNewGun;
	0 cutText ["", "WHITE IN", 0.3];

	[] spawn dzn_fnc_Client_ShowPromoteNewGunSFX;
};

dzn_fnc_Client_handleScoreGain = {
	private _score = player getVariable "Gun_Score";

	private _isGunPromoted = [player, _score] call dzn_fnc_Gun_promoteNewGun;
	if (_isGunPromoted) then {
		[] call dzn_fnc_Client_ShowPromoteNewGunSFX;
	} else {
		[_score] call dzn_fnc_Client_ShowScoreGainSFX;
	}
};

dzn_fnc_Client_ShowPromoteNewGunSFX = {
	// hint "New gun promoted!";

	private _gun = primaryWeapon player;
	private _gunName = format ["<t shadow='2' color='#e6c300' align='center' font='PuristaBold' size='3'>%1</t>", getText(configFile >> "CfgWeapons" >> _gun >> "displayName")];
	private _gunIcon =  format ["<img align='center' size='9' image='%1'/>", getText(configFile >> "CfgWeapons" >> _gun >> "picture")];

	[
		parseText format ["%1<br/><br/><br/><br/><br/>%2<br/>%3"
			,"<t shadow='2'color='#e6c300' align='center' font='PuristaBold' size='1.5'>New gun promoted!</t>"
			, _gunIcon
			, _gunName
		]
		, [0,.2,1,1], nil, 3, 0.2, 0
	] spawn BIS_fnc_textTiles;
};

dzn_fnc_Client_ShowScoreGainSFX = {
	params ["_score"];

	[
		parseText "<t shadow='2'color='#e6c300' align='center' font='PuristaBold' size='1.5'>+1 XP!</t>"
		, [0,.33,1,1], nil, 1.25, 0.2, 0
	] spawn BIS_fnc_textTiles;

	private _scoreToNext = (1 + floor (_score / dzn_Gun_ScorePerGun)) * dzn_Gun_ScorePerGun - _score;
	hint format ["%1 XP more for the next promotion!", _scoreToNext]
};