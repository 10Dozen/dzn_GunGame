#include "gunlists.sqf";

/*
	Gun system 
	Common (server + client)
*/ 

dzn_Gun_List = [] + dzn_GunList_A3_SMG + dzn_GunList_A3_Carbine + dzn_GunList_A3_Assault;
dzn_Gun_ScorePerGun = 2;

dzn_Gun_AIScorePerKill = 2;
dzn_Gun_PlayerScorePerKill = 1;

dzn_Gun_MagsPerGun = 9;

// Functions 
call compile preprocessFileLineNumbers "gunSystem\functions.sqf";
