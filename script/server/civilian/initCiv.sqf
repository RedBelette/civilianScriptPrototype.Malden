_position = getPos (_this select 0);

_civCompositions = [
	["LOP_CHR_Civ_Policeman_01", "LOP_CHR_Civ_Policeman_01"],
	["LOP_CHR_Civ_Functionary_01"],
	["LOP_CHR_Civ_Random", "LOP_CHR_Civ_Random"],
	["LOP_CHR_Civ_Random", "LOP_CHR_Civ_Random", "LOP_CHR_Civ_Random"],
	["LOP_CHR_Civ_Doctor_01"],
	["LOP_CHR_Civ_Priest_01"],
	["LOP_CHR_Civ_Rocker_03", "LOP_CHR_Civ_Rocker_04", "LOP_CHR_Civ_Rocker_02"],
	["LOP_CHR_Civ_Random"],
	["LOP_CHR_Civ_Random", "LOP_CHR_Civ_Villager_04"]
];

_civActions = [
	["ROUND", getMarkerPos "police"],
	["ROUND", getMarkerPos "agriculturalAdministrationOffice"],
	["ROUND", getMarkerPos "superMarker"],
	["ROUND", getMarkerPos "superMarker"],
	["ROUND", getMarkerPos "clinic"],
	["TALKING_AFTER_MOVE", getMarkerPos "church", 180],
	["ROUND", getMarkerPos "superMarker"],
	["ROUND", getMarkerPos "cimetery"],
	["ROUND", getMarkerPos "agriculturalAdministrationOffice"]
];

_i = [0, (count _civCompositions) - 1] call BIS_fnc_randomInt;
_civComposition = _civCompositions select _i;

_groupCiv = [civilian, _civComposition, _position] call RF_fnc_spawnUnits;

// weapons holster
{
	_x action ["SWITCHWEAPON",_x,_x,-1];
	_x setSpeaker "NoVoice";
} forEach units _groupCiv;

_civAction = (_civActions select _i);
diag_log ["civActionType", _civAction];
switch (_civAction select 0) do
{
	case "ROUND":
	{
		_startWaypoint = [_groupCiv, getPos leader _groupCiv, 0, "MOVE", "SAFE", "GREEN", "LIMITED", "LINE"] call CBA_fnc_addWaypoint;
		[_groupCiv, _civAction select 1, 0, "MOVE", "SAFE", "GREEN", "LIMITED", "LINE"] call CBA_fnc_addWaypoint;
		_repeatWaypoint = [_groupCiv, getPos leader _groupCiv, 0, "MOVE", "SAFE", "GREEN", "LIMITED", "LINE"] call CBA_fnc_addWaypoint;
		_repeatWaypoint setWaypointType "Cycle";
	};

	case "TALKING_AFTER_MOVE":
	{
		_talkings = ["Acts_CivilTalking_1", "Acts_CivilTalking_2"];
		[_groupCiv, _civAction select 1, 3, "MOVE", "SAFE", "GREEN", "LIMITED", "LINE", format ["[this] call CBA_fnc_waypointGarrison; this setDir %1; [this, '%2'] call RF_fnc_playMoveLoop;", _civAction select 2, _talkings select ([0, 1] call BIS_fnc_randomInt)]] call CBA_fnc_addWaypoint;
	};

	default
	{
		diag_log["NOTOK", _i];
	};
};

diag_log ["test", getMarkerPos "area1"];