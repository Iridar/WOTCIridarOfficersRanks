class X2IconSetTemplateManager extends X2DataTemplateManager;

var config(RankChanges) array<name> SkipSoldierClassesFromDetection;

static function X2IconSetTemplateManager GetIconSetTemplateManager()
{
	return X2IconSetTemplateManager(class'Engine'.static.GetTemplateManager(class'X2IconSetTemplateManager'));
}

final function X2IconSetTemplate FindIconSetTemplate(const name DataName)
{
	local X2DataTemplate kTemplate;

	kTemplate = FindDataTemplate(DataName);
	if (kTemplate != none)
		return X2IconSetTemplate(kTemplate);
	return none;
}

static final function GetLocalizedTemplateList(out array<string> OutArray)
{
	local X2IconSetTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2IconSetTemplate			IconSetTemplate;

	local X2SoldierClassTemplateManager	ClassMgr;
	local X2SoldierClassTemplate		ClassTemplate;
	local array<X2SoldierClassTemplate>	ClassTemplates;

	Mgr = GetIconSetTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		IconSetTemplate = X2IconSetTemplate(DataTemplate);

		if (IconSetTemplate.LocName != "")
		{
			OutArray.AddItem(IconSetTemplate.LocName);
		}
		else
		{
			OutArray.AddItem(string(IconSetTemplate.DataName));
		}
	}

	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplates = ClassMgr.GetAllSoldierClassTemplates(true);
	foreach ClassTemplates(ClassTemplate)
	{
		if (class'X2EventListener_Officer'.default.SkipSoldierClasses.Find(ClassTemplate.DataName) != INDEX_NONE)
				continue;

		if (ClassTemplate.RankIcons.Length > 2) // >2 to catch DLC Shen and Central
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

static final function string GetIconSetTemplateLocName(const string TemplateName)
{
	local X2IconSetTemplate IconSetTemplate;

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

	IconSetTemplate = GetIconSetTemplateManager().FindIconSetTemplate(name(TemplateName));
	if (IconSetTemplate != none)
	{
		if (IconSetTemplate.LocName != "")
		{
			return IconSetTemplate.LocName;
		}
		return string(IconSetTemplate.DataName);
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

static final function string GetIconSetTemplateNameByLocName(const string FindLocName)
{
	local X2IconSetTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2IconSetTemplate			IconSetTemplate;

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

	Mgr = GetIconSetTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		IconSetTemplate = X2IconSetTemplate(DataTemplate);
		if (IconSetTemplate.LocName == FindLocName || IconSetTemplate.DataName == name(FindLocName))
			return string(IconSetTemplate.DataName);
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
	TemplateDefinitionClass=class'X2IconSet'
	ManagedTemplateClass=class'X2IconSetTemplate'
}
