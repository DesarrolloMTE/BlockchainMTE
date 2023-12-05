/*
Business Blockchain Training & Consulting SpA. All Rights Reserved.
www.blockchainempresarial.com
email: ricardo@blockchainempresarial.com
*/

package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)
// SmartContract provides functions for controlling energy transactions
type SmartContract struct {
	contractapi.Contract
}

// EnergyTransaction describes basic details of what makes up an energy transaction
type EnergyTransaction struct {
	Producer string `json:"producer"`
	Consumer string `json:"consumer"`
	Amount   int    `json:"amount"` // Amount of energy in kilowatt-hours (kWh)
}

// Set creates a new energy transaction on the ledger
func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, transactionId string, producer string, consumer string, amount int) error {
	// Validaciones de sintaxis

	// Validaciones de negocio

	transaction := EnergyTransaction{
		Producer: producer,
		Consumer: consumer,
		Amount:   amount,
	}

	transactionAsBytes, err := json.Marshal(transaction)
	if err != nil {
		fmt.Printf("Marshal error: %s", err.Error())
		return err
	}

	return ctx.GetStub().PutState(transactionId, transactionAsBytes)
}

// Query retrieves an energy transaction from the ledger based on its ID
func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, transactionId string) (*EnergyTransaction, error) {
	transactionAsBytes, err := ctx.GetStub().GetState(transactionId)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if transactionAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", transactionId)
	}

	transaction := new(EnergyTransaction)

	err = json.Unmarshal(transactionAsBytes, transaction)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	return transaction, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error creating energytransaction chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting energytransaction chaincode: %s", err.Error())
	}
}