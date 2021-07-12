class X2IconSetTemplate extends X2DataTemplate config(RankChanges);

var localized string LocName;
var config array<string> RankIcons;

static final function string GetIconForRank(const string TemplateName, const int Rank)
{
	local X2IconSetTemplate Template;
	local X2SoldierClassTemplate ClassTemplate;

	Template = class'X2IconSetTemplateManager'.static.GetIconSetTemplateManager().FindIconSetTemplate(name(TemplateName));
	if (Template != none)
	{
		if (Template.RankIcons.Length > Rank)
		{
			return Template.RankIcons[Rank];
		}
		return Template.RankIcons[Template.RankIcons.Length - 1];
	}


	ClassTemplate = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate(name(TemplateName));
	if (ClassTemplate != none)
	{
		if (ClassTemplate.RankIcons.Length > Rank)
		{
			return "img:///" $ ClassTemplate.RankIcons[Rank];
		}
		return  "img:///" $ ClassTemplate.RankIcons[ClassTemplate.RankIcons.Length - 1];
	}

	return "";
}