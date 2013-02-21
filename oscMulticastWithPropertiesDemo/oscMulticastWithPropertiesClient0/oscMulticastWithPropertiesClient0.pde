/*******************************************
 This sketch is to demonstrate how to use OSC + multicast + oscP5's OscProperties object
( mainly to show how to send osc via a multicast socket )
 
####importtant !
oscMulticastWithPropertiesServer, oscMulticastWithPropertiesClient0 and oscMulticastWithPropertiesClient1
need to be tested together !!


 referenced and modified from:
 - examples from oscP5 library
         . oscP5properties example
         . oscP5 multicast example
         . oscP5plug example

 
 notes:
 - if you need more specific settings for your osc session, osc properties serves your needs. (from oscP5properties example)
 - what is a multicast? 
         . one-to-many communication over an IP infrastructure in a network
         . more info: http://en.wikipedia.org/wiki/Multicast
 - ip multicast ranges and uses:
         * 224.0.0.0 - 224.0.0.255 Reserved for special well-known multicast addresses.
         * 224.0.1.0 - 238.255.255.255 Globally-scoped (Internet-wide) multicast addresses.
         * 239.0.0.0 - 239.255.255.255 Administratively-scoped (local) multicast addresses.
 
 
 Author: Shen, Sheng-Po (http://shengpo.github.com)
 Test Environment: Processing 2.0b7
 Date:   2013.02.21
 License: CC BY-SA 3.0
 *******************************************/


import oscP5.*;
import netP5.*;

OscP5 oscP5 = null;
int serverValue = -1;


void setup() {
        size(400, 200);

        /* create a new osc properties object */
        OscProperties properties = new OscProperties();

        /* set a default NetAddress. sending osc messages with no NetAddress parameter 
         * in oscP5.send() will be sent to the default NetAddress.
         */
        properties.setRemoteAddress("239.0.0.1", 7777);

        /* the port number you are listening for incoming osc packets. */
        properties.setListeningPort(7777);

        //to use a multicast socket
        properties.setNetworkProtocol(OscProperties.MULTICAST);        

        /* Send Receive Same Port is an option where the sending and receiving port are the same.
         * this is sometimes necessary for example when sending osc packets to supercolider server.
         * while both port numbers are the same, the receiver can simply send an osc packet back to
         * the host and port the message came from.
         */
        properties.setSRSP(OscProperties.ON);

//        /* set the datagram byte buffer size. this can be useful when you send/receive
//         * huge amounts of data, but keep in mind, that UDP is limited to 64k
//         */
//        properties.setDatagramSize(1024);

        /* initialize oscP5 with our osc properties */
        oscP5 = new OscP5(this, properties);    

        /* print your osc properties */
        println(properties.toString());
        
        //add plug
        oscP5.plug(this, "toClient", "/toClient");
        
        PFont myFont = createFont("Georgia", 32);
        textFont(myFont);
}



void mousePressed() {
        OscMessage myMessage = new  OscMessage("/toServer");
        myMessage.add("client 0");
        myMessage.add((int)random(100));

        /* send the osc message to the default netAddress, set in the OscProperties above.*/
        oscP5.send(myMessage);
}


void draw() {
        background(100);

        text("[client 0]", 50, height/2-32);
        if(serverValue >= 0){
                text("from : server", 10, height/2);
                text("value : " + serverValue, 10, height/2+32);
        }else{
                text("from : ", 10, height/2);
                text("value : ", 10, height/2+32);
        }
}


void toClient(int value){
        serverValue = value;
}
