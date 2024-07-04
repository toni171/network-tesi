function createCar() {
    read -p "Inserisci la targa della macchina da inserire : " targa
    read -p "Inserisci il costruttore della macchina da inserire : " costruttore
    read -p "Inserisci il modello della macchina da inserire : " modello
    read -p "Inserisci il colore della macchina da inserire : " colore
    read -p "Inserisci il proprietario della macchina da inserire : " proprietario
    comando="{\"Args\":[\"CreateCar\", \"${targa}\", \"${costruttore}\", \"${modello}\", \"${colore}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org${ORG_1}.example.com:${PORT_1} --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${ORG_1}.example.com/peers/peer0.org${ORG_1}.example.com/tls/ca.crt --peerAddresses peer0.org${ORG_2}.example.com:${PORT_2} --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${ORG_2}.example.com/peers/peer0.org${ORG_2}.example.com/tls/ca.crt -c "$comando"
    # rimosso --peerAddresses peer0.org3.example.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt 
}

function queryCar() {
    read -p "Inserisci la targa della macchina da ricercare : " targa
    risposta=$(docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryCar\",\"${targa}\"]}")
    costruttore=$(echo $risposta | jq '.make' | tr -d '"')
    modello=$(echo $risposta | jq '.model' | tr -d '"')
    colore=$(echo $risposta | jq '.colour' | tr -d '"')
    proprietario=$(echo $risposta | jq '.owner' | tr -d '"')
    echo "${costruttore} ${modello} di ${proprietario} (${colore})"
}

function queryAllCars() {
    risposte=$(docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryAllCars\"]}")
    numero=$(echo $risposte | jq length)
    for (( i=0; i<$numero ; i++ )); 
    do
        costruttore=$(echo $risposte | jq ".[${i}].Record.make" | tr -d '"')
        modello=$(echo $risposte | jq ".[${i}].Record.model" | tr -d '"')
        colore=$(echo $risposte | jq ".[${i}].Record.colour" | tr -d '"')
        proprietario=$(echo $risposte | jq ".[${i}].Record.owner" | tr -d '"')
        echo "${costruttore} ${modello} di ${proprietario} (${colore})"
    done
}

function changeCarOwner() {
    read -p "Inserisci la targa della macchina di cui cambiare il proprietario : " targa
    read -p "Inserisci il nuovo proprietario della macchina : " proprietario
    comando="{\"Args\":[\"ChangeCarOwner\", \"${targa}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org${ORG_1}.example.com:${PORT_1} --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${ORG_1}.example.com/peers/peer0.org${ORG_1}.example.com/tls/ca.crt --peerAddresses peer0.org${ORG_2}.example.com:${PORT_2} --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${ORG_2}.example.com/peers/peer0.org${ORG_2}.example.com/tls/ca.crt -c "$comando"
    # rimosso --peerAddresses peer0.org3.example.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
}

function gestione(){
    if [ "${MODE}" == "createCar" ]; then
        createCar
    elif [ "${MODE}" == "queryCar" ]; then
        queryCar
    elif [ "${MODE}" == "queryAllCars" ]; then
        queryAllCars
    elif [ "${MODE}" == "changeCarOwner" ]; then
        changeCarOwner
    fi
}

function messaggio(){
    echo "Non tutti i ledger sincronizzati. Non ancora possibile eseguire smart contract."
}

MODE=$1

info1=$(docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 -e CORE_PEER_LOCALMSPID="Org1MSP" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt cli peer channel getinfo --channelID mychannel 2>/dev/null)
info2=$(docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp -e CORE_PEER_ADDRESS=peer0.org2.example.com:9051 -e CORE_PEER_LOCALMSPID="Org2MSP" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt cli peer channel getinfo --channelID mychannel 2>/dev/null)
info3=$(docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp -e CORE_PEER_ADDRESS=peer0.org3.example.com:11051 -e CORE_PEER_LOCALMSPID="Org3MSP" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt cli peer channel getinfo --channelID mychannel 2>/dev/null)
height1=$(echo ${info1:16} | jq '.height')
height2=$(echo ${info2:16} | jq '.height')
height3=$(echo ${info3:16} | jq '.height')

# echo "${height1} ${height2} ${height3}"

if [[ $height1 -ne "" ]] && [[ $height2 -ne "" ]] && [[ $height3 -ne "" ]]; then
    if [[ "$height1" == "$height2" ]] && [[ "$height1" == "$height3" ]]; then
        ORG_1="1"
        PORT_1="7051"
        ORG_2="2"
        PORT_2="9051"
        gestione
    else
        messaggio
    fi
else
    if [[ "$height1" == "" ]]; then
        if [[ "$height2" == "$height3" ]]; then
            ORG_1="3"
            PORT_1="11051"
            ORG_2="2"
            PORT_2="9051"
            gestione
        else
            messaggio
        fi
    elif [[ "$height2" == "" ]]; then
        if [[ "$height1" == "$height3" ]]; then
            ORG_1="3"
            PORT_1="11051"
            ORG_2="1"
            PORT_2="7051"
            gestione
        else
            messaggio
        fi
    else
        if [[ "$height1" == "$height2" ]]; then
            ORG_1="1"
            PORT_1="7051"
            ORG_2="2"
            PORT_2="9051"
            gestione
        else
            messaggio
        fi
    fi
fi

