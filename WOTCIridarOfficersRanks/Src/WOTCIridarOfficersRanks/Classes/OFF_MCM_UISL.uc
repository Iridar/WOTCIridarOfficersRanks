class OFF_MCM_UISL extends UIScreenListener;

event OnInit (UIScreen Screen)
{
	local OFF_MCM_Screen MCMScreen;

	`LOG(self.Class.Name @ GetFuncName(),, 'IRI_CRR');

	if (ScreenClass == none)
	{
		if (MCM_API(Screen) != none)
		{
			ScreenClass = Screen.Class;
		}
		else
		{
			return;
		}
	}

	`LOG("Creating OFF_MCM_Screen",, 'IRI_CRR');
	MCMScreen = new class'OFF_MCM_Screen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}