
# Docker and Security
Docker has been around for quite some time and is considered de facto standard for containerization software.
Docker is first of all a company, Docker Inc.,  with its headquarter in San Francisco that offers Open Source, community and enterprise products. When talking about Docker people often refer to the Docker Engine and Docker containers but Docker is much more than that. Docker Enterprise builds a whole platform for containerization of software trying to meet enterprise requirements such as service level agreements or enforcement of policies.
Docker also ships a community edition of their engine that includes basic features for free which makes it very convenient for anybody to get started.
This work focuses on the features available in the community edition and introduces some security concerns as well as defenses when running Docker containers.

> **Note** Please take into account that products are objects of changes and that information provided here is based on a two-months web research during Oct/Nov 2018.  **No guarantee is given for the information to be complete, final or free from flaws.** Always cross-check your sources.

## Introduction to Containers
Let's get started with a common understanding of containers and try to answer the simple and basic question: What are containers? 

According to Docker containers are some sort of software with high portability:

> A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. (docker.com)

Portability is for sure a very important characteristic of containers and probably Docker's success factor. However, Docker's description of containers is rather abstract and doesn't provide any further technical detail. Techradar adds another important aspect to the definition of containers, the isolation:

> Container […] is a method to package an application so it can be run, with its dependencies, isolated from other processes. (www.techradar.com)

Both ways to describe containers have one thing in common - the package that contains all the dependencies. This package enables the high portability that Docker stresses. However, containers are not only about packages, they are also about isolation which is an interesting detail from a security point of view because isolation means boundaries that have to be protected.

Amazon extends both definitions and mentions another important detail about containers - the shared operating system:

> Containers provide a standard way to package your application's code, configurations, and dependencies into a single object.
> Containers share an operating system installed on the server and run as resource-isolated processes, ensuring quick, reliable, and consistent deployments, regardless of environment. (aws.amazon.com)

Not only do we have to concern about process isolation but also about shared operating system. This is getting more and more interesting from a security point of view. Sharing means trust and possible conflicts, aspects central to application security.

In short, we can define container as follows:
* Containers are self-sufficient packages that enable reliable, consistent deployment of an application regardless of environment.
* Containers run as isolated processes on a target system.


## Virtualization
Containers include all the dependencies and configuration to run an application, they have their own file system and tools. Therefore it may be hard at the beginning to understand the differences between a virtual machine and a container, Jérôme Petazzoni from Docker Inc. explained the problem in a nice way

> It's a lightweight VM - it '*feels*' like it!

A closer look at the stack reveals that virtual machines and containers operate differently. Both use virtualization techniques, however virtual machines emulate hardware and always contain a guest operating system. As a result, virtual machines are independent from the underlying operating system allowing to run different machines with different operating systems on the same host. At the same time this creates a certain overhead. Containers on the other hand share kernel features and therefore are dependent on the host operating system but they are lightweight which makes them fast and portable.

The idea of separated processes, creating small and isolated environments for programs has been around for about 40 years. Chroot was released in 1979 and since year 2000 different products and features appeared on the market. The early adopters addressed mainly to operation teams but  Docker put developers into focus as well.

## Architecture
Docker's container engine builds on a client-server architecture. The central components are
* Docker client
* Docker deamon
* Image registry (e.g. Docker Hub)

All operations from the client go through the Docker deamon that fetches  images and runs containers. 

## Docker Image
Every container is based on an image. An image contains the code, dependencies and instructions for an application to run inside a container. A container is the instance of an image at runtime. Images reside on an image registry like Docker Hub. 

### Docker Hub
Docker Hub is Docker's public, free-to-use registry that allows the community to publish Docker images. Everyone can create either a public or private repository. Docker Hub hosts official images for different products as well.
In June 2018 Kromtech Security Center published a report about malicious Docker images that contained cryptomining software. Those images were active for about 1 year, had over 5 million pulls and enabled hackers to mine cryptocurrency worth about $90000. This report shows how important it is to verify the integrity of images and not to trust public repositories. 

### Docker Content Trust
Docker offers a feature called "Docker Content Trust" that enables Docker deamon to only trust signed images. Official images on Docker Hub are signed. Docker Content Trust is the first step of minimizing the risk of running malicious code. Unfortunately this feature is turned off by default. To enable Docker Content Trust set the following environment variable:

    $ export DOCKER_CONTENT_TRUST=1
You can test if it works by trying to pull the test image:

    $ docker pull docker/trusttest
It should fail because the image is not signed. Try pulling an official image instead.

    $ docker pull busybox

Another good practice for images are "automated builds" where the Docker Hub account is linked to a GitHub or Bitbucket account, web hooks are created and every new push will trigger a new build of the image. In this way users are provided with a traceability between the Dockerfile and the version of the image which enables them to study the source of the image.

### Dockerfile
A Dockerfile is a simple text file that provides instructions on how to build a new image. It contains i.a. the following directives:
* base image
* environment variables
* files to include
* exposed ports
* entrypoint and commands to run

Every instruction in the Dockerfile creates a new read-only layer in the image.

