targetScope = 'subscription'
param location string = 'eastus'
param resourcePrefix string = 'EntProj'

param resourceGroupName string = '$(resourcePrefix)-rg'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : resourceGroup().name
  location : resourceGroup().location
}

module aks './aks-cluster.bicep' = {
  name: '${resourcePrefix}cluster'
  scope: resourceGroup().name
  params: {
    location: location
    clusterName: resourcePrefix
  }
}
