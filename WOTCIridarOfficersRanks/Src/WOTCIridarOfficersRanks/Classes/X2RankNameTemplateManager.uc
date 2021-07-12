class X2RankNameTemplateManager extends X2DataTemplateManager;

var config(RankChanges) array<name> SkipSoldierClassesFromDetection;

static function X2RankNameTemplateManager GetRankNameTemplateManager()
{
	return X2RankNameTemplateManager(class'Engine'.static.GetTemplateManager(class'X2RankNameTemplateManager'));
}

final function X2RankNameTemplate FindRankNameTemplate(const name DataName)
{
	local X2DataTemplate kTemplate;

	kTemplate = FindDataTemplate(DataName);
	if (kTemplate != none)
		return X2RankNameTemplate(kTemplate);
	return none;
}

static final function GetLocalizedTemplateList(out array<string> OutArray)
{
	local X2RankNameTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2RankNameTemplate		RankNameTemplate;

	local X2SoldierClassTemplateManager	ClassMgr;
	local X2SoldierClassTemplate		ClassTemplate;
	local array<X2SoldierClassTemplate>	ClassTemplates;

	Mgr = GetRankNameTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		RankNameTemplate = X2RankNameTemplate(DataTemplate);

		if (RankNameTemplate.LocName != "")
		{
			OutArray.AddItem(RankNameTemplate.LocName);
		}
		else
		{
			OutArray.AddItem(string(RankNameTemplate.DataName));
		}
	}

	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplates = ClassMgr.GetAllSoldierClassTemplates(true);
	foreach ClassTemplates(ClassTemplate)
	{
		if (class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(ClassTemplate.DataName) != INDEX_NONE)
				continue;

		if (ClassTemplate.RankNames.Length > 2) // >2 to catch DLC Shen and Central
		{
			if (ClassTemplate.DisplayName != "")
			{
				if (OutArray.Find(ClassTemplate.DisplayName) == INDEX_NONE)
				{
					OutArray.AddItem(ClassTemplate.DisplayName);
				}
			}
			else if (OutArray.Find(string(ClassTemplate.DataName)) == INDEX_NONE)
			{
				OutArray.AddItem(string(ClassTemplate.DataName));
			}
		}
	}
}
static final function string GetRankNameTemplateLocName(const string TemplateName)
{
	local X2RankNameTemplate RankNameTemplate;

	local X2SoldierClassTemplateManager	ClassMgr;
	local X2SoldierClassTemplate		ClassTemplate;

	switch (TemplateName)
	{
		case "NoReplacement":
			return class'OFF_MCM_Screen'.default.strNoReplacement;
		case "Default":
			return class'OFF_MCM_Screen'.default.strDefault;
		default:
			break;
	}

	RankNameTemplate = GetRankNameTemplateManager().FindRankNameTemplate(name(TemplateName));
	if (RankNameTemplate != none)
	{
		if (RankNameTemplate.LocName != "")
		{
			return RankNameTemplate.LocName;
		}
		return string(RankNameTemplate.DataName);
	}

	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassMgr.FindSoldierClassTemplate(name(TemplateName));
	if (ClassTemplate != none)
	{
		if (ClassTemplate.DisplayName != "")
		{
			return ClassTemplate.DisplayName;
		}
		return string(ClassTemplate.DataName);
	}

	return class'OFF_MCM_Screen'.default.strNoReplacement;
}

static final function string GetRankNameTemplateNameByLocName(const string FindLocName)
{
	local X2RankNameTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2RankNameTemplate		RankNameTemplate;

	local X2SoldierClassTemplateManager	ClassMgr;
	local X2SoldierClassTemplate		ClassTemplate;
	local array<X2SoldierClassTemplate>	ClassTemplates;

	switch (FindLocName)
	{
		case class'OFF_MCM_Screen'.default.strNoReplacement:
			return "NoReplacement";
		case class'OFF_MCM_Screen'.default.strDefault:
			return "Default";
		default:
			break;
	}

	Mgr = GetRankNameTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		RankNameTemplate = X2RankNameTemplate(DataTemplate);
		if (RankNameTemplate.LocName == FindLocName || RankNameTemplate.DataName == name(FindLocName))
			return string(RankNameTemplate.DataName);
	}

	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplates = ClassMgr.GetAllSoldierClassTemplates(true);
	foreach ClassTemplates(ClassTemplate)
	{
		if (class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(ClassTemplate.DataName) != INDEX_NONE)
				continue;

		if (ClassTemplate.DisplayName == FindLocName || ClassTemplate.DataName == name(FindLocName))
		{
			return string(ClassTemplate.DataName);
		}
	}

	return "";
}

DefaultProperties
{
	TemplateDefinitionClass=class'X2RankNameSet'
	ManagedTemplateClass=class'X2RankNameTemplate'
}