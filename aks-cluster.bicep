targetScope = 'resourceGroup'
@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks101cluster'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string ='EntAKS'

@description('optional DNS prefix. Spcifying 0 will set  default disk size')
@minValue(0)
@maxValue(1023) 
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 2

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'adminuser'

//@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDh9O4Z5fGIt+wqL92zyvtbfSDGHvunjLK7q7m7INkdocdM/+QUYqjqspKR2u06YkkuZjU01ExEiCbHqFVrPaW3cmG5pcHEkJXwSddsEx3N340ix6EU10/6s3V7nNp8eGLGNN89a95Dm9+e7pv0OEdsQR5vT63ObBmoym+zpE+4ux7xsEuIt43b3sx217h09G71PQmxjlwJZozt4vDw86/0XpeuUqaiq6AUvvsDkx+SAhuP1cYGVvgYJCgeiwtipwd3o8koYkua/xDQmi9x2qugX10eb8fs4fpmEfJ/OxEuvwTtTumW6mmN2Hu6vApMPO/AEvmnDq4ASHhACoTHFBrQ2PjOO90jxAOO65wucUgcyUxo6uLOAUgXhMMj03R94ESkfHbgAL2IJsBHUdJYyZ8wIpF9kGYSkz5YB5EIhBBpbsQzb9ru4hr0D9jJ2/3Edv5oqQDNopABdaLLBO5Tha3C9YB1oCGxGPLBz/msuG/+NYvmM4HJXCu1rZJs0wsd10m19RbIu3Uj83+aH54yrTe+WX1/C6ByqkJYh0LxSWGelL38ARuwbltKoa1qCvcCYwTdaIrJYMRTpBGn0ElObeZ/YgVTVMGiG60/Qhpzjiph0JdbzycQB8mJTq0p0u6neKf3UMffEtDs6/0FOrwNdbbfcehG9MBxw0v3zEZpYyqOMw== sridhar@cc-e1d0e7c4-6ff5cc77b7-tv87n'

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn

