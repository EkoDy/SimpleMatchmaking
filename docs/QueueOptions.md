# **QueueOptions**

The QueueOptions class is returned by the newOptions method and it contains all the parameters needed to customize a queue.

!!! tip
    The server size should be bigger than the maximum amount of players you are planning to have in a single match to allow possible spectators and moderators to join the match.

## **Properties**
**MatchPlaceId** : number <br>
The PlaceId where the players will be teleported to.
***
**NumberOfTeams** : number <br>
The number of teams in the match.
***
**MaxPlayersPerTeam** : number <br>
The maximum number of players in a team.
***
**MatchExpirationTime** : number <br>
`Optional` <br>
The time in seconds the match will be available in the queue before being automatically deleted by ROBLOX's servers.

Default value: 600 (5 minutes)
***
**UseCustomTeleporting** : number <br>
`Optional` <br>
This setting can be used to chose if the module should use the bult-in teleport function or let you handle teleporting and skip the built-in function entirely.

Default value: true