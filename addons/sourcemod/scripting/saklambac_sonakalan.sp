#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <multicolors>
#include <store>

#pragma semicolon 1
#pragma newdecls required

ConVar ConVar_MinPlayers;
ConVar ConVar_CTCredit;

public Plugin myinfo = 
{
	name = "Saklambaçta Sonakalan Kredi",
	author = "ByDexter",
	description = "saklambaç sonakalan ct oyuncusuna kredi verilir.",
	version = "1.0",
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	ConVar_MinPlayers = CreateConVar("sm_online_minplayers", "6", "Kaç kişi olunca eklenti çalışsın");
	ConVar_CTCredit = CreateConVar("sm_sonakalan_ctkredi", "250", "Sona kalan ct oyuncusu kaç kredi alsın");
	HookEvent("player_death", Control_PDead);
	AutoExecConfig(true, "Saklambac.Sonakalan", "ByDexter");
}

public Action Control_PDead(Handle event, const char[] name, bool dontBroadcast)
{
	int count;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			if (GetClientTeam(i) == CS_TEAM_T)	
			{
				count++;
			}
			if (GetClientTeam(i) == CS_TEAM_CT)	
			{
				count++;
			}
		}
	}
	if (count >= ConVar_MinPlayers.IntValue)
	{
		int CT_Sayisi = 0;
		for (int i = 1; i <= MaxClients; i++) 
		if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			if(GetClientTeam(i) == CS_TEAM_CT)
			{
				CT_Sayisi++;		
			}
			if(GetClientTeam(i) == CS_TEAM_CT && IsPlayerAlive(i) && CT_Sayisi == 1)
			{
				int int_CTCredit = ConVar_CTCredit.IntValue;
				Store_SetClientCredits(i, Store_GetClientCredits(i) + int_CTCredit);
				CPrintToChatAll("{darkred}[ByDexter] {default}Sona kalan CT oyuncusu {green}%d kredi kazandı", int_CTCredit);
			}
		}
	}
	else
	{
		CPrintToChatAll("{darkred}[ByDexter] {green}%d oyuncu {default}olmadığı için {darkblue}CT Takımındaki {default}sona kalan oyuncu kredi alamadı");
	}
}