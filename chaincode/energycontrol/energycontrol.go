/*
Contrato inteligente para el control de transacciones de energía
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
	Producer     string                   `json:"producer"`
	Consumer     string                   `json:"consumer"`
	Amount       int                      `json:"amount"` // Amount of energy in kilowatt-hours (kWh)
	Status       string                   `json:"status"` // Status of the transaction (e.g., "pending", "completed")
	Contributors map[string]int           `json:"contributors"` // Map of organization IDs to their contributions
	LimitOrgID   string                   `json:"limitOrgID"`    // Organization ID that sets the contribution limit
}

// Set creates a new energy transaction on the ledger
func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, transactionId string, consumer string, amount int, limitOrgID string) error {
	// Validaciones de sintaxis

	// Validaciones de negocio
	transaction := EnergyTransaction{
		Producer:     "", // El productor se determinará cuando se completen las contribuciones
		Consumer:     consumer,
		Amount:       amount,
		Status:       "pending",
		Contributors: make(map[string]int),
		LimitOrgID:   limitOrgID,
	}

	transactionAsBytes, err := json.Marshal(transaction)
	if err != nil {
		fmt.Printf("Marshal error: %s", err.Error())
		return err
	}

	return ctx.GetStub().PutState(transactionId, transactionAsBytes)
}

// Contribute permite que una organización contribuya con energía a una transacción existente
func (s *SmartContract) Contribute(ctx contractapi.TransactionContextInterface, transactionId string, producer string, amount int) error {
	transactionAsBytes, err := ctx.GetStub().GetState(transactionId)
	if err != nil {
		return fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if transactionAsBytes == nil {
		return fmt.Errorf("%s does not exist", transactionId)
	}

	transaction := new(EnergyTransaction)
	err = json.Unmarshal(transactionAsBytes, transaction)
	if err != nil {
		return fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	// Validar que la transacción esté pendiente y que el productor no esté asignado
	if transaction.Status != "pending" || transaction.Producer != "" {
		return fmt.Errorf("Invalid transaction status or producer already assigned")
	}

	// Validar que la contribución no supere el límite establecido por la organización
	if amount+transaction.Contributors[producer] > transaction.Amount {
		return fmt.Errorf("Contribution amount exceeds the limit set by organization %s", transaction.LimitOrgID)
	}

	// Actualizar la transacción con la contribución
	transaction.Contributors[producer] += amount

	// Si la suma de las contribuciones iguala o supera la cantidad, marcar la transacción como "completada"
	if sumContributions(transaction.Contributors) >= transaction.Amount {
		transaction.Producer = producer
		transaction.Status = "completed"
	}

	transactionAsBytes, err = json.Marshal(transaction)
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

// sumContributions suma las contribuciones de todas las organizaciones
func sumContributions(contributors map[string]int) int {
	sum := 0
	for _, amount := range contributors {
		sum += amount
	}
	return sum
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