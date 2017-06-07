#define PLUGIN_AUTHOR "Czar"
#define PLUGIN_VERSION "1.00"

#define DEBUG

#include <sourcemod>
#include <sdktools>
#include <retakes>

public Plugin myinfo = 
{
	name = "Retake hud",
	author = PLUGIN_AUTHOR,
	description = "Bombsite Hud",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	HookEvent("round_start", Event_OnRoundStart);
}
public void Event_OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	CreateTimer(1.0, Timer_Advertise);
}

public Action:Timer_Advertise(Handle:timer)
{
	displayHud();
}

public void displayHud()
{
	int site = 0;
	char sitechar[3];
	site = Retakes_GetCurrrentBombsite();
	if(site == 0)
	{
		sitechar = "A";
	}
	else
	{
		sitechar = "B";
	}
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			SetHudTextParams(0.42, 0.3, 5.0, 20, 255, 20, 255, 0, 0.25, 0.5, 0.5);
			ShowHudText(i, 5, "Retake Bombsite: %s", sitechar);
		}
	}
}
