

dzn_fnc_Gun_initUnit = {
	params ["_unit",["_score",0]];

	if (!local _unit) exitWith {
		_this remoteExec ["dzn_fnc_Gun_initUnit", _unit];
	};

	_unit setVariable ["Gun_Score", _score, true];
	_unit addMPEventHandler ["MPKilled", { _this call dzn_fnc_Gun_handleUnitMPKilledEH }];

	[_unit, _score, true] call dzn_fnc_Gun_promoteNewGun;
};

dzn_fnc_Gun_handleUnitMPKilledEH = {
	params ["_unit", "_killer", "_instigator", ""];

	if (_killer isEqualTo _unit) exitWith {};

	private _isPlayer = isPlayer _killer;

	private _killerScore = [
		_killer
		, if (_isPlayer) then { dzn_Gun_PlayerScorePerKill } else { dzn_Gun_AIScorePerKill }
	] call dzn_fnc_Gun_addScore;

	if (_isPlayer) then {
		[] remoteExec ["dzn_fnc_Client_handleScoreGain", _killer];
	} else {
		[_killer, _killerScore] call dzn_fnc_Gun_promoteNewGun;
	};
};

dzn_fnc_Gun_promoteNewGun = {
	params ["_unit", "_score", ["_isRespawn", false]];

	if (_score % dzn_Gun_ScorePerGun != 0 && !_isRespawn) exitWith { false };
	
	if (!local _unit) exitWith {
		_this remoteExec ["dzn_fnc_Gun_promoteNewGun", _unit];
	};

	private _idx = floor(_score / dzn_Gun_ScorePerGun);
	if (count dzn_Gun_List <= _idx) then {
		// Handle loop through gun list
		_idx = 0;
		[_unit, -1 * (_unit getVariable "Gun_Score")] call dzn_fnc_Gun_addScore;
	};
	private _gun = toLower( dzn_Gun_List # _idx );
	private _mag = (getArray(configFile >> "CfgWeapons" >> _gun >> "magazines")) # 0;

	[_unit] call dzn_fnc_Gun_clearInventory;

	_unit addMagazines [_mag, dzn_Gun_MagsPerGun];
	_unit addWeapon _gun;

	_unit selectWeapon _gun;
	[_unit] spawn {
		params["_unit"];
		_unit setAnimSpeedCoef 3;
		sleep 0.75;
		_unit setAnimSpeedCoef 1;
	};

	true
};

dzn_fnc_Gun_clearInventory = {
	params ["_unit"];

	private _mags = magazines _unit;
	{
		_unit removeMagazines _x;
	} forEach _mags;

	_unit removeWeapon (primaryWeapon _unit);
};

dzn_fnc_Gun_addScore = {
	params ["_unit", "_scoreAdd"];

	private _newScore = (_unit getVariable "Gun_Score") + _scoreAdd;
	_unit setVariable ["Gun_Score", _newScore, true];

	if (!isPlayer _unit) then {
		[_unit, _newScore] remoteExec ["dzn_fnc_ai_updateScore", _unit];
	};

	_newScore
};