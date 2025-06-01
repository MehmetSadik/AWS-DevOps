1. Certificate Authority (CA)
    - Apiserver cert (server and client cert)https://www.google.com/imghp?hl=en&tab=ri&authuser=0&ogbl
    - Kubelet cert (server and client cert)
    - Scheduler cert (server cert)

![alt text](<Screenshot 2024-10-11 at 14.10.15.png>)

2. User certificate signing

3. `grep -r "somethings"` --> searches all files in the current directory to find "somethings." .

4. 08:32:01 Runtime Security - Behavioral Analytics at host and container level --> syscal, falcon, strace etc. in youtube video --> It is very importent !!!

5. Soru 7

    1. Step; Change kubelet-config with `k -n kube-system edit cm kubelet-config` command.
    2. Step; Update Control Plane Kubelet-Config `kubeadm upgrade node phase kubelet-config`

Soru 8 de kaldim --> 10.10.2024

Soru 9 de kaldim --> 25.12.2024

- AppArmor profiles can be specified at the pod level or container level. The container AppArmor profile takes precedence over the pod profile.

Soru 11 de kaldim --> 06.01.2025

- kubernetes documentation --> Encrypting Confidential Data at Rest

Soru 12 --> 11.01.2025

- curl https://kubernetes.default/api/v1/namespaces/default/secrets -H "Authorization: Bearer $(cat /run/secrets/kubernetes.io/serviceaccount/token)" -k

Soru 13 --> 11.01.2025

- Network Policy to IP, IP blocks form is importent, as a 0.0.0.0/0 or a specific 196.32.78.12/32

Soru 14 --> 11.01.2025

- crictl ps --> to find container id
- crictl inspect <container-id> | grep pid --> to find pid number
- strace -p <pid> --> to find syscalls (system calls)

Sour 15 --> 11.01.2025

- k create secret tls --help

Soru 17 de kaldim --> 12.01.2025

Soru 20 de kaldim --> 12.01.2025

Soru 23 de kaldim Son soru --> 13.01.2025


- Tekrar

soru1 --> secret'i decode etmek ve json formatinda sorgulamak icin asagidaki komut faydali, ya da kopyala/yapistir yapabiliriz.

    - k config view --raw -ojsonpath="{.users[2].user.client-certificate-data}" | base64 -d > /opt/course/1/cert

soru2 --> falco, syscall loglarini tutan ve bunlari ozellestirebildigimiz bir tool, iligili alanlara asagidaki linkten ulasilabilir.

    - https://falco.org/docs/reference/rules/supported-fields/
    - cat /var/log/syslog | grep falco | grep shell
    - cp falco_rules.yaml falco_rules.local.yaml --> bu sekilde local'e kopyalayarak local file uzerinden degisiklik yapmak daha mantikli.
    - fields'ler key=value seklinde kayitedilebiliyor ama soruda key olmadan da isteyebilir
        - %evt.time,%container.id,%container.name,%user.name

soru3 --> https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

    - bu adresteki opsiyonlari kullaniyoruz, sinirlama vs icin

soru4 --> Enforce Pod Security Standards with Namespace Labels

    - https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/
    - https://kubernetes.io/docs/concepts/security/pod-security-standards/#policy-instantiation

soru5 --> kube-bench run --targets=master --check='1.3.2'

soru6 --> sha512sum <binary-file-name>

soru7 --> burada kaldim 19.01.2025

   - Burada dokumantasyon onemli ilgili sayfayi bularak buradan yardim alinabilir.

   - https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/#applying-kubelet-configuration-changes  

   1. Step; Change kubelet-config with `k -n kube-system edit cm kubelet-config` command. 
   2. Step; Update Control Plane Kubelet-Config `kubeadm upgrade node phase kubelet-config`

soru8 --> Cilium dokumantasyondaki orneklere ve soru cevabina tekrar bakmak lazim

  - https://docs.cilium.io/en/latest/security/policy/language/#policy-examples

soru9 --> AppArmor --> https://kubernetes.io/docs/tutorials/security/apparmor/#setting-up-nodes-with-profiles

  - Kubernetes dokumanindaki ornekte bir apparmor profilini nasil install (etkinlestirecegin) edecegin anlatiliyor.
  - profile ismi onemli, verilen profile dosyasi icerisinde `profile` kelimesinden hemen sonra geliyor.

