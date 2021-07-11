class X2EventListener_Officer extends X2EventListener config(RankChanges);

var config array<name> OfficerUnitValues;
var config array<name> OfficerCharacterTemplates;
var config array<name> OfficerSoldierClasses;
var config array<name> OfficerAbilities;
var config array<name> SkipOfficerSoldierClasses;

var localized string strCommandingOfficer;

`include(WOTCIridarOfficersRanks/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SoldierRankListener());
	Templates.AddItem(SquadSelectListener());

	return Templates;
}

static function CHEventListenerTemplate SquadSelectListener()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_X2EventListener_WOTCIridarOfficersRanks_SquadSelect');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	if (`GETMCMVAR(MARK_OFFICER_IN_SQUAD_SELECT))
	{
		Template.AddCHEvent('rjSquadSelect_ExtraInfo', OnrjSquadSelect_ExtraInfo, ELD_Immediate, 50);	// Triggered in RJSS
	}
	return Template;
}

static function EventListenerReturn OnrjSquadSelect_ExtraInfo(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
	local LWTuple	Tuple;
	local LWTuple	NoteTuple;
	local LWTValue	Value;
	local int		SlotIndex;

	Tuple = LWTuple(EventData);
	
	// Check that we are interested in actually doing something
	if (!`GETMCMVAR(MARK_OFFICER_IN_SQUAD_SELECT) || Tuple == none || Tuple.Id != 'rjSquadSelect_ExtraInfo') return ELR_NoInterrupt;

	SlotIndex = Tuple.Data[0].i;

	if (SlotIndex == FindCommandingOfficerSquadSlotIndex())
	{
		Value.kind = LWTVObject;

		NoteTuple = new class'LWTuple';
		NoteTuple.Data.Length = 3;

		NoteTuple.Data[0].kind = LWTVString;
		NoteTuple.Data[0].s = default.strCommandingOfficer;
        
		NoteTuple.Data[1].kind = LWTVString;
		NoteTuple.Data[1].s = class'UIUtilities_Colors'.const.HILITE_TEXT_HTML_COLOR; // Text color
        
		NoteTuple.Data[2].kind = LWTVString;
		NoteTuple.Data[2].s = "FFD700"; // Background color - gold

		Value.o = NoteTuple;
		Tuple.Data.AddItem(Value);
    }

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate SoldierRankListener()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_X2EventListener_WOTCIridarOfficersRanks');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = true;

	// Priority above average so this triggers earlier than other listeners, so others can override these changes.
	Template.AddCHEvent('SoldierRankName', OnSoldierRankName, ELD_Immediate, 60); 
	Template.AddCHEvent('SoldierShortRankName', OnSoldierShortRankName, ELD_Immediate, 60);
	Template.AddCHEvent('SoldierRankIcon', OnSoldierRankIcon, ELD_Immediate, 60);

	return Template;
}

static function EventListenerReturn OnSoldierRankName(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
	local XComGameState_ResistanceFaction FactionState;
	local X2SoldierClassTemplate ClassTemplate;
    local XComGameState_Unit UnitState;
    local XComLWTuple Tuple;
    local int Rank;
    local string DisplayRankName;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none || ClassTemplate.RankNames.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    DisplayRankName = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (IsUnitOfficer(UnitState))
	{
		DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(`GETMCMVAR(OFFICER_RANK_NAME_SET), Rank);
	}
	else 
	{
		FactionState = UnitState.GetResistanceFaction();
		if (FactionState != none)
		{
			switch (FactionState.GetMyTemplateName())
			{
			case 'Faction_Reapers':
				DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(`GETMCMVAR(REAPER_RANK_NAME_SET), Rank);
				break;
			case 'Faction_Skirmishers':
				DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(`GETMCMVAR(SKIRMISHER_RANK_NAME_SET), Rank);
				break;
			case 'Faction_Templars':
				DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(`GETMCMVAR(TEMPLAR_RANK_NAME_SET), Rank);
				break;
			default:
				break;
			}
		}
		else
		{
			DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(`GETMCMVAR(SOLDIER_RANK_NAME_SET), Rank);
		}
	}

	if (DisplayRankName != "")
	{
		Tuple.Data[1].s = DisplayRankName;
	}
    return ELR_NoInterrupt;
}

