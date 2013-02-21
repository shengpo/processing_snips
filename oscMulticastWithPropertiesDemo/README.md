**oscMulticastWithPropertiesDemo** is to demonstrate how to use *OSC* + *multicast* + *oscP5's OscProperties object*<br/>
( mainly to show how to send osc via a multicast socket )
 
###important !
- oscMulticastWithPropertiesServer
- oscMulticastWithPropertiesClient0
- and oscMulticastWithPropertiesClient1
<br/>
**above three sketches need to be tested together !!**


###referenced and modified from:
- examples from oscP5 library
	- oscP5properties example
	- oscP5 multicast example
	- oscP5plug example

 
###notes:
- if you need more specific settings for your osc session, osc properties serves your needs. (from oscP5properties example)
- what is a multicast? 
	- one-to-many communication over an IP infrastructure in a network
	- more info: http://en.wikipedia.org/wiki/Multicast
- ip multicast ranges and uses:
	* 224.0.0.0 - 224.0.0.255 Reserved for special well-known multicast addresses.
	* 224.0.1.0 - 238.255.255.255 Globally-scoped (Internet-wide) multicast addresses.
	* 239.0.0.0 - 239.255.255.255 Administratively-scoped (local) multicast addresses.


###備註
這個osc multicast範例用於helloPlayer project<br/>
使helloPlayer的server跟client不需要在每次展出或使用時都要根據不同的使用狀況去設定IP跟osc port<br/>
希望透過multicast的使用，讓helloPlayer使用者(很有可能是較無技術背景的藝術家們)能容易上手

這個demo採用local範圍的multicast, <br/>
也就是說, 只要讓server跟client在同個區域網路下，便可以直接使用<br/>
除非遇到特殊狀況(例如：同個區網下，有另一個系統也使用了相同的multicast IP跟port，以及部份或全部相同的osc message)才需要另外更改multicast IP跟port的設定 (這個特殊狀況可能是：在同個網域下有兩套以上的helloPlayer server-clients架構。若是如此，每套helloPlayer server-clients架構彼此必須有不同的multicast IP跟port的設定)