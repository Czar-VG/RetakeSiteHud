#include <sourcemod>
#include <sdktools>
#include <retakes>

#pragma newdecls required

#define PLUGIN_AUTHOR "Czar"
#define PLUGIN_VERSION "1.3"

Handle cvar_red = INVALID_HANDLE;
Handle cvar_green = INVALID_HANDLE;
Handle cvar_blue = INVALID_HANDLE;
Handle cvar_fadein = INVALID_HANDLE;
Handle cvar_fadeout = INVALID_HANDLE;
Handle cvar_xcord = INVALID_HANDLE;
Handle cvar_ycord = INVALID_HANDLE;
Handle cvar_holdtime = INVALID_HANDLE;

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
	cvar_red = CreateConVar("sm_redhud", "255");
	cvar_green = CreateConVar("sm_greenhud", "255");
	cvar_blue = CreateConVar("sm_bluehud", "255");
	cvar_fadein = CreateConVar("sm_fadein", "0.5");
	cvar_fadeout = CreateConVar("sm_fadeout", "0.5");
	cvar_holdtime = CreateConVar("sm_holdtime", "5.0");
	cvar_xcord = CreateConVar("sm_xcord", "0.42");
	cvar_ycord = CreateConVar("sm_ycord", "0.3");
	
	AutoExecConfig(true, "retakehud");
	HookEvent("round_start", Event_OnRoundStart);
}
public void Event_OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	CreateTimer(1.0, Timer_Advertise);
}

public Action displayHud(Handle timer)
{
    if (!IsWarmup())
    {
        return;
    }

	char sitechar[3];
	sitechar = (Retakes_GetCurrrentBombsite() == BombsiteA) ? "A" : "B";

	int red = GetConVarInt(cvar_red);
	int green = GetConVarInt(cvar_green);
	int blue = GetConVarInt(cvar_blue);
	float fadein = GetConVarFloat(cvar_fadein);
	float fadeout = GetConVarFloat(cvar_fadeout);
	float holdtime = GetConVarFloat(cvar_holdtime);
	float xcord = GetConVarFloat(cvar_xcord);
	float ycord = GetConVarFloat(cvar_ycord);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && !IsFakeClient(i))
        {
            if (GetPlayerWeaponSlot( i, 4 ) != -1)
            {
                SetHudTextParams(xcord, ycord, holdtime, red, green, blue, 255, 0, 0.25, fadein, fadeout);
                ShowHudText(i, 5, "Plant The Bomb!");
            }
            else
            {
                SetHudTextParams(xcord, ycord, holdtime, red, green, blue, 255, 0, 0.25, fadein, fadeout);
                ShowHudText(i, 5, "Retake Bombsite: %s", sitechar);
            }
        }
    }
}

stock bool IsWarmup()
{
	return GameRules_GetProp("m_bWarmupPeriod") == 1;
}