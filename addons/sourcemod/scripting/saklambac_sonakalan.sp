#include <sourcemod>
#include <store>

#pragma semicolon 1
#pragma newdecls required

ConVar minplayer = null, winnercredit = null;

bool gived = false;

public Plugin myinfo = 
{
	name = "Saklambaçta Sonakalan Kredi", 
	author = "ByDexter", 
	description = "saklambaç sonakalan ct oyuncusuna kredi verilir.", 
	version = "1.1", 
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	minplayer = CreateConVar("sm_online_minplayers", "2", "Kaç kişi olunca eklenti çalışsın [ 0 = Kapar ]", 0, true, 0.0);
	winnercredit = CreateConVar("sm_sonakalan_ctkredi", "250", "Sona kalan ct oyuncusu kaç kredi alsın", 0, true, 1.0);
	HookEvent("round_start", OnRoundStart);
	HookEvent("player_death", OnClientDead);
	AutoExecConfig(true, "Saklambac.Sonakalan", "ByDexter");
}

public Action OnRoundStart(Event event, const char[] name, bool db)
{
	gived = false;
	return Plugin_Continue;
}

public Action OnClientDead(Event event, const char[] name, bool db)
{
	if (!gived)
	{
		int count = 0;
		if (minplayer.IntValue > 0)
		{
			count = minplayer.IntValue;
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsClientInGame(i))
					count--;
				
				if (count <= 0)
					break;
			}
		}
		if (count <= 0)
		{
			int player = -1;
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsClientInGame(i) && GetClientTeam(i) == 3 && IsPlayerAlive(i))
				{
					player = i;
					count++;
					
					if (count >= 2)
						break;
				}
			}
			if (count == 1 && player != -1)
			{
				Store_SetClientCredits(player, Store_GetClientCredits(player) + winnercredit.IntValue);
				PrintToChatAll("[SM] %N CT takımında sona kaldığı için %d kredi kazandı.", player, winnercredit.IntValue);
			}
			gived = true;
		}
	}
	return Plugin_Continue;
} 