soru10 --> Container Runtime Sandbox gVisor
  
  - Burada onemli olan Container RuntimeClass olusturmak ve bunu pod assign etmek.

soru11 -->  Secrets in ETCD

  - Bununla ilgili komutlar ve duzenlemeler `secret etcd` yazinca dogrudan cikiyor. Bu dokumantasyonu iyi incelemek lazim.
  - https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/

soru12 --> Accessing the Kubernetes API from a Pod - Secret'lara ulasma

  - https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/
  - Oncelikle pod iceriklerindeki volum ya da env secretlara bakmak gerekiyor
  - Son olarak pod icerisinden API kullanilarak secretlar'a ulasilabilir ama ilgili role ve rolebinding leri olsuturmak gerekiyor

soru13 --> Restrict access to Metadata Server

  egress:
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
        - 192.168.100.21/32

  - bu sekilde `except` ile IP'yi haric tutabiliyoruz, bu kisim onemli, dokumanda ilk ornekte var
  - https://kubernetes.io/docs/concepts/services-networking/network-policies/

 soru 13'u yaptim ama iyi anlamam gerekiyor, ozellikle " Once one egress rule exists, all other egress is forbidden, same for ingress."

  - Bu sekilde from altinda iki element olursa AND anlamina geliyor.
  ...
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          user: alice
    - podSelector:
        matchLabels:
          role: client
  ...

  - Eger tek element altinda iki veya daha fazla duzenleme varsa OR anlamina geliyor
  ...
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          user: alice
      podSelector:
        matchLabels:
          role: client
  ...

soru14 --> Bir pod'daki Syscalls lari bulabilmek icin sirasi ile asagidaki komutlari kullaniyoruz.

  - crictl ps
  - crictl inspect <image-id> | grep "pid"
  - strace -p <pid>

soru15 --> curl -kv https://<host-name>:<port>/<path>

soru16 --> 

  - k create secret tls tls-secret --key tls.key --cert tls.crt
  - eger komutu hatirlamazsan asagidaki komutu kullan
  - k create secret tls --help

soru17 --> dokuman auditing 

  - Audit konfigurasyonu kube-apiserver icerisinde saglaniyor
    - Policy ve loglarin bulundugu dosya volume olarak mount ediliyor
    - log-path/maxsize-backup gibi parametreler belirlenebiliyor
  - Son olarak policy'de eger bizden birsey isteniyor ise bu saglandiktan sonra diger tum loglarin tutulmasini engellemek icin;
    - level: None
    kullanilir.

soru18 --> SBOM

  - bom ile uretmek SBOM icin bom --help kullanilabilir
    - bom generate --image <image> --format json --output </my/file/path>(ciktiyi json formatinda istedigimiz yere kayitediyoruz)

  - trivy ile de SBOM uretebiliyoruz
    - trivy image --format cyclonedx(burada farkli formatlar belirleyebiliriz --help ile gorulebilir) --output /opt/course/18/sbom2.json <image>
    - trivy sbom </my/file/path> (burada da dogrudan bir sbom dosyasini tarayabiliyoruz)

soru19 --> Immutable Root FileSystem

  - read only file system yapmak icin security context parametrelerinden `readOnlyRootFilesystem` parametresini ture yapiyoruz, eger bizden writable dosya isterse bunun icin emtpty dir volume mount ediyoruz. Container ya da pood seviyesinde olabiliyor.
    spec:
      containers:
      - image: busybox:1.32.0
        name: busybox
        securityContext:                  
          readOnlyRootFilesystem: true    
        volumeMounts:                     
        - mountPath: /tmp                
          name: temp-vol                 
      volumes:                           
      - name: temp-vol                   
        emptyDir: {}                     

soru23'de kaldim




2. soruda 

falco sitesinden "Supported Fields for Conditions and Outputs" kismina bakmak gerekiyor
falco -U komutu onemli
crictl ps
crictl inspect <image-id> | grep "pod" komutlari onemli, bu sayede pod ve namespace'i gorebiliyoruz
falco da local dosyasi uzerinde calismak onemli, ana dosyada degisiklik yapma!!!!!


