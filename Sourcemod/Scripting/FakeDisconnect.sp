#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Diam0ndz"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

//ConVar fakeDisconnectMessage;

public Plugin myinfo = 
{
	name = "Fake Disconnect",
	author = PLUGIN_AUTHOR,
	description = "A fake disconnect message",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/Diam0ndz/"
};

public void OnPluginStart()
{
	//dcMessage = CreateConVar("sm_fakedcmessage", "Player %s has left the game(%s).", "The disconnect message displayed when someone fake disconnects");
	
	RegConsoleCmd("sm_fakedisconnect", Command_FakeDisconnect, "Fake your disconnect", ADMFLAG_BAN);
}

public Action Command_FakeDisconnect(int client, int args)
{
	if (!IsValidClient(client))return Plugin_Handled;
	
	if(args < 1)
	{
		PrintToChatAll("Player %N has left the game(Disconnect).", client);
		return Plugin_Handled;
	}
	
	if(args == 1)
	{
		char player[MAX_NAME_LENGTH];
		GetCmdArg(1, player, sizeof(player));
		PrintToChatAll("Player %s has left the game(Disconnect).", player);
		return Plugin_Handled;
	}
	if(args > 1)
	{
		char Arguments[256];
		GetCmdArgString(Arguments, sizeof(Arguments));
		
		char arg[65];
		int len = BreakString(Arguments, arg, sizeof(arg));
		
		if (len == -1)
		{
			/* Safely null terminate */
			len = 0;
			Arguments[0] = '\0';
		}
		
		char target_name[MAX_TARGET_LENGTH];
		int target_list[MAXPLAYERS], target_count;
		bool tn_is_ml;
		
		if ((target_count = ProcessTargetString(
				arg,
				client, 
				target_list, 
				MAXPLAYERS, 
				COMMAND_FILTER_CONNECTED,
				target_name,
				sizeof(target_name),
				tn_is_ml)) > 0)
		{
			char reason[64];
			Format(reason, sizeof(reason), Arguments[len]);
			
			for (int i = 0; i < target_count; i++)
			{
				PrintToChatAll("Player %s has left the game(%s).", i, reason);
			}
			return Plugin_Handled;
			
			//PrintToChatAll("Player %s has left the game(%s).", target_name, reason);
			//return Plugin_Handled;
		}
	}
	return Plugin_Handled;
}

stock bool IsValidClient(int client) //Checks for making sure we are a valid client
{
	if (client <= 0) return false;
	if (client > MaxClients) return false;
	if (!IsClientConnected(client)) return false;
	if (IsFakeClient(client)) return false;
	if (IsClientSourceTV(client))return false;
	return IsClientInGame(client);
}