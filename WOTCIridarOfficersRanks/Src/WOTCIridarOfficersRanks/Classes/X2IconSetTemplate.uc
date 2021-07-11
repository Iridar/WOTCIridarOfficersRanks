class X2IconSetTemplate extends X2DataTemplate config(RankChanges);

var localized string LocName;
var config array<string> RankIcons;

static final function string GetIconForRank(const string TemplateName, const int Rank)
{
	local X2IconSetTemplate Template;

	Template = class'X2IconSetTemplateManager'.static.GetIconSetTemplateManager().FindIconSetTemplate(name(TemplateName));
	if (Template != none)
	{
		if (Template.RankIcons.Length > Rank)
		{
			return Template.RankIcons[Rank];
		}
		return Template.RankIcons[Template.RankIcons.Length - 1];
	}
	return "";
}