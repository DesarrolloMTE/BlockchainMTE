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

// Datos de cada organizacion 
type DatosOrganizaciones struct {
	IdOrg       int     `json:"id"`
	Nombre      string  `json:"nombre"`
	Contribucion float64 `json:"contribucion"`
	Iteraccion  int     `json:"iteraccion"`
}

// Datos del contrato
type Contrato struct {
	TotalIteraciones int               `json:"totalIteracciones"`
	Promedio         float64           `json:"promedio"`
	Total            float64           `json:"totalAportado"`
	Pedido           float64           `json:"Pedido"`
	Organizaciones   []DatosOrganizaciones `json:"Organizaciones"`
}

// Set crea una nueva transacción de energía en el libro de contabilidad
func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, transactionId string, Pedido float64) error {
	// Verificar si el contrato ya existe
	exists, err := contratoExiste(ctx, transactionId)
	if err != nil {
		return fmt.Errorf("Error al verificar la existencia del contrato: %s", err.Error())
	}

	// Si el contrato ya existe, lanzar un error
	if exists {
		return fmt.Errorf("El contrato con ID %s ya existe", transactionId)
	}

	// Crear el contrato si no existe
	transaction := Contrato{
		TotalIteraciones: 0,
		Promedio:         0,
		Total:            0,
		Pedido:           Pedido,
		Organizaciones: []DatosOrganizaciones{
			{IdOrg: 10001, Nombre: "Udenar", Contribucion: 0, Iteraccion: 0},
			{IdOrg: 10002, Nombre: "Mariana", Contribucion: 0, Iteraccion: 0},
			{IdOrg: 10003, Nombre: "Cooperativa", Contribucion: 0, Iteraccion: 0},
			{IdOrg: 10004, Nombre: "HDepartamental", Contribucion: 0, Iteraccion: 0},
			{IdOrg: 10005, Nombre: "Cesmag", Contribucion: 0, Iteraccion: 0},
		},
	}

	// Convertir la transacción a bytes
	transactionAsBytes, err := json.Marshal(transaction)
	if err != nil {
		return fmt.Errorf("Error al convertir la transacción a bytes: %s", err.Error())
	}

	// Guardar la transacción en el bloque
	if err := ctx.GetStub().PutState(transactionId, transactionAsBytes); err != nil {
		return fmt.Errorf("Error al guardar la transacción en el estado del mundo: %s", err.Error())
	}
	return nil
}

// Contribute permite que una organización contribuya con energía a una transacción existente
func (s *SmartContract) Contribute(ctx contractapi.TransactionContextInterface, transactionId string, IdOrg int, Contribucion float64) error {

	// Verificar si el contrato existe
	exists, err := contratoExiste(ctx, transactionId)
	if err != nil {
		return fmt.Errorf("Error al verificar la existencia del contrato: %s", err.Error())
	}

	// Si el contrato no existe, lanza un error
	if !exists {
		return fmt.Errorf("El contrato con ID %s no existe", transactionId)
	}

	transactionAsBytes, err := ctx.GetStub().GetState(transactionId)
	if err != nil {
		return fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	transaction := new(Contrato)
	err = json.Unmarshal(transactionAsBytes, transaction)
	if err != nil {
		return fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	// Validar que la transacción esté pendiente
	if transaction.Pedido < transaction.Total {
		return fmt.Errorf("Invalid transaction status or producer already assigned")
	}

	// Validar que la contribución no supere el límite establecido por la organización
	if Contribucion+transaction.Total > transaction.Pedido {
		return fmt.Errorf("Contribution amount exceeds the limit set by organization %d", transaction.IdOrg)
	}

	// Actualizar la contribución de la organización en el contrato
	for i, org := range transaction.Organizaciones {
		if org.IdOrg == IdOrg {
			transaction.Organizaciones[i].Contribucion += Contribucion
			transaction.Organizaciones[i].Iteraccion++
			break
		}
	}

	// Actualizar el promedio de contribucion
	transaction.Promedio = transaction.Total / float64(len(transaction.Organizaciones))

	// Actualizar el total aportado en el contrato
	transaction.Total += Contribucion

	// Incrementar la variable Iteracion en el contrato
	transaction.TotalIteraciones++

	// Convertir la transacción actualizada a bytes
	updatedTransactionAsBytes, err := json.Marshal(transaction)
	if err != nil {
		return fmt.Errorf("Error al convertir la transacción a bytes: %s", err.Error())
	}

	// Guardar la transacción actualizada en el estado del mundo
	if err := ctx.GetStub().PutState(transactionId, updatedTransactionAsBytes); err != nil {
		return fmt.Errorf("Error al guardar la transacción en el estado del mundo: %s", err.Error())
	}

	return nil
}

// Query retrieves an energy transaction from the ledger based on its ID
func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, transactionId string) (*Contrato, error) {
	transactionAsBytes, err := ctx.GetStub().GetState(transactionId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if transactionAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", transactionId)
	}

	transaction := new(Contrato)
	err = json.Unmarshal(transactionAsBytes, transaction)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error. %s", err.Error())
	}

	return transaction, nil
}

// verifica la existencia de un contrato
func contratoExiste(ctx contractapi.TransactionContextInterface, transactionId string) (bool, error) {
	// Intentar obtener el estado del mundo para la clave transactionId
	contratoAsBytes, err := ctx.GetStub().GetState(transactionId)
	if err != nil {
		return false, fmt.Errorf("Error al leer el estado del mundo: %s", err.Error())
	}

	// Verificar si el valor asociado a transactionId es diferente de nil
	return contratoAsBytes != nil, nil
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
