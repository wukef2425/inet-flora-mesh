package flora.simulations;

import inet.node.inet.Router;
import inet.node.internetcloud.InternetCloud;
import flora.LoRaPhy.LoRaMedium;
import flora.LoraNode.LoRaNode;
import flora.LoraNode.LoRaGW;
import inet.node.inet.StandardHost;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.Eth1G;

@license(LGPL);
network RailwayLoRaStar
{
    parameters:
        int numberOfNodes = default(20);
        int numberOfGateways = default(2);
        double stationDistance = default(2000);
        @display("bgb=2400,900");
    submodules:
        loRaNodes[numberOfNodes]: LoRaNode {
            parameters:
                @display("p=50+(i%10)*110, 150+floor(i/10)*100");
        }
        loRaGW[numberOfGateways]: LoRaGW {
            parameters:
                @display("p=200+400*i,350;is=s");
        }
        LoRaMedium: LoRaMedium {
            @display("p=480,100");
        }
        networkServer: StandardHost {
            parameters:
                @display("p=100,60");
        }
        configurator: Ipv4NetworkConfigurator {
            parameters:
                assignDisjunctSubnetAddresses = false;
                @display("p=600,50");
        }
        internetCloud: InternetCloud {
            @display("p=350,60");
        }
        gwRouter0: Router {
            parameters:
                @display("p=300,300");
        }
        gwRouter1: Router {
            parameters:
                @display("p=700,300");
        }
        nsRouter: Router {
            @display("p=200,60");
        }
    connections allowunconnected:
        networkServer.ethg++ <--> Eth1G <--> nsRouter.ethg++;
        nsRouter.pppg++ <--> Eth1G <--> internetCloud.pppg++;
        internetCloud.pppg++ <--> Eth1G <--> gwRouter0.pppg++;
        gwRouter0.ethg++ <--> Eth1G <--> loRaGW[0].ethg++;
        internetCloud.pppg++ <--> Eth1G <--> gwRouter1.pppg++;
        gwRouter1.ethg++ <--> Eth1G <--> loRaGW[1].ethg++;
}
