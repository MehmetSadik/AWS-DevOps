1. k run test --image=nginx $do > test-pod.yaml
apiVersion: v1
kind: Pod
......
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
  nodeSelector:
    kubernetes.io/hostname: controlplane

2. k scale deployment test --replicas 2

3. k run am-i-ready --image=nginx:1.16.1-alpine --labels="id=cross-server-ready"

4. kubectl get pod -A --sort-by=.metadata.creationTimestamp

5. pv and pvc      # pod with pvc  # Configure a Pod to Use a PersistentVolume
---
kind: PersistentVolume
apiVersion: v1
metadata:
 name: safari-pv
spec:
 capacity:
  storage: 2Gi
 accessModes:
  - ReadWriteOnce
 hostPath:
  path: "/Volumes/Data"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: safari-pvc
  namespace: project-tiger
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
     storage: 2Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: safari
  name: safari
  namespace: project-tiger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: safari
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: safari
    spec:
      volumes:                                      # add
      - name: data                                  # add
        persistentVolumeClaim:                      # add
          claimName: safari-pvc                     # add
      containers:
      - image: httpd:2.4.41-alpine
        name: container
        volumeMounts:                               # add
        - name: data                                # add
          mountPath: /tmp/safari-data               # add

6.  kubectl top node

    kubectl top pod --containers=true

7. Check how the controlplane components kubelet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the controlplane node. Also find out the name of the DNS application and how it's started/installed on the controlplane node.

# /opt/course/8/controlplane-components.txt
kubelet: process
kube-apiserver: static-pod
kube-scheduler: static-pod
kube-controller-manager: static-pod
etcd: static-pod
dns: pod coredns

8. cd /etc/kubernetes/manifests/  --> kubertenes manifest files

9.  k -n project-hamster create sa processor
    k -n project-hamster create role processor --verb=create --resource=secrets,configmaps 
    k -n project-hamster create rolebinding processor --role=processor --serviceaccount=project-hamster:processor

check -->

    k -n project-hamster auth can-i create secret \
    --as system:serviceaccount:project-hamster:processor
    yes

    ➜ k -n project-hamster auth can-i create configmap \
    --as system:serviceaccount:project-hamster:processor
    yes

10. k api-resources --namespaced -o name

11. - `ssh cluster1-node2`
    - `crictl ps` 
    Kubernetes ortamında çalışan container'ların listesini göstermek için kullanılır. crictl (Container Runtime Interface CLI), Kubernetes container runtime'larıyla etkileşim kurmak için kullanılan bir araçtır.

12. - `ps aux` komutu, Unix ve Unix-benzeri işletim sistemlerinde çalışan tüm süreçleri (processleri) göstermek için kullanılan bir terminal komutudur. 
    - `service kubelet status` serviclerin statusunu ogreniyoruz
    - `service kubelet start`
    - `whereis kubelet`
  
13. !!!! !!! backup icin onemli sertifika pathlerini ogrenmenin en kisa yolu 
    - `cat /etc/kubernetes/manifests/etcd.yaml | grep file`

14. master ve worker nodelari upgrade et
    - k drain <node-name> --ignore-daemonsets
    - apt update
    - apt install kubeadm=<version>
    - kubeadm upgrade apply <version> (burada versiyonun - ve sonrasini yazmiyoruz, or; 1.29.1 )
    - apt install kubelet=<version>
    - systemctl restart kubelet
    - k uncordon <node-name>
  
15. siralamayi tersine cevirmek isin `tac` kullanabiliriz. Ornegin "list all pods wich sorted by their AGE in ASCENDING order." sorusunda asagidaki komutu kullanabiliriz.
    - k get pod -A --sort-by=.metedata.creationTimestamp | tac


16. Kullanisli web linkler

  - https://k21academy.com/docker-kubernetes/cka-ckad-exam-questions-answers/
  - https://www.itexams.com/exam/CKA
  - https://www.youtube.com/watch?v=o_7jlMBHFFA
  - https://www.youtube.com/watch?v=udA3OWkmMUY


test ssh key