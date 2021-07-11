class X2IconSet extends X2DataSet config(RankChanges);

var config array<name> RankIconSets;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>	Templates;
	local X2IconSetTemplate		IconSetTemplate;
	local name					TemplateName;

	foreach default.RankIconSets(TemplateName)
	{
		`CREATE_X2TEMPLATE(class'X2IconSetTemplate', IconSetTemplate, TemplateName);
		Templates.AddItem(IconSetTemplate);
	}

	return Templates;
}
