## UBI image

- Fetch from brew the tar file, scp the file within the vm and import it within the ocp docker registry
```bash
tarName=ubi8-openjdk-11-15273-20200124145654.tar.xz
wget http://file.rdu.redhat.com/~jdowland/ubi8.2/$tarName

scp ubi8-openjdk-11-15273-20200124145654.tar.xz -i ~/.ssh/id_hetzner_snowdrop root@88.99.12.170:/tmp

ssh -i ~/.ssh/id_hetzner_snowdrop root@88.99.12.170
docker load -i $tarName
```
- Log on to the internal docker registry
```bash
docker login -u openshift -p $(oc whoami -t) 172.30.1.1:5000
```
- Next tag it to be able to use it within a namespace and push it
```bash
docker tag de3aac14333f 172.30.1.1:5000/test/ubi11
docker push 172.30.1.1:5000/test/ubi11
```

## Instructions

- To rsync the files to the pod
```bash
./krsync
```
- Next, compile the project imported
```bash
kc exec -c sb hal -i -t -- mvn compile -f /home/jboss/quarkus-demo/pom.xml -Dmaven.local.repo=/home/jboss/.m2/repository
```
