class OFF_MCM_Screen extends Object config(WOTCIridarOfficersRanks_NullConfig);

var config int VERSION_CFG;

var localized string str_MOD_LABEL;
var localized string str_GROUP_GENERAL_SETTINGS;
var localized string str_GROUP_RANK_ICONS;
var localized string str_GROUP_RANK_NAMES;
var localized string str_INDIVIDUAL_CONFIG;
var localized string str_GROUP_OFFICER_CLASSES;
var localized string MARK_OFFICER_IN_SQUAD_SELECT_Tip_LWOTC;

var localized string strNoReplacement;
var localized string strDefault;
var localized string strClassIndividualConfigTooltip;
var localized string strOfficerClassTooltip;

var config array<ClassIsOfficerStruct> OFFICER_CLASSES;
var config array<IndividualClassConfigStruct> INDIVIDUAL_CLASS_CONFIG;

`include(WOTCIridarOfficersRanks\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

`MCM_API_AutoDropdownVars(OFFICER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(SOLDIER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(REAPER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(SKIRMISHER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(TEMPLAR_RANK_NAME_SET);

`MCM_API_AutoDropdownVars(OFFICER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(SOLDIER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(REAPER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(SKIRMISHER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(TEMPLAR_RANK_ICON_SET);

`MCM_API_AutoDropdownVars(loc_OFFICER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(loc_SOLDIER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(loc_REAPER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(loc_SKIRMISHER_RANK_NAME_SET);
`MCM_API_AutoDropdownVars(loc_TEMPLAR_RANK_NAME_SET);

`MCM_API_AutoDropdownVars(loc_OFFICER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(loc_SOLDIER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(loc_REAPER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(loc_SKIRMISHER_RANK_ICON_SET);
`MCM_API_AutoDropdownVars(loc_TEMPLAR_RANK_ICON_SET);

`MCM_API_AutoCheckBoxVars(REPLACE_CLASS_UNIQUE_RANKS);
`MCM_API_AutoCheckBoxVars(MARK_OFFICER_IN_SQUAD_SELECT);

`include(WOTCIridarOfficersRanks\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

`MCM_API_AutoDropdownFns(OFFICER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(SOLDIER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(REAPER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(SKIRMISHER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(TEMPLAR_RANK_NAME_SET, 1);

`MCM_API_AutoDropdownFns(OFFICER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(SOLDIER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(REAPER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(SKIRMISHER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(TEMPLAR_RANK_ICON_SET, 1);

`MCM_API_AutoDropdownFns(loc_OFFICER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(loc_SOLDIER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(loc_REAPER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(loc_SKIRMISHER_RANK_NAME_SET, 1);
`MCM_API_AutoDropdownFns(loc_TEMPLAR_RANK_NAME_SET, 1);

`MCM_API_AutoDropdownFns(loc_OFFICER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(loc_SOLDIER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(loc_REAPER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(loc_SKIRMISHER_RANK_ICON_SET, 1);
`MCM_API_AutoDropdownFns(loc_TEMPLAR_RANK_ICON_SET, 1);

`MCM_API_AutoCheckBoxFns(REPLACE_CLASS_UNIQUE_RANKS, 1);
`MCM_API_AutoCheckBoxFns(MARK_OFFICER_IN_SQUAD_SELECT, 1);

event OnInit(UIScreen Screen)
{
	if (MCM_API(Screen) != none)
	{
		`MCM_API_Register(Screen, ClientModCallback);
	}
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    local MCM_API_SettingsPage Page;
    local MCM_API_SettingsGroup Group;
	local array<string> RankIconOptions;
	local array<string> RankNameOptions;

	local bool bLWOTC;
	local X2SoldierClassTemplateManager	Mgr;
	local X2SoldierClassTemplate		ClassTemplate;
	local string						SetLocName;
	//local int							iNumEntries;
	//local int							iNumPages;
	local int i;

	// # Internal Init
	//iNumPages = 1;
	Mgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	RankNameOptions.AddItem(strNoReplacement);
	class'X2RankNameTemplateManager'.static.GetLocalizedTemplateList(RankNameOptions);

	RankIconOptions.AddItem(strNoReplacement);
	class'X2IconSetTemplateManager'.static.GetLocalizedTemplateList(RankIconOptions);
    
    LoadSavedSettings();
	   
	// # MCM Screen Setup
    Page = ConfigAPI.NewSettingsPage(str_MOD_LABEL);
    Page.SetPageTitle("Iridar's Cosmetic Rank Replacer");
    Page.SetSaveHandler(SaveButtonClicked);
    //Page.EnableResetButton(ResetButtonClicked);

	// # General Settings
	Group = Page.AddGroup('IRI_Officers_MCM_Group_0', `CAPS(str_GROUP_GENERAL_SETTINGS));
	`MCM_API_AutoAddCheckBox(Group, REPLACE_CLASS_UNIQUE_RANKS);	

	bLWOTC = IsModActive('LongWarOfTheChosen');
	Group.AddCheckbox('MARK_OFFICER_IN_SQUAD_SELECT', MARK_OFFICER_IN_SQUAD_SELECT_Label, 
		bLWOTC ? MARK_OFFICER_IN_SQUAD_SELECT_Tip_LWOTC : MARK_OFFICER_IN_SQUAD_SELECT_Tip, 
		bLWOTC ? false : MARK_OFFICER_IN_SQUAD_SELECT, MARK_OFFICER_IN_SQUAD_SELECT_SaveHandler).SetEditable(!bLWOTC);

	// # Rank Name Sets - Global Config
	Group = Page.AddGroup('IRI_Officers_MCM_Group_A', `CAPS(str_GROUP_RANK_NAMES));	

	`MCM_API_AutoAddDropdown(Group, loc_OFFICER_RANK_NAME_SET, RankNameOptions);
	`MCM_API_AutoAddDropdown(Group, loc_SOLDIER_RANK_NAME_SET, RankNameOptions);
	`MCM_API_AutoAddDropdown(Group, loc_REAPER_RANK_NAME_SET, RankNameOptions);
	`MCM_API_AutoAddDropdown(Group, loc_SKIRMISHER_RANK_NAME_SET, RankNameOptions);
	`MCM_API_AutoAddDropdown(Group, loc_TEMPLAR_RANK_NAME_SET, RankNameOptions);

	// # Rank Icon Sets
	Group = Page.AddGroup('IRI_Officers_MCM_Group_B', `CAPS(str_GROUP_RANK_ICONS));	

	`MCM_API_AutoAddDropdown(Group, loc_OFFICER_RANK_ICON_SET, RankIconOptions);
	`MCM_API_AutoAddDropdown(Group, loc_SOLDIER_RANK_ICON_SET, RankIconOptions);
	`MCM_API_AutoAddDropdown(Group, loc_REAPER_RANK_ICON_SET, RankIconOptions);
	`MCM_API_AutoAddDropdown(Group, loc_SKIRMISHER_RANK_ICON_SET, RankIconOptions);
	`MCM_API_AutoAddDropdown(Group, loc_TEMPLAR_RANK_ICON_SET, RankIconOptions);

	if (INDIVIDUAL_CLASS_CONFIG.Length * 2 + OFFICER_CLASSES.Length < 200)
	{
		// # Rank Name Sets - Individual config
		Group = Page.AddGroup('IRI_Officers_MCM_Group_C', `CAPS(str_GROUP_RANK_NAMES $ str_INDIVIDUAL_CONFIG));

		RankNameOptions.InsertItem(0, strDefault);
		for (i = 0; i < INDIVIDUAL_CLASS_CONFIG.Length; i++)
		{
			ClassTemplate = Mgr.FindSoldierClassTemplate(INDIVIDUAL_CLASS_CONFIG[i].TemplateName);
			SetLocName = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(INDIVIDUAL_CLASS_CONFIG[i].RankNameSet);
			Group.AddDropdown(ClassTemplate.DataName, ClassTemplate.DisplayName @ "(" $ ClassTemplate.DataName $ ")", strClassIndividualConfigTooltip, RankNameOptions, SetLocName, IndividualSoldierClassHandler_RankName);
			//iNumEntries++;
			//if (iNumEntries > 200)
			//{
			//	iNumEntries = 0;
			//	iNumPages++;
			//	Page.ShowSettings();
			//
			//	Page = ConfigAPI.NewSettingsPage(str_MOD_LABEL @ iNumPages);
			//	Page.SetPageTitle("Iridar's Cosmetic Rank Replacer" @ iNumPages);
			//	Page.SetSaveHandler(SaveButtonClicked);
			//	Group = Page.AddGroup('IRI_Officers_MCM_Group_C', str_GROUP_RANK_NAMES $ str_INDIVIDUAL_CONFIG);
			//}
		}

		// # Rank Icon Sets - Individual config
		Group = Page.AddGroup('IRI_Officers_MCM_Group_D', `CAPS(str_GROUP_RANK_ICONS $ str_INDIVIDUAL_CONFIG));

		RankIconOptions.InsertItem(0, strDefault);
		for (i = 0; i < INDIVIDUAL_CLASS_CONFIG.Length; i++)
		{
			ClassTemplate = Mgr.FindSoldierClassTemplate(INDIVIDUAL_CLASS_CONFIG[i].TemplateName);
			SetLocName = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(INDIVIDUAL_CLASS_CONFIG[i].RankIconSet);
			Group.AddDropdown(ClassTemplate.DataName, ClassTemplate.DisplayName @ "(" $ ClassTemplate.DataName $ ")", strClassIndividualConfigTooltip, RankIconOptions, SetLocName, IndividualSoldierClassHandler_RankIcon);
			//iNumEntries++;
			//if (iNumEntries > 200)
			//{
			//	iNumEntries = 0;
			//	iNumPages++;
			//	Page.ShowSettings();
			//
			//	Page = ConfigAPI.NewSettingsPage(str_MOD_LABEL @ iNumPages);
			//	Page.SetPageTitle("Iridar's Cosmetic Rank Replacer" @ iNumPages);
			//	Page.SetSaveHandler(SaveButtonClicked);
			//	Group = Page.AddGroup('IRI_Officers_MCM_Group_D', `CAPS(str_GROUP_RANK_ICONS $ str_INDIVIDUAL_CONFIG));
			//}
		}

		// # Officer classes
		Group = Page.AddGroup('IRI_Officers_MCM_Group_E', `CAPS(str_GROUP_OFFICER_CLASSES));

		for (i = 0; i < OFFICER_CLASSES.Length; i++)
		{
			ClassTemplate = Mgr.FindSoldierClassTemplate(OFFICER_CLASSES[i].TemplateName);
			Group.AddCheckbox(ClassTemplate.DataName, ClassTemplate.DisplayName @ "(" $ OFFICER_CLASSES[i].TemplateName $ ")", strOfficerClassTooltip, OFFICER_CLASSES[i].bOfficer, OfficerClassCheckboxHandler);
			//iNumEntries++;
			//if (iNumEntries > 200)
			//{
			//	iNumEntries = 0;
			//	iNumPages++;
			//	Page.ShowSettings();
			//
			//	Page = ConfigAPI.NewSettingsPage(str_MOD_LABEL @ iNumPages);
			//	Page.SetPageTitle("Iridar's Cosmetic Rank Replacer" @ iNumPages);
			//	Page.SetSaveHandler(SaveButtonClicked);
			//	Group = Page.AddGroup('IRI_Officers_MCM_Group_E', `CAPS(str_GROUP_OFFICER_CLASSES));
			//}
		}
	}
    Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	local ClassIsOfficerStruct			ClassIsOfficer;
	local IndividualClassConfigStruct	NewIndividualConfig;
	local X2SoldierClassTemplateManager Mgr;
	local array<X2SoldierClassTemplate>	ClassTemplates;
	local X2SoldierClassTemplate		ClassTemplate;
	local int i;

    OFFICER_RANK_NAME_SET = `GETMCMVAR(OFFICER_RANK_NAME_SET);
	SOLDIER_RANK_NAME_SET = `GETMCMVAR(SOLDIER_RANK_NAME_SET);
	REAPER_RANK_NAME_SET = `GETMCMVAR(REAPER_RANK_NAME_SET);
	SKIRMISHER_RANK_NAME_SET = `GETMCMVAR(SKIRMISHER_RANK_NAME_SET);
	TEMPLAR_RANK_NAME_SET = `GETMCMVAR(TEMPLAR_RANK_NAME_SET);

	OFFICER_RANK_ICON_SET = `GETMCMVAR(OFFICER_RANK_ICON_SET);
	SOLDIER_RANK_ICON_SET = `GETMCMVAR(SOLDIER_RANK_ICON_SET);
	REAPER_RANK_ICON_SET = `GETMCMVAR(REAPER_RANK_ICON_SET);
	SKIRMISHER_RANK_ICON_SET = `GETMCMVAR(SKIRMISHER_RANK_ICON_SET);
	TEMPLAR_RANK_ICON_SET = `GETMCMVAR(TEMPLAR_RANK_ICON_SET);

	REPLACE_CLASS_UNIQUE_RANKS = `GETMCMVAR(REPLACE_CLASS_UNIQUE_RANKS);
	MARK_OFFICER_IN_SQUAD_SELECT = `GETMCMVAR(MARK_OFFICER_IN_SQUAD_SELECT);

	Mgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	// Individual config
	INDIVIDUAL_CLASS_CONFIG = `MCM_CH_GetValue(class'OFF_MCM_Defaults'.default.INDIVIDUAL_CLASS_CONFIG, INDIVIDUAL_CLASS_CONFIG);

	// Validate list of templates
	for (i = INDIVIDUAL_CLASS_CONFIG.Length - 1; i >= 0; i--)
	{
		ClassTemplate = Mgr.FindSoldierClassTemplate(INDIVIDUAL_CLASS_CONFIG[i].TemplateName);
		if (ClassTemplate == none || 
			ClassTemplate.SoldierRanks.Length == 0 || 
			ClassTemplate.DisplayName == "" ||
			class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(INDIVIDUAL_CLASS_CONFIG[i].TemplateName) != INDEX_NONE)
		{
			INDIVIDUAL_CLASS_CONFIG.Remove(i, 1);
		}
	}

	// Officer classes
	OFFICER_CLASSES = `MCM_CH_GetValue(class'OFF_MCM_Defaults'.default.OFFICER_CLASSES, OFFICER_CLASSES);
	
	// Validate list of templates
	for (i = OFFICER_CLASSES.Length - 1; i >= 0; i--)
	{
		ClassTemplate = Mgr.FindSoldierClassTemplate(OFFICER_CLASSES[i].TemplateName);
		if (ClassTemplate == none || 
			ClassTemplate.SoldierRanks.Length == 0 || 
			ClassTemplate.DisplayName == "" ||
			class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(OFFICER_CLASSES[i].TemplateName) != INDEX_NONE)
		{
			OFFICER_CLASSES.Remove(i, 1);
		}
	}

	// Append the arrays with soldier class templates that are not there already.
	ClassTemplates = Mgr.GetAllSoldierClassTemplates(true);
	NewIndividualConfig.RankNameSet = "Default";
	NewIndividualConfig.RankIconSet = "Default";

	foreach ClassTemplates(ClassTemplate)
	{
		if (class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(ClassTemplate.DataName) != INDEX_NONE)
			continue;

		if (OFFICER_CLASSES.Find('TemplateName', ClassTemplate.DataName) == INDEX_NONE)
		{
			ClassIsOfficer.TemplateName = ClassTemplate.DataName;
			OFFICER_CLASSES.AddItem(ClassIsOfficer);
		}

		if (INDIVIDUAL_CLASS_CONFIG.Find('TemplateName', ClassTemplate.DataName) == INDEX_NONE)
		{
			NewIndividualConfig.TemplateName = ClassTemplate.DataName;
			INDIVIDUAL_CLASS_CONFIG.AddItem(NewIndividualConfig);
		}
	}

	SyncLoc();
}

static final function bool ConfigFileNotCreated()
{
    return class'OFF_MCM_Defaults'.default.VERSION_CFG > default.VERSION_CFG;
}

static final function array<ClassIsOfficerStruct> GET_OFFICER_CLASSES()
{
	if (ConfigFileNotCreated())
    {
        return class'OFF_MCM_Defaults'.default.OFFICER_CLASSES;
    }
    return default.OFFICER_CLASSES;
}

simulated function OfficerClassCheckboxHandler(MCM_API_Setting Setting, bool SettingValue)
{
	local int Index;
	
	Index = OFFICER_CLASSES.Find('TemplateName', Setting.GetName());
	if (Index != INDEX_NONE)
	{
		OFFICER_CLASSES[Index].bOfficer = SettingValue;
	}
}

simulated function IndividualSoldierClassHandler_RankName(MCM_API_Setting Setting, string SettingValue)
{
	local int Index;
	
	Index = INDIVIDUAL_CLASS_CONFIG.Find('TemplateName', Setting.GetName());
	if (Index != INDEX_NONE)
	{
		INDIVIDUAL_CLASS_CONFIG[Index].RankNameSet = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(SettingValue);
	}
}

simulated function IndividualSoldierClassHandler_RankIcon(MCM_API_Setting Setting, string SettingValue)
{
	local int Index;
	
	Index = INDIVIDUAL_CLASS_CONFIG.Find('TemplateName', Setting.GetName());
	if (Index != INDEX_NONE)
	{
		INDIVIDUAL_CLASS_CONFIG[Index].RankIconSet = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(SettingValue);
	}
}

static final function array<IndividualClassConfigStruct> GET_INDIVIDUAL_CLASS_CONFIG()
{
	if (ConfigFileNotCreated())
    {
        return class'OFF_MCM_Defaults'.default.INDIVIDUAL_CLASS_CONFIG;
    }
    return default.INDIVIDUAL_CLASS_CONFIG;
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	OFFICER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(loc_OFFICER_RANK_NAME_SET);
	SOLDIER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(loc_SOLDIER_RANK_NAME_SET);
	REAPER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(loc_REAPER_RANK_NAME_SET);
	SKIRMISHER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(loc_SKIRMISHER_RANK_NAME_SET);
	TEMPLAR_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateNameByLocName(loc_TEMPLAR_RANK_NAME_SET);

	OFFICER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(loc_OFFICER_RANK_ICON_SET);
	SOLDIER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(loc_SOLDIER_RANK_ICON_SET);
	REAPER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(loc_REAPER_RANK_ICON_SET);
	SKIRMISHER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(loc_SKIRMISHER_RANK_ICON_SET);
	TEMPLAR_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateNameByLocName(loc_TEMPLAR_RANK_ICON_SET);

	`PRESBASE.PlayUISound(eSUISound_MenuSelect);
	VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}

simulated function SyncLoc()
{
	loc_OFFICER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(OFFICER_RANK_NAME_SET);
	loc_SOLDIER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(SOLDIER_RANK_NAME_SET);
	loc_REAPER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(REAPER_RANK_NAME_SET);
	loc_SKIRMISHER_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(SKIRMISHER_RANK_NAME_SET);
	loc_TEMPLAR_RANK_NAME_SET = class'X2RankNameTemplateManager'.static.GetRankNameTemplateLocName(TEMPLAR_RANK_NAME_SET);

	loc_OFFICER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(OFFICER_RANK_ICON_SET);
	loc_SOLDIER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(SOLDIER_RANK_ICON_SET);
	loc_REAPER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(REAPER_RANK_ICON_SET);
	loc_SKIRMISHER_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(SKIRMISHER_RANK_ICON_SET);
	loc_TEMPLAR_RANK_ICON_SET = class'X2IconSetTemplateManager'.static.GetIconSetTemplateLocName(TEMPLAR_RANK_ICON_SET);
}

static final function bool ShouldMarkOfficerInSquadSelect()
{
	if (IsModActive('LongWarOfTheChosen'))
	{
		return false;
	}
	return `GETMCMVAR(MARK_OFFICER_IN_SQUAD_SELECT);
}

static final function bool IsModActive(name ModName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        if (EventManager.GetDLCNames(Index) == ModName) 
        {
            return true;
        }
    }
    return false;
}

// Doesn't seem to work
/*
simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	`MCM_API_AutoReset(OFFICER_RANK_NAME_SET);
	`MCM_API_AutoReset(SOLDIER_RANK_NAME_SET);
	`MCM_API_AutoReset(REAPER_RANK_NAME_SET);
	`MCM_API_AutoReset(SKIRMISHER_RANK_NAME_SET);
	`MCM_API_AutoReset(TEMPLAR_RANK_NAME_SET);
	
	`MCM_API_AutoReset(OFFICER_RANK_ICON_SET);
	`MCM_API_AutoReset(SOLDIER_RANK_ICON_SET);
	`MCM_API_AutoReset(REAPER_RANK_ICON_SET);
	`MCM_API_AutoReset(SKIRMISHER_RANK_ICON_SET);
	`MCM_API_AutoReset(TEMPLAR_RANK_ICON_SET);

	SyncLoc();

	`MCM_API_AutoReset(loc_OFFICER_RANK_NAME_SET);
	`MCM_API_AutoReset(loc_SOLDIER_RANK_NAME_SET);
	`MCM_API_AutoReset(loc_REAPER_RANK_NAME_SET);
	`MCM_API_AutoReset(loc_SKIRMISHER_RANK_NAME_SET);
	`MCM_API_AutoReset(loc_TEMPLAR_RANK_NAME_SET);
	
	`MCM_API_AutoReset(loc_OFFICER_RANK_ICON_SET);
	`MCM_API_AutoReset(loc_SOLDIER_RANK_ICON_SET);
	`MCM_API_AutoReset(loc_REAPER_RANK_ICON_SET);
	`MCM_API_AutoReset(loc_SKIRMISHER_RANK_ICON_SET);
	`MCM_API_AutoReset(loc_TEMPLAR_RANK_ICON_SET);

	`PRESBASE.PlayUISound(eSUISound_MenuSelect);
}
*/
