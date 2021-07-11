class X2RankNameTemplateManager extends X2DataTemplateManager;

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
}
static final function string GetRankNameTemplateLocName(const string TemplateName)
{
	local X2RankNameTemplate RankNameTemplate;

	RankNameTemplate = GetRankNameTemplateManager().FindRankNameTemplate(name(TemplateName));
	if (RankNameTemplate != none)
	{
		if (RankNameTemplate.LocName != "")
		{
			return RankNameTemplate.LocName;
		}
		return string(RankNameTemplate.DataName);
	}
	return class'OFF_MCM_Screen'.default.strNoReplacement;
}

static final function string GetRankNameTemplateNameByLocName(const string FindLocName)
{
	local X2RankNameTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2RankNameTemplate			RankNameTemplate;

	Mgr = GetRankNameTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		RankNameTemplate = X2RankNameTemplate(DataTemplate);
		if (RankNameTemplate.LocName == FindLocName || RankNameTemplate.DataName == name(FindLocName))
			return string(RankNameTemplate.DataName);
	}
	return "";
}

DefaultProperties
{
	TemplateDefinitionClass=class'X2RankNameSet'
	ManagedTemplateClass=class'X2RankNameTemplate'
}