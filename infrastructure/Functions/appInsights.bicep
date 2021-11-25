param location string
param name string
param resourceTags object 

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'
  tags: resourceTags
  properties: {
    Application_Type: 'web'
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
