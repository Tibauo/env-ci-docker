FROM jenkins/jenkins
USER root
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
COPY files/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY files/plugin.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN apt-get update \
    && apt-get install -y curl vim python-pip git 

RUN cd /root/ &&\
    git clone https://github.com/openstack-infra/jenkins-job-builder.git &&\
    pip install pyyaml pbr python-jenkins setuptools ordereddict stevedore fasteners jinja2 &&\
    cd jenkins-job-builder &&\
    python setup.py install

COPY files/gitconfig /var/jenkins_home/hudson.plugins.git.GitSCM.xml
COPY files/ci.yaml /root/jenkins-job-builder/ci.yaml


COPY files/scripts/ /root/jenkins-job-builder/scripts/
COPY files/jjb.sh /jjb.sh
