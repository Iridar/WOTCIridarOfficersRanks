class X2RankNameSet extends X2DataSet config(RankChanges);

var config array<name> RankNameSets;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>	Templates;
	local X2RankNameTemplate	RankTemplate;
	local name					TemplateName;

	foreach default.RankNameSets(TemplateName)
	{
		`CREATE_X2TEMPLATE(class'X2RankNameTemplate', RankTemplate, TemplateName);
		Templates.AddItem(RankTemplate);
	}

	return Templates;
}