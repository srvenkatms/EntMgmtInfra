targetScope = 'subscription'
param location string = 'eastus'
param resourcePrefix string = 'EntProj'

param resourceGroupName string = '${resourcePrefix}-rg'
param acrName string = '${resourcePrefix}acr'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name : resourceGroupName
  location : location
}
module acr './acr-aks.bicep' = {
  name: '${resourcePrefix}acr'
  scope: rg
  params: {
    location: location
    acrName: acrName
  }
}
module aks './aks-cluster.bicep' = {
  name: '${resourcePrefix}cluster'
  scope: rg
  params: {
    location: location
    clusterName: resourcePrefix
  }
}
