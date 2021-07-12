class OFF_MCM_Screen extends Object config(WOTCIridarOfficersRanks_NullConfig);

var config int VERSION_CFG;

var localized string str_MOD_LABEL;
var localized string str_GROUP_GENERAL_SETTINGS;
var localized string str_GROUP_RANK_ICONS;
var localized string str_GROUP_RANK_NAMES;
var localized string str_GROUP_OFFICER_CLASSES;

var localized string strNoReplacement;

var config array<ClassIsOfficerStruct> OFFICER_CLASSES;

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
	local array<string> StringArray;

	local int i;
	local X2SoldierClassTemplateManager	Mgr;
	local X2SoldierClassTemplate		ClassTemplate;
    
    LoadSavedSettings();
	   
	// # MCM Screen Setup
    Page = ConfigAPI.NewSettingsPage(str_MOD_LABEL);
    Page.SetPageTitle(str_MOD_LABEL);
    Page.SetSaveHandler(SaveButtonClicked);
    //Page.EnableResetButton(ResetButtonClicked);

	// # General Settings
	Group = Page.AddGroup('IRI_Officers_MCM_Group_0', str_GROUP_GENERAL_SETTINGS);
	`MCM_API_AutoAddCheckBox(Group, REPLACE_CLASS_UNIQUE_RANKS);	
	`MCM_API_AutoAddCheckBox(Group, MARK_OFFICER_IN_SQUAD_SELECT);	

	// # Rank Name Sets
	Group = Page.AddGroup('IRI_Officers_MCM_Group_1', str_GROUP_RANK_NAMES);
	StringArray.AddItem(strNoReplacement);
	class'X2RankNameTemplateManager'.static.GetLocalizedTemplateList(StringArray);

	`MCM_API_AutoAddDropdown(Group, loc_OFFICER_RANK_NAME_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_SOLDIER_RANK_NAME_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_REAPER_RANK_NAME_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_SKIRMISHER_RANK_NAME_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_TEMPLAR_RANK_NAME_SET, StringArray);

	// # Rank Icon Sets
	Group = Page.AddGroup('IRI_Officers_MCM_Group_2', str_GROUP_RANK_ICONS);
	StringArray.Length = 0;
	StringArray.AddItem(strNoReplacement);
	class'X2IconSetTemplateManager'.static.GetLocalizedTemplateList(StringArray);

	`MCM_API_AutoAddDropdown(Group, loc_OFFICER_RANK_ICON_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_SOLDIER_RANK_ICON_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_REAPER_RANK_ICON_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_SKIRMISHER_RANK_ICON_SET, StringArray);
	`MCM_API_AutoAddDropdown(Group, loc_TEMPLAR_RANK_ICON_SET, StringArray);

	// # Officer classes
	Group = Page.AddGroup('IRI_Officers_MCM_Group_3', str_GROUP_OFFICER_CLASSES);
	// Validate list of templates
	Mgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	for (i = OFFICER_CLASSES.Length - 1; i >= 0; i--)
	{
		ClassTemplate = Mgr.FindSoldierClassTemplate(OFFICER_CLASSES[i].TemplateName);
		if (ClassTemplate == none || 
			ClassTemplate.bMultiplayerOnly || 
			ClassTemplate.SoldierRanks.Length == 0 || 
			ClassTemplate.DisplayName == "" ||
			class'X2EventListener_Officer'.default.SkipOfficerSoldierClasses.Find(OFFICER_CLASSES[i].TemplateName) != INDEX_NONE)
		{
			OFFICER_CLASSES.Remove(i, 1);
		}
	}

	// Adding checkboxes in a separate forward (not reverse) cycle so that classes are sorted by vanilla -> DLC -> mod-added.
	for (i = 0; i < OFFICER_CLASSES.Length; i++)
	{
		ClassTemplate = Mgr.FindSoldierClassTemplate(OFFICER_CLASSES[i].TemplateName);
		Group.AddCheckbox(OFFICER_CLASSES[i].TemplateName, ClassTemplate.DisplayName @ "(" $ OFFICER_CLASSES[i].TemplateName $ ")", "", OFFICER_CLASSES[i].bOfficer,, OfficerClassCheckboxHandler);
	}

    Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	local X2SoldierClassTemplateManager Mgr;
	local ClassIsOfficerStruct ClassIsOfficer;
	local array<name> TemplateNames;
	local name TemplateName;

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

	// Officer classes
	OFFICER_CLASSES = `MCM_CH_GetValue(class'OFF_MCM_Defaults'.default.OFFICER_CLASSES, OFFICER_CLASSES);
	Mgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	Mgr.GetTemplateNames(TemplateNames);

	// Append the array with soldier class templates that are not there already.
	foreach TemplateNames(TemplateName)
	{
		if (OFFICER_CLASSES.Find('TemplateName', TemplateName) == INDEX_NONE)
		{
			ClassIsOfficer.TemplateName = TemplateName;
			OFFICER_CLASSES.AddItem(ClassIsOfficer);
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