static function EventListenerReturn OnSoldierShortRankName(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
	local XComGameState_ResistanceFaction FactionState;
	local X2SoldierClassTemplate ClassTemplate;
    local XComGameState_Unit UnitState;
    local XComLWTuple Tuple;
    local int Rank;
    local string DisplayShortRankName;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none || ClassTemplate.ShortNames.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    DisplayShortRankName = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (IsUnitOfficer(UnitState))
	{
		DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(`GETMCMVAR(OFFICER_RANK_NAME_SET), Rank);
	}
	else
	{
		FactionState = UnitState.GetResistanceFaction();
		if (FactionState != none)
		{
			switch (FactionState.GetMyTemplateName())
			{
			case 'Faction_Reapers':
				DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(`GETMCMVAR(REAPER_RANK_NAME_SET), Rank);
				break;
			case 'Faction_Skirmishers':
				DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(`GETMCMVAR(SKIRMISHER_RANK_NAME_SET), Rank);
				break;
			case 'Faction_Templars':
				DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(`GETMCMVAR(TEMPLAR_RANK_NAME_SET), Rank);
				break;
			default:
				break;
			}
		}
		else
		{
			DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(`GETMCMVAR(SOLDIER_RANK_NAME_SET), Rank);
		}
	}
	
	if (DisplayShortRankName != "")
	{
		Tuple.Data[1].s = DisplayShortRankName;
	}
    return ELR_NoInterrupt;
}

static function EventListenerReturn OnSoldierRankIcon(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
	local XComGameState_ResistanceFaction FactionState;
	local X2SoldierClassTemplate ClassTemplate;
    local XComGameState_Unit UnitState;
    local XComLWTuple Tuple;
    local int Rank;
    local string IconImagePath;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none || ClassTemplate.RankIcons.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    IconImagePath = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (IsUnitOfficer(UnitState))
	{
		IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(`GETMCMVAR(OFFICER_RANK_ICON_SET), Rank);
	}
	else
	{
		FactionState = UnitState.GetResistanceFaction();
		if (FactionState != none)
		{
			switch (FactionState.GetMyTemplateName())
			{
			case 'Faction_Reapers':
				IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(`GETMCMVAR(REAPER_RANK_ICON_SET), Rank);
				break;
			case 'Faction_Skirmishers':
				IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(`GETMCMVAR(SKIRMISHER_RANK_ICON_SET), Rank);
				break;
			case 'Faction_Templars':
				IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(`GETMCMVAR(TEMPLAR_RANK_ICON_SET), Rank);
				break;
			default:
				break;
			}
		}
		else
		{
			IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(`GETMCMVAR(SOLDIER_RANK_ICON_SET), Rank);
		}
	}
	
	if (IconImagePath != "")
	{
		Tuple.Data[1].s = IconImagePath;
	}
    return ELR_NoInterrupt;
}

static final function bool IsUnitOfficer(const out XComGameState_Unit UnitState)
{
	local array<ClassIsOfficerStruct> OfficerClasses;
	local int Index;
	local UnitValue	UV;
	local name ValueName;

	if (default.SkipOfficerSoldierClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return false;
	}

	if (default.OfficerCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	if (default.OfficerSoldierClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	// This catches LWOTC and Long War Leader Pack officers.
	if (UnitState.FindComponentObject(class<XComGameState_BaseObject>(class'XComEngine'.static.GetClassByName('XComGameState_Unit_LWOfficer'))) != none)
	{
		return true;
	}

	OfficerClasses = class'OFF_MCM_Screen'.static.GET_OFFICER_CLASSES();
	Index = OfficerClasses.Find('TemplateName', UnitState.GetSoldierClassTemplateName());
	if (Index != INDEX_NONE && OfficerClasses[Index].bOfficer)
	{
		return true;
	}

	foreach default.OfficerAbilities(ValueName)
	{
		if (UnitState.HasSoldierAbility(ValueName))
		{
			return true;
		}
	}

	foreach default.OfficerUnitValues(ValueName)
	{
		if (UnitState.GetUnitValue(ValueName, UV))
		{
			return true;
		}
	}

	return false;
}

static final function int FindCommandingOfficerSquadSlotIndex()
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState_Unit				UnitState;
	local int								iCommandingOfficerIndex;
	local int								iCommandingOfficerRank;
	local XComGameStateHistory				History;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;
	iCommandingOfficerIndex = -1;

	for (i = 0; i < XComHQ.Squad.Length; i++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[i].ObjectID));
		if (UnitState != none && IsUnitOfficer(UnitState) && UnitState.GetRank() > iCommandingOfficerRank)
		{
			iCommandingOfficerRank = UnitState.GetRank();
			iCommandingOfficerIndex = i;
		}
	}
	return iCommandingOfficerIndex;
}