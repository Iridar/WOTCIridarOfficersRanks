class OFF_MCM_Defaults extends Object config (WOTCIridarOfficersRanks_DEFAULT);

struct ClassIsOfficerStruct
{
	var name TemplateName;
	var bool bOfficer;
};

var config int VERSION_CFG;

var config string OFFICER_RANK_NAME_SET;
var config string SOLDIER_RANK_NAME_SET;
var config string REAPER_RANK_NAME_SET;
var config string SKIRMISHER_RANK_NAME_SET;
var config string TEMPLAR_RANK_NAME_SET;

var config string OFFICER_RANK_ICON_SET;
var config string SOLDIER_RANK_ICON_SET;
var config string REAPER_RANK_ICON_SET;
var config string SKIRMISHER_RANK_ICON_SET;
var config string TEMPLAR_RANK_ICON_SET;

var config string loc_OFFICER_RANK_NAME_SET;
var config string loc_SOLDIER_RANK_NAME_SET;
var config string loc_REAPER_RANK_NAME_SET;
var config string loc_SKIRMISHER_RANK_NAME_SET;
var config string loc_TEMPLAR_RANK_NAME_SET;

var config string loc_OFFICER_RANK_ICON_SET;
var config string loc_SOLDIER_RANK_ICON_SET;
var config string loc_REAPER_RANK_ICON_SET;
var config string loc_SKIRMISHER_RANK_ICON_SET;
var config string loc_TEMPLAR_RANK_ICON_SET;

var config bool REPLACE_CLASS_UNIQUE_RANKS;
var config bool MARK_OFFICER_IN_SQUAD_SELECT;

var config array<ClassIsOfficerStruct> OFFICER_CLASSES;