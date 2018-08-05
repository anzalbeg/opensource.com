
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/mychannel1/chaincodes/mycc1 \
  -H "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjQ4NDYyNDgsInVzZXJuYW1lIjoiZGF2aWQiLCJvcmduYW1lIjoib3JnMSIsImlhdCI6MTUyNDgxMDI0OH0.J4TomD1gBguaQsz6QkuOdkXj91J6JDpNqB3x28B9CMU" \
  -H "content-type: application/json" \
  -d '{"fcn":"createPolicy","args":["{ \"addressLine1\": \"addressLineCalifonia\", \"addressLine2\": \"addressLineCalifonia22\", \"city\": \"city22255\", \"propertyId\": \"FA-P12\", \"county\": \"county66226\", \"organizationName\": \"organizationName666\", \"relatedPropertyId\": \"relatedPropertyId666\", \"state\": \"state666\", \"taxID\": \"taxID666\", \"zip\": \"zip666\", \"policies\": [ {  \"propertyId\": \"FA-P12\", \"effectiveDate\" : \"2006-01-02T15:04:05Z\", \"effectiveDateText\": \"effectiveDateText666\", \"exceptions\": \"exceptions666\", \"policyId\": \"FA-P12-PO1\", \"insuredNames\": \"insuredNamesFAII\", \"issueDate1\": \"2006-01-02T15:04:05Z\", \"issuingCompanyName\": \"issuingCompanyNameFAII\",\"legalDescrition\": \"legalDescritioFAIII\", \"liabilityAmount\": \"liabilityAmountFAIII\", \"organizationKey\": \"organizationKeyFAIII\", \"organizationName\": \"organizationNameFAIII\", \"policyKingdom\": \"policyKingdomFAIII\", \"policyName\": \"policyNameFAIII\", \"policyNumber\": \"policyNumberFAIII\", \"policyImage\": { \"fileName\": \"fileNameFAII\", \"format\": \"formatFAIII\", \"policyId\": \"FA-P12-PO1\", \"documentIdHash\": \"FA-P12-PO1-D1\", \"fileSizeBytes\": 123665}}]}"]}'       
)
echo "Transacton ID is $TRX_ID"
#done
