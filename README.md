**Multicast P2P**

1. Peer-to-Peer technology
**Peer-to-Peer** technology: all clients can send messages to all other clients in the group.

All clients in the **multicast** group have equal rights. Every client has the ability to exchange messages with other clients in the group

![](https://github.com/VNAPNIC/UDP-TCP-Flutter/blob/master/resouce/1.png)

**Image 1: Every client can exchange messages with other clients in the group**

The IP system supports the **multicast** group following **peer-to-peer** , allowing all devices on the network to send and receive packets whose destination is the **multicast** group address. Some coding factors are to prevent anonymous clients from receiving data in the group but there is still no way to receive authentication from clients about data

1. Group Address - IP Multicast group address

- **IP Multicast group address** is used by sender and receiver to send and receive data.

+ Sender uses the group address as the destination address for the packets.

+ Receiver uses the group address to notify the network they have received packets from the group

For example, the group address is 239.1.1.1. Sender will send data to the destination address which is 239.1.1.1. Receiver will notify the network that it has received the data sent from the address 239.1.1.1. Receiver must &quot;join&quot; to the address 239.1.1.1.

- **Internet Assigned Numbers Authority (IANA)** considers the range of Class D addresses as **Multicast** addresses. This group address spans a range from 254.0.0.0 to 239.255.255.255. This address range is only used as a group address or a destination address in **IP Multicast**. The source address of **multicast** packets is always the **unicast address.**
 - **Routers** and **switches** must have a method to distinguish **multicast** traffic from **unicast** traffic or **broadcast** traffic. This is done by assigning IP address, using Class D addresses from 224.0.0.0 to 239.255.255.255 for **multicast** only. Devices can quickly filter out **multicast** addresses by reading the 4 bits to the left of an address. These four bits of a **multicast** address are always 1110. Unlike the Class A, B and C address ranges, this class D address has no subnetting process. Therefore, there are 2 powers of 28 **multicast** group addresses taken from this class D. **Multicast** addresses represent a group, not a host.
 - In particular, the address range from 224.0.0.0 to 224.0.0.255 is used for protocols on the network. These network packets are not forwarded by **routers**. They are placed in local area networks (LAN) segments and have **Time To Live**** (TTL)**.
 
**Video**

[<img src="https://github.com/VNAPNIC/UDP-TCP-Flutter/blob/master/resouce/Skype_Video_Moment.jpg" width="50%">](https://youtu.be/Zfyp4kcoUUs)
