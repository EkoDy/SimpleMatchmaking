# **MatchmakingQueue**

Provides access to a queue and all the functions to manage data/matchmaking.

## **General methods**
### **QueuePlayers**
The built in function to find a match for the given array of players.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">players: Object</td>
    <td>The array of the player(s) looking for a match.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">Success: bool</td>
    <td>Returns true if a match was found/created.<br>
        Returns false if the operation failed.</td>
  </tr>
  <tr>
    <td style="background-color: gray">Credentials: Object</td>
    <td>The dictionary containing the MatchId and the AccessCode of the match.</td>
  </tr>
</table>

<br>

### **CheckPlayerTeam**
This function can be used to retrieve a player's team, if they are in one.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">player: Player</td>
    <td>The player to retrieve the team of.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">Success: bool</td>
    <td>Returns true if the player's team was found.<br>
        Returns false if the operation failed or the player is not in a team.</td>
  </tr>
  <tr>
    <td style="background-color: gray">Team: String</td>
    <td>The retrieved team.</td>
  </tr>
</table>

<br>

### **CreateMatchAsync**
This function creates and publishes a new match instance returning the credentials of the new match. The function also supports an optional players parameter to automatically add players to the match before publishing.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">players: Object (optional)</td>
    <td>The array of the player(s) to be added to the match.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">Credentials: Object</td>
    <td>The dictionary containing the MatchId and the AccessCode of the new match.</td>
  </tr>
</table>


## **Core methods**
### **AddAsync**
This function compiles a server instance from the passed credentials and adds it to the queue returning the added server instance and the number of players in the match.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">credentials: Tuple</td>
    <td>The dictionary containing the MatchId and the AccessCode of the match.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">success: bool</td>
    <td>Returns true the operation was successful.<br>
        Returns false if the operation failed.</td>
  </tr>
  <tr>
    <td style="background-color: gray">newServer: Object</td>
    <td>The server instance added to the queue.</td>
  </tr>
  <tr>
    <td style="background-color: gray">numberOfPlayers: Object</td>
    <td>The number of players in the match.</td>
  </tr>
</table>

<br>

### **ReadAsync**
This function accepts a MatchId and returns the server instance in the queue, if there is one.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">matchId: String</td>
    <td>The indentifier string of the server.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">server: Object</td>
    <td>The server instance associated to the giver MatchId.</td>
  </tr>
  <tr>
    <td style="background-color: gray">numberOfPlayers: Number</td>
    <td>The number of players in the match.</td>
  </tr>
</table>

<br>

### **RemoveAsync**
This function accepts a MatchId and a callback function and returns the updates server instance and the player count.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">matchId: String</td>
    <td>The indentifier string of the server.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">success: bool</td>
    <td>Returns true the operation was successful.<br>
        Returns false if the operation failed.</td>
  </tr>
</table>

<br>

### **GetRangeAsync**
This function can be used to get a number of server instances from the queue. The amount returned is currently fixed to `10`. An optional players parameter can be passed to make the function ignore matches that don't have enough space for the players.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">players: Object (optional)</td>
    <td>The array of the player(s) to be added to the match.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">success: bool</td>
    <td>Returns true the operation was successful.<br>
        Returns false if the operation failed.</td>
  </tr>
  <tr>
    <td style="background-color: gray">servers: Tuple</td>
    <td>The array of the matches found by the function.</td>
  </tr>
</table>