createJob(){
echo "Creation du job"
sed 's/demo/'"$USER"'/g' $DIR/installation/ressources/jenkins/template/job-templates.yaml > $DIR/installation/ressources/jenkins/docker/files/scripts/job-templates.yaml
sed 's/demo@demo.com/'"$EMAIL"'/g' $DIR/installation/ressources/jenkins/template/defaults.yaml > $DIR/installation/ressources/jenkins/docker/files/scripts/defaults.yaml
sed 's/passdemo/'"$PASSWORD"'/g' $DIR/installation/ressources/jenkins/template/package.sh > $DIR/installation/ressources/jenkins/docker/files/scripts/package.sh
sed 's/demo@demo.com/'"TTTTTTT"'/g' $DIR/installation/ressources/jenkins/template/test.sh > $DIR/installation/ressources/jenkins/docker/files/scripts/test.sh

}

postConfigureJenkins(){
until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do echo "wait jenkins up"; sleep 5; done
tmp=`sed "s/\"id\": \"\"/\"id\": \"$USER\"/g" $DIR/installation/ressources/jenkins/password.json | sed "s/\"username\": \"\"/\"username\": \"$USER\"/g"  | sed "s/\"password\": \"\"/\"password\": \"$PASSWORD\"/g"`

curl -X POST 'http://localhost:8080/credentials/store/system/domain/_/createCredentials' --data-urlencode "$tmp"
docker exec -t ci_jenkins_1 /bin/bash -c "bash /jjb.sh"
docker exec -t ci_jenkins_1 /bin/bash -c "cd /root/jenkins-job-builder/ && jenkins-jobs --conf jjb.ini update ci.yaml"

}
