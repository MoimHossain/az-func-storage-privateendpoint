
# Secure Azure Functions and Storage example

This repository contains ```Bicep``` scripts that provisions the following:

- Virtual Network
  - Subnet for private endpoints
  - Subnet for PaaS resources
- Storage account (with private endpoints)
  - Private endpoints for ```blob```, ```queue```, ```file``` and ```table``` sub-resources
- Creates private DNS zones for all 4 four private endpoints listed above (i.e. ```blob```, ```queue```, ```file``` and ```table```)
- Creates a Function app (with EP1 service plan) 
  - Function is VNet integrated for outbound traffics

## How to deploy

You can deploy the consolidated bicep file located into the ```infrastructure``` directory. 

Using Azure CLI:

```
az deployment group create --resource-group 'trojan-resources'  --template-file .\all.bicep
```

## Caveat
It may take 5-10 mins after a successfull deployment when you can deploy code into the function app (as the private endpoint, private DNS configurations are not immediately ready for operation). 