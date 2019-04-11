enableSaving [false,false];

if (!isServer) then { // Gun System init (prevent double execution for host user)
	call compile preprocessFileLineNumbers "gunSystem\init.sqf";
};

call compile preprocessFileLineNumbers "client\init.sqf";







/*
	TODO:

	- Fix respawn positions 
	- Add sound on promote
	- Close game area with walls 
	- Add mission parameters:
		[] AI Amount 
		[] AI Skill 
		[] Points per gun 
*/