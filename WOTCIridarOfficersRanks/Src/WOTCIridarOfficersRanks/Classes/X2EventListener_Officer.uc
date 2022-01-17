class X2EventListener_Officer extends X2EventListener config(RankChanges);

var config array<name> OfficerUnitValues;
var config array<name> OfficerCharacterTemplates;
var config array<name> OfficerSoldierClasses;
var config array<name> OfficerAbilities;
var config array<name> SkipSoldierClasses;

var localized string strCommandingOfficer;

var class<XComGameState_BaseObject> LWOfficerComponentClass;

`include(WOTCIridarOfficersRanks/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2EventListener_Officer CDO;

	Templates.AddItem(SoldierRankListener());
	Templates.AddItem(SquadSelectListener());

	CDO = X2EventListener_Officer(class'XComEngine'.static.GetClassDefaultObject(class'WOTCIridarOfficersRanks.X2EventListener_Officer'));
	CDO.LWOfficerComponentClass = class<XComGameState_BaseObject>(class'XComEngine'.static.GetClassByName('XComGameState_Unit_LWOfficer'));
	if (CDO.LWOfficerComponentClass != none)
	{
		`LOG("LWOTC officer component class detected.",, 'WOTCIridarOfficersRanks');
	}

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
	if (!class'OFF_MCM_Screen'.static.ShouldMarkOfficerInSquadSelect() || Tuple == none || Tuple.Id != 'rjSquadSelect_ExtraInfo') return ELR_NoInterrupt;

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
	local string SetName;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none )
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    DisplayRankName = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (!GetIndividualConfigRankNameSetName(ClassTemplate.DataName, SetName))
	{
		// Individual config trumps the checkbox, but the checkbox trumps global config.
		if (ClassTemplate.RankNames.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))
			return ELR_NoInterrupt;

		if (IsUnitOfficer(UnitState))
		{
			SetName = `GETMCMVAR(OFFICER_RANK_NAME_SET);
		}
		else 
		{
			FactionState = UnitState.GetResistanceFaction();
			if (FactionState != none)
			{
				switch (FactionState.GetMyTemplateName())
				{
				case 'Faction_Reapers':
					SetName = `GETMCMVAR(REAPER_RANK_NAME_SET);
					break;
				case 'Faction_Skirmishers':
					SetName = `GETMCMVAR(SKIRMISHER_RANK_NAME_SET);
					break;
				case 'Faction_Templars':
					SetName = `GETMCMVAR(TEMPLAR_RANK_NAME_SET);
					break;
				default:
					break;
				}
			}
			else
			{
				SetName = `GETMCMVAR(SOLDIER_RANK_NAME_SET);
			}
		}
	}

	DisplayRankName = class'X2RankNameTemplate'.static.GetNameForRank(SetName, Rank);

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
	local string SetName;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none)
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    DisplayShortRankName = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (!GetIndividualConfigRankNameSetName(ClassTemplate.DataName, SetName))
	{
		if (ClassTemplate.ShortNames.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))	
			return ELR_NoInterrupt;

		if (IsUnitOfficer(UnitState))
		{
			SetName = `GETMCMVAR(OFFICER_RANK_NAME_SET);
		}
		else
		{
			FactionState = UnitState.GetResistanceFaction();
			if (FactionState != none)
			{
				switch (FactionState.GetMyTemplateName())
				{
				case 'Faction_Reapers':
					SetName = `GETMCMVAR(REAPER_RANK_NAME_SET);
					break;
				case 'Faction_Skirmishers':
					SetName = `GETMCMVAR(SKIRMISHER_RANK_NAME_SET);
					break;
				case 'Faction_Templars':
					SetName = `GETMCMVAR(TEMPLAR_RANK_NAME_SET);
					break;
				default:
					break;
				}
			}
			else
			{
				SetName = `GETMCMVAR(SOLDIER_RANK_NAME_SET);				
			}
		}
	}

	DisplayShortRankName = class'X2RankNameTemplate'.static.GetShortNameForRank(SetName, Rank);
	
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
	local string SetName;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		return ELR_NoInterrupt;

	ClassTemplate = UnitState.GetSoldierClassTemplate();
	if (ClassTemplate == none)
		return ELR_NoInterrupt;

	Tuple = XComLWTuple(EventData);
    Rank = Tuple.Data[0].i;
    IconImagePath = Tuple.Data[1].s;

	if (Rank == -1)
	{
		Rank = UnitState.GetRank();
	}

	if (!GetIndividualConfigRankIconSetName(ClassTemplate.DataName, SetName))
	{
		if (ClassTemplate.RankIcons.Length > 0 && !`GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS))
			return ELR_NoInterrupt;

		if (IsUnitOfficer(UnitState))
		{
			SetName = `GETMCMVAR(OFFICER_RANK_ICON_SET);
		}
		else
		{
			FactionState = UnitState.GetResistanceFaction();
			if (FactionState != none)
			{
				switch (FactionState.GetMyTemplateName())
				{
				case 'Faction_Reapers':
					SetName = `GETMCMVAR(REAPER_RANK_ICON_SET);
					break;
				case 'Faction_Skirmishers':
					SetName = `GETMCMVAR(SKIRMISHER_RANK_ICON_SET);
					break;
				case 'Faction_Templars':
					SetName = `GETMCMVAR(TEMPLAR_RANK_ICON_SET);
					break;
				default:
					break;
				}
			}
			else
			{
				SetName = `GETMCMVAR(SOLDIER_RANK_ICON_SET);
			}
		}
	}

	IconImagePath = class'X2IconSetTemplate'.static.GetIconForRank(SetName, Rank);
	
	if (IconImagePath != "")
	{
		Tuple.Data[1].s = IconImagePath;
	}
    return ELR_NoInterrupt;
}

