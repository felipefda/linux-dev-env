#!/usr/bin/env bash

source ./env.conf

set -v
set -e


#tar -xvzf oracle/oracle_home.tar.gz -C $rootpath
cd $rootpath/Oracle_Home/oracle_common/plugins/maven/com/oracle/maven/oracle-maven-sync/12.2.1
mvn install:install-file -DpomFile=oracle-maven-sync-12.2.1.pom -Dfile=oracle-maven-sync-12.2.1.jar
mvn com.oracle.maven:oracle-maven-sync:push -DoracleHome=$rootpath/Oracle_Home/.
