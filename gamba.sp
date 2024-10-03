#include <sourcemod>

public Plugin:myinfo = {
    name = "Lottery",
    author = "cheyo",
    description = "Lottery for Sourcemod",
    url = ""
};

#define MAX_CLIENTS 50 //Max player count

new String:authids[MAX_CLIENTS][32]; // Array to store Steam IDs for each client



public OnPluginStart() {
    RegConsoleCmd("sm_lottery", Command_Lottery, "");
}

public Action Command_Lottery(client, args) {
	    
	int lotteryNumber = GetRandomInt(0, 50);
    PrintToConsole(client, "You rolled %d", lotteryNumber);

    new String:name[32];
    GetClientName(client, name, sizeof(name));

    int lotteryRoll = GetRandomInt(0, 50);
    RegisterParticipation(client);

    if (lotteryRoll == lotteryNumber) {
        PrintToChatAll("%s won the lottery today!", name);
    } else {
        PrintToChat(client, "Unfortunately, you didn't win today");
    }
    return Plugin_Handled;
}

void RegisterParticipation(client) {
    for (client = 1; client <= MAX_CLIENTS; client++) {
    new String:authid[32];
    GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
    authids[client - 1] = authid; // Store the Steam ID for the current client
    PrintToServer("PARTICIPATED!");
	}
}