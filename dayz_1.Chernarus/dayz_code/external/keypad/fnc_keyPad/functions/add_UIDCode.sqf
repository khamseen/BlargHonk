private ["_flagCount","_isOk","_allFlags","_panel","_convertInput","_authorizedUID","_authorizedOUID","_authorizedPUID"];
	_isOk = true;
	//[_panel, _convertInput] call add_UIDCode;		
	addUIDCode = false;
	_panel 			= _this select 0;
	_convertInput 	= _this select 1;
	_authorizedUID = _panel getVariable ["AuthorizedUID", []];
	_authorizedPUID = _authorizedUID select 1;
	for "_i" from 0 to (count _convertInput - 1) do {_convertInput set [_i, (_convertInput select _i) + 48]};
	if ((toString _convertInput) in _authorizedPUID) exitWith 
	{
		CODEINPUT = [];
		hintsilent parseText format ["
		<t align='center' color='#FF0000'>ERROR</t><br/><br/>
		<t align='center'>Player UID %1 already has access to object</t><br/>
		<t align='center'>%2</t><br/><br/>
		<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
		",(toString _convertInput), typeOf(_panel), str(keyCode)];
		sleep 5;
		hint "";
		if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",bbCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	};
private ["_authorizedUID","_authorizedOUID","_authorizedPUID"]; //Reset here to prevent copying other object IDs
	_flagCount = 0;
	_allFlags = nearestObjects [player, ["FlagCarrierBIS_EP1"], 25000];
	{
		if (typeOf(_x) == "FlagCarrierBIS_EP1") then {
			_authorizedUID = _x getVariable ["AuthorizedUID", []];
			_authorizedOUID = _authorizedUID select 0;
			_authorizedPUID = _authorizedUID select 1;
			if ((toString _convertInput) in _authorizedPUID && (typeOf(_x) == "FlagCarrierBIS_EP1")) then {
				_flagCount = _flagCount + 1;
			};
		};
	} foreach _allFlags;
	if (_flagCount >= MaxPlayerFlags) exitWith {
		hintsilent parseText format ["
		<t align='center' color='#FF0000'>ERROR</t><br/><br/>
		<t align='center'>Player UID %1 already used on %2 flags!</t><br/>
		",(toString _convertInput),MaxPlayerFlags];
		sleep 5;
		if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",bbCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	};
	_authorizedUID = _panel getVariable ["AuthorizedUID", []]; //Get's whole array stored for object
	_authorizedOUID = _authorizedUID select 0; //Sets objectUID as first element
	_authorizedPUID = _authorizedUID select 1; //Sets playerUID as second element
	_authorizedPUID set [count _authorizedPUID, (toString _convertInput)]; //Updates playerUID element with new code
	_updatedAuthorizedUID = ([_authorizedOUID] + [_authorizedPUID]); //Recombines the arrays
	_panel setVariable ["AuthorizedUID", _updatedAuthorizedUID, true]; //Writes the updates array to the variable for passing to server_updateObject
	// Update to database
	PVDZ_veh_Save = [_panel,"gear"];
	publicVariableServer "PVDZ_veh_Save";
	if (isServer) then {
		PVDZ_veh_Save call server_updateObject;
	};
	hintsilent parseText format ["
	<t align='center' color='#00FF3C'>SUCCESS</t><br/><br/>
	<t align='center'>Player UID %1 access granted to object</t>
	<t align='center'>%2</t><br/><br/><br/>
	<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
	",(toString _convertInput), typeOf(_panel), str(keyCode)];
	sleep 10;
	hint "";
	if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",bbCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	CODEINPUT = [];
