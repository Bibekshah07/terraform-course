FROM jenkins/jenkins:lts

# Skip initial setup
ARG JAVA_OPTS
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

# Install plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

# Provide inital Jenkins setup
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

#modify script securtiy for SeedJob
COPY security.groovy $JENKINS_HOME/init.groovy.d/security.groovy

#install packages
USER root
RUN apt-get update
RUN apt-get -y install openssl dnsutils

#become unprivileged user again
User jenkins