3. soruda 

kube api server manifestinden ilgili parametreyi silmen ya da degerini 0 yapman gerekiyor, bundan sonra kubernetes servis'in ip type'nin degismesi icin servisi silmen ONEMLI!!!!


4. dokumantan ilgili Pod Security Standard'da tiklayarak yaml formatinda gorebiliyorsun label olarak.

5. Soruyu anlayamadim, iyice anla ve komutlari iyi ogren

6. 

7. buna iyi bak, komutlari iyi anla burada --help komutu kullanilarak ilgili komut bulunabilir.

8. 




1. ingress, ssl redirect

2. create tls certificate "=" (komut icerisinde) olmamasi gerekiyor

3. cillium layer4, nginx-ingress ns'den gelen hepsine izin ver, dorpdd gibi bir ns vardi buradaki podlara, nginx-ingress'den gelen tum trafige izin ver, sonrada host'dan gelenler, extend policy aynisini, host olarak izin ver gibi birsey
  - bu dokumanda layer4 orneginde var, buraya iyice bak ve ornekler yap, ONEMLI !!!!

4. update node, ama kubeapi upgrade plan komutunu verdigimde /kubeamd.config bulunamadi diyor

5. deployment pod'u olusturulammamisti, bunu create et dediginide zaten seni securitycontext bolumu ile ilgili yonlendiriyor

6. networkpolicy ile ilgili bir soru vardi

7. addmission controller ve security context ile ilgili sorular vardi

8. kube-bench ile ilgili sorular vardi ama verdigi kodlar fail kisminda cikmiyordu

9. falco ile ilgili soru vardi ama komut ciktisinda hicbirsey goremedim ve uzun surdu. muhetemelen falco'yu start etmek gerekiyordu, bunun komutuna bak muhakkak.

10. kubeapi argumantlarin configurasyonlari vardi.

11. A isimli docker user'i deployment isimli grupdan kaldir diye bir soru vardi docker kullan diyordu, ama herhangi bir dosya vs yok???

12. sayfa icerisinde nasil kelime aratabiliyoruz, sinav sirasinda cok ihtiyacim oldu ama bulamadim maalesef

13. Automountserviceaccounttoken?

14. audit log

15. Kubelet authentication/authorization  --anonymous-auth=ture/false --authorization-mode=RBAC

16. pod securty context, allowPrivilegeEscalation, readOnlyRootFilesystem

17. 

---
# Crictl

- crictl ps -a
- crictl logs <container-id>

# Users

- kullaniciyi bir grupdan kaldirma

 - deluser <user-name> <group-name>

- Suspend a user account 

 - usermod -s /usr/sbin/nologin <user-name> (burada -s shell oluyor)

- Delete a user

 - userdel <user-name>

# Secure Kubelet

- Get kubelet config location --> `service kubelet status`

- `vim /var/lib/kubelet/config.yaml`

- authentication:
    anonymous:
      enabled: false (instead true)

- authorization:
    mode: Webhook (instead AlwaysAllow)

- readOnlyPort: 0 (instead 10255)

- `sevice kubelet restart`

# Falco
Asagidan falco'yu service olarak calistiriyoruz.

- apt-get install falco

- service falco status

- sevice falco start

!!! Eger Falco yuklu ise `falco` komutu kullandigimizda otomatik olarak run ediliyor. !!!

# Security

Bu kisma detayli bir sekilde bak muhakkak!!

https://kubernetes.io/docs/tutorials/security/

!!! Secure Kubelet ve Kube-apiserver !!!

bu kisim onemli farklarina ve nasil yapildigina iyice bak!!!!



- journalctl -fu falco 

---

- cilium requiret authentication
- deployment olusmuyor, ns de ki restricted labellari sil
- docker file'da root olarak calistiriyor onu database'in user'i yap, kuberneteste readonly'i true yap.
- /etc/group, su developer, docker ps, systemctl restart docker, 
- kube-bench komutunu calistirmadan direkt denilenleri yap


---

istio 
sidecar ekle  ve authentication enable et

falco
3 deployment birisi 

kubeadm upgrade token eklenmesi lazim
kubeadm token create --print 

