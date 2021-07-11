class X2IconSetTemplateManager extends X2DataTemplateManager;

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
}

static final function string GetIconSetTemplateLocName(const string TemplateName)
{
	local X2IconSetTemplate IconSetTemplate;

	IconSetTemplate = GetIconSetTemplateManager().FindIconSetTemplate(name(TemplateName));
	if (IconSetTemplate != none)
	{
		if (IconSetTemplate.LocName != "")
		{
			return IconSetTemplate.LocName;
		}
		return string(IconSetTemplate.DataName);
	}
	return class'OFF_MCM_Screen'.default.strNoReplacement;
}

static final function string GetIconSetTemplateNameByLocName(const string FindLocName)
{
	local X2IconSetTemplateManager	Mgr;
	local X2DataTemplate			DataTemplate;
	local X2IconSetTemplate			IconSetTemplate;

	Mgr = GetIconSetTemplateManager();

	foreach Mgr.IterateTemplates(DataTemplate)
	{
		IconSetTemplate = X2IconSetTemplate(DataTemplate);
		if (IconSetTemplate.LocName == FindLocName || IconSetTemplate.DataName == name(FindLocName))
			return string(IconSetTemplate.DataName);
	}
	return "";
}

DefaultProperties
{
	TemplateDefinitionClass=class'X2IconSet'
	ManagedTemplateClass=class'X2IconSetTemplate'
}