### Image Layers
Docker images are built upon layers. Each layer contains the differences and changes to the previous layer. Image layers are read-only, they cannot be changed by a running container. 
Each container has a writeable layer on top of the image layers, called the container layer. This layer is destroyed with the container. Therefore one primitive for containers is immutability.
List the image layers - including the layers of the base image - by using docker history command.

    $ docker history myImage

> **Note** Since the directives in the Dockerfile are reflected in image layers, **be careful about which information to put in the Dockerfile**. 

The following example output shows that environment variables are visible in the image layers and therefore for everybody using the image.

    IMAGE         [...]  CREATED BY 
    11d8f9e12e42   ...   [...] CMD ["/bin/cat" "/greetings/fromMe.txt"]
    63dc92745629   ...   [...] COPY file:3bff68af9383544cc9f1cd820647b69…
    09cdd4f30470   ...   [...] ENV variable=visible
    788edf1f3e     ...   [...] CMD ["sh"]
    <missing>      ...   [...] ADD file:63eebd629a5f7558c361be0305df5f16b…


## Building Blocks
Let's recall, Docker containers create an isolated complete execution environment. The main building blocks to accomplish this are
* Isolation - by namespaces
* Resource utilization - with the help of control groups (cgroups)
* Security - in form of capabilities and seccomp

Namespaces, control groups and capabilities are all features of the Linux kernel.

### Namespaces
Namespaces provide isolation by enabling a process to have different views of the system resources than other processes. Imagine a 'nested' process tree with it's own process IDs, hostnames, user IDs, network access, interprocess communication and file systems. Processes form one process-tree/namespace cannot inspect/kill a process in a different process-tree. However, processes in the parent namespace have a complete view.
So far six different namespaces exist:
* mnt (mount points, file system)
* pid (processes)
* uts (hostname)
* ipc (interporcess communication)
* net (network stack)
* user (UIDs)

When a new container is created, Docker puts it in its own namespaces which makes *it feel like a virtual machine*.

### cgroups
Cgroups allow to create hierarchical groups of processes in order to serve resource limiting and accounting. Resources that can be managed by cgroups are
* memory
* cpu
* network
* devices
* disk I/O

Docker provides various switches to configure cgroups when running a container. Among them are the following
* --memory
* --memory-swap
* --oom-kill-disable
* --cpus
* --cpuset-cpus
* ...

### Capabilities
Docker containers run as root per default. However, Linux provides a set to divide the power of the superuser called capabilities. Even though the container runs as root the process does not have full capabilities. Some of the default capabilities in Docker are:
* CHOWN
* DAC_OVERRIDE
* FOWER
* NET_RAW
* ...

Some of them are quite powerful.

CHOWN allows to change the ownership of any file system object.

DAC_OVERRIDE allows to bypass file read, write, and execute permission checks. This means the process can read, write, and execute any file on the system, even if the permission and ownership fields would not allow it.

FOWNER allows to bypass permission checks on operations that normally require the filesystem UID of the process to match the UID of the file. Similar to DAC_OVERRIDE.

NET_RAW allows the use of RAW and PACKET sockets and enables the process to bind to any address for transparent proxying. In other words, the process may be able to spy on packets on its network.

> **Note** It's good practice to **drop all capabilities** and just use the once required by the application.
> Also, run containers as a **specified user** to minimize the impact in case someone succeeds to break out of the container.

    $ docker run --cap-drop ALL --user <uid>:<gid> <image>


### Secure Computing Mode

Secure Computing, seccomp, is similar to capabilities but provides an even more granular way to control and limit what a processes can do. With the help of seccomp you can restrict the system calls from the container. Docker provides a default whitelist where 44 out of more than 300 system calls are disabled, some of which are obsolete or do not support namespaces.

## Docker Swarm
Containers being so light and portable are perfect for orchestration. Despite different orchestration tools on the market Docker has its own tool called Docker Swarm. A swarm consists of one or several nodes of which at least one is a manager, where services and stacks are defined. A worker then runs one or more tasks of a service.

### Raft
In order to manage the global cluster state manager nodes implement the Raft Consensus Algorithm. Each change within the cluster creates a new log entry making the Raft log a likely target for information gathering. Raft logs not only contain the state of the cluster but also secrets. Therefore the Raft log is encrypted by default and keys are rotated every 90 days. Also, all the traffic for managing the cluster is encrypted with TLS that protects secrets in transit. Mutual TLS adds client authentication to the communication, making sure only trusted clients can connect to the swarm. Since setting up and managing an PKI can be quite cumbersome, Docker ships with a built-in Certificate Authority that creates certificates when needed and rotates keys regularly. 

### Docker Secrets
When running an application in a secure manner it is basically inevitable to have some sort of secret. HTTPS should be standard and where there is a certificate there is a key. Secrets management becomes even more complex in distributed and cloud environments. That's were Docker Secrets fit in. Secrets were introduced in Docker 1.13 (January 2017) in order to 

 1. provide a central management of secret data
 2. securely transmit secrets to specific containers

Secrets can be any form of data such as a password, SSH private keys, SSL certificate or any aother pies of data that should not be transmitted over a network or stored unencrypted in a Dockerfile or in application's source code.
Docker Secrets require Swarm mode and do not work on stand alone containers.