static final function bool IsUnitOfficer(const out XComGameState_Unit UnitState)
{
	//local class<XComGameState_BaseObject> ComponentClass;
	local array<ClassIsOfficerStruct> OfficerClasses;
	local int Index;
	local UnitValue	UV;
	local name ValueName;

	if (default.OfficerCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	if (default.OfficerSoldierClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE)
	{
		return true;
	}

	// This catches LWOTC and Long War Leader Pack officers.
	//ComponentClass = class<XComGameState_BaseObject>(class'XComEngine'.static.GetClassByName('XComGameState_Unit_LWOfficer'));
	//ComponentClass = default.LWOfficerComponentClass;
	//ComponentClass = FindObject("LW_OfficerPack_Integrated.XComGameState_Unit_LWOfficer", class'Class');
	if (default.LWOfficerComponentClass != none && UnitState.FindComponentObject(default.LWOfficerComponentClass) != none)
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

// Returns true if the class has individual config and the logic should use whatever was put into SetName rather than global set names.
static final function bool GetIndividualConfigRankNameSetName(const name SoldierClassName, out string SetName)
{
	local array<IndividualClassConfigStruct> IndividualConfig;
	local int Index;

	IndividualConfig = class'OFF_MCM_Screen'.static.GET_INDIVIDUAL_CLASS_CONFIG();
	Index = IndividualConfig.Find('TemplateName', SoldierClassName);
	if (Index != INDEX_NONE)
	{
		switch (IndividualConfig[Index].RankNameSet)
		{
		case "":
		case "Default":
			return false;
		case "NoReplacement": // Return true without actually setting a SetName, so the global setname logic will not be used and soldier's ranks will not be replaced.
			return true;
		default:
			SetName = IndividualConfig[Index].RankNameSet;
			return true;
		}		
	}
	return false;
}


static final function bool GetIndividualConfigRankIconSetName(const name SoldierClassName, out string SetName)
{
	local array<IndividualClassConfigStruct> IndividualConfig;
	local int Index;

	IndividualConfig = class'OFF_MCM_Screen'.static.GET_INDIVIDUAL_CLASS_CONFIG();
	Index = IndividualConfig.Find('TemplateName', SoldierClassName);
	if (Index != INDEX_NONE)
	{
		switch (IndividualConfig[Index].RankIconSet)
		{
		case "":
		case "Default":
			return false;
		case "NoReplacement": // Return true without actually setting a SetName, so the global setname logic will not be used and soldier's ranks will not be replaced.
			return true;
		default:
			SetName = IndividualConfig[Index].RankIconSet;
			return true;
		}		
	}
	return false;
}
