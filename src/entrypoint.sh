#! /bin/bash
/usr/sbin/sshd
su - hadoop /bin/bash -c "ssh-keyscan -H localhost >> ~/.ssh/known_hosts"
su - hadoop /bin/bash -c "ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts"
su - hadoop /bin/bash -c "hdfs namenode -format"
su - hadoop /bin/bash -c "start-dfs.sh"
su - hadoop /bin/bash -c "start-yarn.sh"
su - hadoop /bin/bash -c "mr-jobhistory-daemon.sh start historyserver"
sleep 1
su - hadoop /bin/bash -c "hadoop fs -mkdir -p /user/hadoop"
su - hadoop /bin/bash -c "hadoop fs -ls /user"
/bin/bash
