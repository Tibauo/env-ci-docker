postConfigureGitlab(){

retour=$(docker ps -f name=gitlab-demo | grep gitlab-demo | awk '{ print $1}' )

until $(curl --output /dev/null --silent --head --fail http://localhost); do echo "wait gitlab up"; sleep 5; done

token=$(curl --silent /dev/null --request POST --header 'content-type: application/json' --data "{\"grant_type\":\"password\",\"username\":\"root\",\"password\":\"$PASSWORD\"}"  http://localhost/oauth/token | jq . | grep access_token | awk '{ print $2 }' | sed 's/"//g' )

sleep 5

token=${token::-1}

sleep 5

echo "Creation de l'utilisateur"
curl --silent --header "content-type: application/json"  --header "Authorization: Bearer $token" --data "{\"email\": \"$EMAIL\",\"username\": \"$USER\",\"name\": \"$USER\",\"password\": \"$PASSWORD\",\"skip_confirmation\":\"true\"}" http://localhost/api/v4/users/

sleep 5

user_id=$(curl --silent --header "content-type: application/json"  --header "Authorization: Bearer $token"  http://localhost/api/v4/users/ | jq . | grep -B 2 "username\": \"$USER" | sed 's/"//g' | grep id | awk '{gsub(/,$/,""); print $2}')


sleep 5

echo "creation du projet"
curl --silent --header 'content-type: application/json' --header "Authorization: Bearer $token" --data "{\"user_id\": $user_id,\"name\":\"demo\"}" http://localhost/api/v4/projects/user/$user_id
}
