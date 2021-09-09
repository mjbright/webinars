
#aws lambda list-functions |
#  jq -c '.Functions[] | { FunctionName, Runtime, LastModified, Timeout, MemorySize, Role, CodeSize, Description } ' 

echo "aws lambda list-functions | jq ..."
aws lambda list-functions |
  jq -c '.Functions[] | { fn:.FunctionName, run:.Runtime, lastmod:.LastModified, timeout:.Timeout, memsize:.MemorySize, role:.Role, size:.CodeSize, desc:.Description } ' 

