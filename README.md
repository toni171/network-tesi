# Creazione e distribuzione di una rete blockchain su due host

***

## Installazione

Clona su entrambi gli host il progetto
```
$ git clone https://github.com/toni171/network-tesi
```

## Creazione dell'overlay network

Crea un overlay network che metta in comunicazione i tre host

Sul primo host
```
$ docker swarm init --advertise-addr <indirizzo ip del primo host>
$ docker swarm join-token manager
```

Sul secondo e sul terzo host
```
$ <output del comando join-token manager> --advertise-addr <indirizzo ip del secondo host>
```

Sul primo host crea la rete first-network
```
$ docker network create --attachable --driver overlay first-network
```

## Avvio degli host

Sugli host accedere alla cartella `network-tesi/fabric-samples/network` e avviare gli host con il file `cli.sh`

Sul primo host
```
$ . ./cli.sh hostup 1
```

Sul secondo host
```
$ . ./cli.sh hostup 2
```

Sul terzo host
```
$ . ./cli.sh hostup 3
```

## Avvio della rete

Avviare il canale con il file `cli.sh` (su un host qualsiasi)
```
$ . ./cli.sh networkup
```

## Distribuzione del chaincode

Lanciare il comando di installazione del chaincode `fabcar` (da un host qualsiasi)
```
$ . ./cli.sh installCC
```

Copiare il `packageID` dall'output del comando precedente (si tratta della stringa a partire da dopo i due punti)
Lanciare il comando di distribuzione del chaincode `fabcar`
```
$ . ./cli.sh deployCC <packageID>
```

## Invocazione smart contract

Per invocare gli smart contract si usa il file `fabcar.sh`
```
$ . ./fabcar.sh createCar

$ . ./fabcar.sh queryCar

$ . ./fabcar.sh queryAllCars

$ . ./fabcar.sh changeCarOwner
```

## Spegenere (temporaneamente) un host

Per spegnere i peer e gli orderer su un host si usa `cli.sh`
```
$ . ./cli.sh hoststop <numero dell'host da cui si avvia il comando>
```

A differenza del comando `hostdown`, con `hoststop` non si vanno a spegnere i container del chaincode, consentendo si non doverlo reinstallare una volta fatto ripartire l'host.

## Riaggiungere alla rete

Per far ripartire un host spento con `hoststop`, prima dal terminale dell'host si inserisce `hostup` e poi sul terminale del primo host si digita 
```
$ . ./cli.sh hostresume <numero dell'host da aggiungere>
```

A differenza del comando `hostdown`, con `hoststop` non si vanno a spegnere i container del chaincode, consentendo si non doverlo reinstallare una volta fatto ripartire l'host.

## Spegnere gli host

Per spegnere i servizi sugli host si usa `cli.sh`
```
$ . ./cli.sh hostdown <numero dell'host da cui si avvia il comando>
```