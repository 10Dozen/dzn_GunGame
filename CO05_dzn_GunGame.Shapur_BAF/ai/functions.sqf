

dzn_fnc_ai_initMainLoop = {
	for "_i" from 1 to dzn_AI_NumberOfOpponentsMax do {
		private _id = _i - 1;
		dzn_AI_Opponents pushBack [_id, 0, objNull];
		[_id] spawn dzn_fnc_ai_spawnOpponent;
	};

	sleep 7; // Sleep for initial spawn

	while { sleep dzn_AI_MainLoopTimeout; dzn_AI_MainLoopAllowed } do {
		{
			_x params ["_id", "_score", "_unit"];

			if (!alive _unit) then {
				deleteGroup (group _unit);
				[_id] spawn dzn_fnc_ai_spawnOpponent;
			};
		} forEach dzn_AI_Opponents;
	};
};

dzn_fnc_ai_selectRandomPosition = {
	dzn_AI_OpponentSpawnPositionsTemplate params ["_mrkName","_idxMax"];

	private _pos = getMarkerPos (format [_mrkName, ceil (random _idxMax)]);

	_pos
};

dzn_fnc_ai_spawnOpponent = {
	params ["_id"];

	private _grp = createGroup east;
	private _u = _grp createUnit [dzn_AI_OpponentClass, [0,0,0], [], 0, "NONE"];

	sleep 0.1;
	_u setUnitLoadout (selectRandom dzn_AI_OpponentLoadouts);
	
	// Init opponent
	sleep 0.1;	
	[_u, _id] call dzn_fnc_ai_initOpponent;
	
	// Set up behavior settings
	_grp allowFleeing 0;
	_grp setBehaviour "AWARE";
	_grp setCombatMode "RED";
	_grp setSpeedMode "FULL";
	{ _u setSkill _x; } forEach dzn_AI_OpponentSkill;

	// Move to position
	_u setPos ([] call dzn_fnc_ai_selectRandomPosition);
	{ _u reveal [_x # 4, 4]; } forEach (_u nearTargets 20);

	// Add waypoint
	[_grp] call dzn_fnc_ai_assignWaypoints;
};

dzn_fnc_ai_initOpponent = {
	params ["_u", "_id"];
	
	_u setVariable ["OpponentID", _id, true];
	private _score = dzn_AI_Opponents # _id # 1;
	[_u, _score] call dzn_fnc_gun_initUnit;

	(dzn_AI_Opponents # _id) set [2, _u]; // Update Opponents table with Unit object
};


dzn_fnc_ai_assignWaypoints = {
	params ["_grp", ["_numberOfWP", 2]];

	for "_i" from 1 to _numberOfWP do {
		private _wp = _grp addWaypoint [[] call dzn_fnc_ai_selectRandomPosition, 5];

		_wp setWaypointType "SAD";
		_wp setWaypointCombatMode "RED";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointTimeout [5,20,40]
	};
};

dzn_fnc_ai_updateScore = {
	params ["_u", "_newScore"];

	private _id = _u getVariable "OpponentID";
	(dzn_AI_Opponents # _id) set [1, _newScore]; // Update score for unit
};