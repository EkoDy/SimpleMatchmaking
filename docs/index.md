# **Introduction**

SimpleMatchmaking is a module built with ease of use and customizability in mind using ROBLOX's [MemoryStoreService](https://create.roblox.com/docs/it-it/reference/engine/classes/MemoryStoreService).
It works by publishing match instances to a SortedMap for easy and fast editing.
The module makes use of the behavior of the native UpdateAsync function to allow all servers to access the SortedMap instead of having one central server handle all the work.

!!! warning "Warning"
    SimpleMatchmaking has not been tested in a production environment. If you encounter any issue please let me know.

## **Methods**
### **GetQueue**
This function returns a [MatchmakingQueue](MatchmakingQueue.md) class with the provided name and options.<br>
Subsequent calls with the same name and options will return the same Queue.

!!! warning "Warning"
    Calling GetAsync multiple times with the same name but different options will cause issues such as having matches with different number of teams in the same queue.

**Parameters**
<table>
  <tr>
    <td style="background-color: gray">name: String</td>
    <td>The name of the queue.</td>
  </tr>
  <tr>
    <td style="background-color: gray">options</td>
    <td>The options needed to set the parameters of the queue and its behavior.</td>
  </tr>
</table>

**Result**
<table>
  <tr>
    <td style="background-color: gray">MatchmakingQueue</td>
    <td>The class that exposes access to the different functions useful to manage the data.</td>
  </tr>
</table>

<br>

### **NewOptions**
This function creates and returns a new [QueueOptions](QueueOptions.md) class.

**Parameters** <br>
no parameters needed.

**Result**
<table>
  <tr>
    <td style="background-color: gray">QueueOptions</td>
    <td>The class used to set all the different options to customize a queue.</td>
  </tr>
</table>