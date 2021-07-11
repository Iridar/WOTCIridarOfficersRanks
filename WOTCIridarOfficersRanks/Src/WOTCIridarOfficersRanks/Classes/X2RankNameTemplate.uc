class X2RankNameTemplate extends X2StrategyElementTemplate;

var localized string LocName;

var localized array<string> RankNames;
var localized array<string> ShortNames;

static final function string GetNameForRank(const string TemplateName, const int Rank)
{
	local X2RankNameTemplate Template;

	Template = class'X2RankNameTemplateManager'.static.GetRankNameTemplateManager().FindRankNameTemplate(name(TemplateName));
	if (Template != none)
	{
		if (Template.RankNames.Length > Rank)
		{
			return Template.RankNames[Rank];
		}
		return Template.RankNames[Template.RankNames.Length - 1];
	}
	return "";
}

static final function string GetShortNameForRank(const string TemplateName, const int Rank)
{
	local X2RankNameTemplate Template;

	Template = class'X2RankNameTemplateManager'.static.GetRankNameTemplateManager().FindRankNameTemplate(name(TemplateName));
	if (Template != none)
	{
		if (Template.ShortNames.Length > Rank)
		{
			return Template.ShortNames[Rank];
		}
		return Template.ShortNames[Template.ShortNames.Length - 1];
	}
	return "";
}