# Creazione e distribuzione di una rete blockchain su due host

***

## Installazione

Clona su entrambi gli host il progetto
```
$ git clone https://github.com/toni171/network-tesi
```

## Creazione dell'overlay network

Crea un overlay network che metta in comunicazione i due host

Sul primo host
```
$ docker swarm init --advertise-addr <indirizzo ip del primo host>
$ docker swarm join-token manager
```

Sul secondo host
```
$ <output del comando join-token manager> --advertise-addr <indirizzo ip del secondo host>
```

Sul primo host crea la rete first-network
```
$ docker network create --attachable --driver overlay first-network
```

## Avvio degli host

Su entrambi gli host accedere alla cartella `network-tesi/fabric-samples/network` e avviare gli host con il file `cli.sh`

Sul primo host
```
$ . ./cli.sh hostup 1
```

Sul secondo host
```
$ . ./cli.sh hostup 2
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

Per inizializzare il ledger si usa si usa il file `fabcar.sh`
```
$ . ./fabcar.sh init
```

Per invocare gli smart contract si usa il file `fabcar.sh`
```
$ . ./fabcar.sh createCar

$ . ./fabcar.sh queryCar

$ . ./fabcar.sh queryAllCars

$ . ./fabcar.sh changeCarOwner
```

## Disattivare gli host

Per spegnere i servizi sugli host si usa `cli.sh`
```
$ . ./cli.sh hostdown <numero dell'host da cui si avvia il comando>
```