# benchmark-poetry-install-vs-docker-pull

Trying to figure out if `poetry install` or `docker pull` is faster.

## Test

The test will compare the time it takes to build the image to the time it takes to pull the image.
The question we're trying to answer is whether or not it's worth the time and effort to bake the poetry cache into a base image.

Building the image shows how long it takes to install all the packages via `poetry install` from scratch:

This command:
```
echo "started at $(date)" && make image && echo "finished at $(date)"
```

Generated this:
```
started at Thu Dec 16 17:37:33 CST 2021
[+] Building 31.9s (8/9)
 => [internal] load build definition from Dockerfile                                                                                                                            0.0s
 => => transferring dockerfile: 191B                                                                                                                                            0.0s
 => [internal] load .dockerignore                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/prefecthq/prefect:0.14.21-python3.8                                                                                                  0.0s
 => CACHED [1/5] FROM docker.io/prefecthq/prefect:0.14.21-python3.8                                                                                                             0.0s
 => [internal] load build context                                                                                                                                               0.0s
 => => transferring context: 36B                                                                        [+] Building 147.4s (8/9)                                                    [+] Building 186.9s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                            0.0s
 => => transferring dockerfile: 191B                                                                                                                                            0.0s
 => [internal] load .dockerignore                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/prefecthq/prefect:0.14.21-python3.8                                                                                                  0.0s
 => CACHED [1/5] FROM docker.io/prefecthq/prefect:0.14.21-python3.8                                                                                                             0.0s
 => [internal] load build context                                                                                                                                               0.0s
 => => transferring context: 36B                                                                                                                                                0.0s
 => [2/5] RUN pip install --upgrade pip poetry==1.1.3                                                                                                                          11.6s
 => [3/5] WORKDIR /src                                                                                                                                                          0.0s
 => [4/5] COPY pyproject.toml ./                                                                                                                                                0.1s
 => [5/5] RUN poetry install                                                                                                                                                  168.6s
 => exporting to image                                                                                                                                                          6.3s
 => => exporting layers                                                                                                                                                         6.3s
 => => writing image sha256:70a26bee5d6040b0f70a0c3c321d23d3e5bb78ee4c77112bda4ff64a9685d91d                                                                                    0.0s
 => => naming to docker.io/bsorahan/benchmark-poetry-install-vs-docker-pull                                                                                                     0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
finished at Thu Dec 16 17:40:41 CST 2021
```

Next I'm going to push this image, then pull it on a digital ocean droplet that doesn't have it.

First, verify that it isn't in the image cache:
```
root@ubuntu-512mb-nyc3-01:~# docker rmi bsorahan/benchmark-poetry-install-vs-docker-pull
Error: No such image: bsorahan/benchmark-poetry-install-vs-docker-pull
```

Then this command
```
echo "started at $(date)" && docker pull bsorahan/benchmark-poetry-install-vs-docker-pull && echo "finished at $(date)"
```

generated this output
```
started at Thu Dec 16 23:43:37 UTC 2021
Using default tag: latest
latest: Pulling from bsorahan/benchmark-poetry-install-vs-docker-pull
69692152171a: Pull complete
66a3c154490a: Pull complete
3e35bdfb65b2: Pull complete
f2c4c4355073: Pull complete
65d67526c337: Pull complete
b3de4f744be0: Extracting [===============>                                  b3de4f744be0: Pull complete
5b98ffdf6840: Pull complete
aa1deef3f3c3: Pull complete
b3ebd775a063: Pull complete
fb266aba02a5: Pull complete
8bc341e0c3f0: Pull complete
Digest: sha256:0629d90f06ab6137f40de4d9fea27f96f0f077af03c8fecbe59c53f36e993b38
Status: Downloaded newer image for bsorahan/benchmark-poetry-install-vs-docker-pull:latest
finished at Thu Dec 16 23:44:12 UTC 2021
```

So to recap, the start/end times for building the image (poetry install from scratch):
```
Thu Dec 16 17:37:33 CST 2021
Thu Dec 16 17:40:41 CST 2021
```

and the start/end times for docker pull:
```
Thu Dec 16 23:43:37 UTC 2021
Thu Dec 16 23:44:12 UTC 2021
```

docker pull wins :)