developer'i docker /etc grubundan cikar, sonrasinda docker.sock'u root olarak yetkilendir. docker portlari

deployment'i yeniden apply et, hatalar veriyor, duzelt

service account automounth

-- Test tutriol link --> https://test-takers.psiexams.com/linux/manage/my-tests

---

 1.⁠ ⁠Container ve deployment vulnarebelities, deployment da readonlyrootfilesystem false'du ve sifre env olarak set edilmisti. Ekleme ya da cikartma yapamiyorduk, sadece degisiklik yapabiliyoruz.
 2.⁠ ⁠Cluster upgrade, admin.conf dosyasi yok diyor worker node  uzerinde kubeadm upgrade komutunda
 3.⁠ ⁠Network policy
 4.⁠ ⁠Cilium policy
 5.⁠ ⁠Kube-bench 2.2 ihlali haricinde diger ikisi icin bir ihlal gorunmuyordu. Kubelet dedigi icin belki worker node icerisinde denenebilir. Soruyu iyi anlamak lazim.
6,7. Admission controller icin config dosyasina server ekle https, kube-apiserver'a node restriction ad.contr. ekle, arguments lerden birinin degerini degistir, --anonymous-auth u false yap, readonlyrootfilesystem true yap, 
 8.⁠ ⁠Imagepolicywebhook, server ekle, plug-in olarak api-servera ekle, verilen bir yaml dosyasi vardi, root dayken goremiyorsun. 
 9.⁠ ⁠Service account'a token automount'u false olarak ekle.
10.⁠ ⁠User developer I docker grubundan kaldir docker .sock'a ulasilabildiginden emin ol, userdel komutu islemedi. 
11.⁠ ⁠Ingress kesinlikle ornegi al, annotation icin true degerini tirnak icine al.
12.⁠ ⁠Deployment calismiyor, duzelt.
13.⁠ ⁠3 pod var ve bazisi /env/.. pathine ulasiyor, bunu bul scale et. Falco kullan demiyor ama yuklu. 
14.⁠ ⁠Bom kullanarak dosya olusturma.




----


# Docker sorusu

`sudo chmod 600 /var/run/docker.sock`
srw------- 1 root docker 0 Apr 14 18:02 /var/run/docker.sock

`sudo chmod 660 /var/run/docker.sock`
srw-rw---- 1 root docker 0 Apr 14 18:02 /var/run/docker.sock

burada ilk komutta sadece root kullanicisina wr yetkisi verildi ikincisinde ise hem root hem de docker grubuna wr yetkisi verildi.

`sudo chown root:docker /var/run/docker.sock`
srw-rw---- 1 root docker 0 Apr 14 18:02 /var/run/docker.sock

Bu komut ile dosyanın sahibi `root` ve grubu `docker` yaptik.

`sudo chown root:root /var/run/docker.sock`
srw-rw---- 1 root root 0 Apr 14 18:02 /var/run/docker.sock

bu sekilde yaptigimizda hem sahibi hem de grubu root oluyor

Normalde docker.sock'un grubu docker olur, böylece docker grubuna dahil olan kullanıcılar (örneğin developer) Docker CLI komutlarını kullanabilir.
Ama root:root olduğu için docker grubundaki hiç kimse bu dosyaya erişemez.

Bu demektir ki: docker ps gibi komutlar sadece root tarafından çalıştırılabilir. Developer gibi bir kullanıcı docker grubunda olsa bile Permission denied hatası alır.

# Falco

`cat /var/log/syslog | grep -a falco | grep shell`


1. docker grup
2. worker node upgrade
3. istio sidecare injection
4. 



---

1. falco
2. bom
3. istio, PeerAuthentication
4. deployment pod run  edilmiyor
5. kube-bench, webhook, anonymous auth false, 
6. Network, default deny, ns
7. Docker, /etc/group developer, chown, docker daemon'i restart et, docker port
8. ingress, force-ssl-redirect, tls
9. imgapolicywebhook
10. Auditing
11. Worker node update
12. Serviceacount token kaldir, deploymenta volume olarak mount et
13. Docker file, deployment readonlyfile system
14. Configure a Security Context for a Pod or Container
15. tls secret
16. 