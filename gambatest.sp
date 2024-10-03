#include <sourcemod>

public Plugin:myinfo = {
    name = "Lottery",
    author = "cheyo",
    description = "Lottery for Sourcemod",
    url = ""
};
//Handle for global array (Sourcemod API)
new Handle:arr;

//List of commands + creating the array of users
public OnPluginStart() {
    RegConsoleCmd("sm_lottery", Command_Lottery, "");
    RegAdminCmd("sm_lotteryflush", Command_LotteryFlush, ADMFLAG_SLAY, "");
    arr = CreateArray(32);
}

//Removing all lottery entries, mostly used for test purposes
public Action:Command_LotteryFlush(client, args){
	int arraySize = GetArraySize(arr);
	for (int i = 0; i < arraySize; i++) {
    RemoveFromArray(arr, i);
	}
	PrintToServer("Lottery Entries have been flushed");
	PrintToChat(client, "Lottery Entries have been flushed");
}

//Lottery command (/lottery or /sm_lottery)
public Action:Command_Lottery(client, args) {
	
	//Checking if player is already registered
	if (IsPlayerRegistered(client)) {
		PrintToServer("Player is already Registered");
		PrintToChat(client, "You already rolled today");
		return Plugin_Handled;
	}else{
	
	//Random number generation (between 0 and 50)
	int lotteryNumber = GetRandomInt(0, 50);
    PrintToConsole(client, "You rolled %d", lotteryNumber);
    
    //Adding user in the array of participants (Resets every server restart (24h))
    RegisterParticipation(client);

	//Copying the player's name in a string
    new String:name[32];
    GetClientName(client, name, sizeof(name));
	
	//Generating another random number between 0 and 50
	//If the two numbers match, you win
    int lotteryRoll = GetRandomInt(0, 50);

    if (lotteryRoll == lotteryNumber) {
        PrintToChatAll("%s won the lottery today!", name);
        PrintToServer("%s WON THE LOTTERY !", name);
        PrintToServer("%s WON THE LOTTERY !", name);
        PrintToServer("%s WON THE LOTTERY !", name);
        PrintToServer("%s WON THE LOTTERY !", name);
        PrintToServer("%s WON THE LOTTERY !", name);
    } else {
        PrintToChat(client, "Unfortunately, you didn't win today");
    }
    return Plugin_Handled;
    }
}

void RegisterParticipation(client) {
	
    // Get the authID of the player
    new String:authid[32];
    GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
    
    //PushArrayString inserts the data at the end of an array (or the earliest available spot)
    PrintToServer("Data inserted at index %d", PushArrayString(arr, authid));
    PrintToServer("Player : %s", authid);
}

bool IsPlayerRegistered(client){
	
	//Retrieving Steam ID
	new String:authid[32];
    GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
    
    //FindStringInArray, returns -1 if no matching string is found
    int index = FindStringInArray(arr, authid);
    
    if (index != -1) {
        return true;
    } else {
        return false;
    }
}