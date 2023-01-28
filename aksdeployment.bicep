targetScope = 'subscription'
param name string = 'entproj-us'
param location string = 'eastus'
param resourcePrefix string = 'entproj'

param resourceGroupName string = '$(resourcePrefix)-rg'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : name
  location : location
}

module aks './aks-cluster.bicep' = {
  name: '${resourcePrefix}cluster'
  scope: rg
  params: {
    location: location
    clusterName: resourcePrefix
  }
}
