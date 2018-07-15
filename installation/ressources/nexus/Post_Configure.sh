postConfigureNexus(){
until $(curl --output /dev/null --silent --head --fail http://localhost:8081); do echo "wait nexus up"; sleep 5; done

curl -v --request POST --header 'content-type: application/json' --user "admin:admin123" --data "{  \"name\": \"adminpassword\",  \"type\": \"groovy\",  \"content\": \"security.securitySystem.changePassword('admin', args)\"}"  http://localhost:8081/service/rest/v1/script

curl -v -H "Content-Type: text/plain" -u "admin:admin123" http://localhost:8081/service/rest/v1/script/adminpassword/run -d "$PASSWORD"

curl -v -request POST --header 'content-type: application/json' --user "admin:$PASSWORD" --data "{\"name\": \"rawhosted\",  \"type\": \"groovy\",  \"content\": \"repository.createRawHosted(args);\"}"  http://localhost:8081/service/rest/v1/script

curl -v -H "Content-Type: text/plain" -u "admin:$PASSWORD" http://localhost:8081/service/rest/v1/script/rawhosted/run -d $REPOSITORY 

}
