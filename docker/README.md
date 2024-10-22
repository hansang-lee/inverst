# Create Multiarch-based Images

## 1. using `docker manifest`

### 1.1. Prepare images for target architectures

**1.1.1. Build images for each architecture**
- linux/arm64 \
`$ docker build -t {user-name}/{repository}:{tag}-arm64 --build-arg ARCH=arm64/ .`

- linux/amd64 \
`$ docker build -t {user-name}/{repository}:{tag}-amd64 --build-arg ARCH=amd64/ .`

**1.1.2. Push the images to docker hub**
- linux/arm64 \
`$ docker push {user-name}/{repository}:{tag}-arm64`

- linux/amd64 \
`$ docker push {user-name}/{repository}:{tag}-amd64`

**1.1.3. Check images**
```
$ docker images
```
If the images are built successfully, there images must be shown as below:
| **`docker images`** | | | | |
| -- | -- | -- | -- | -- |
| REPOSITORY | TAG | IMAGE ID | CREATED | SIZE |
| {user-name}/{repository} | {tag}-amd64 | 80d6227ed648 | XX minutes ago | XX.XGB |
| {user-name}/{repository} | {tag}-arm64 | d395982fd15a | XX minutes ago | XX.XGB |
| | | | | |

### 1.2. Combine the images in a manifest list referenced by a tag

**1.2.1. Create docker manifest**

Let's give it a try with `{tag}-{arch}` images:
```
$ docker manifest create \
{user-name}/{repository}:{tag} \
--amend {user-name}/{repository}:{tag}-amd64 \
--amend {user-name}/{repository}:{tag}-arm64
```
If the command is operated without any problem, it will show: \
`Created manifest list docker.io/{user-name}/{repository}:{tag}`

**1.2.2. Check if the docker manifest is created successfully**

`$ docker manifest inspect {user-name}/{repository}:{tag}`

If the manifest is created by a tag, the command above result will be shown as below:
```
{
   "schemaVersion": 2,
   "mediaType": "application/vnd.docker.distribution.manifest.list.v2+json",
   "manifests": [
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 11465,
         "digest": "sha256:3258a05d07f1f1cc535003f3204fbf190621c47c37bd4ca97225562a945636a9",
         "platform": {
            "architecture": "amd64",
            "os": "linux"
         }
      },
      {
         "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
         "size": 12078,
         "digest": "sha256:96c8e5e9c796e28c6cac584327875c775c6ea24bd758bf72d29c3b15a64a7f70",
         "platform": {
            "architecture": "arm64",
            "os": "linux"
         }
      }
   ]
}
```

**1.2.3. Push the docker manifest**

Then, push the created manifest list- `{user-name}/{repository}:{tag}` to docker hub:
```
$ docker manifest push {user-name}/{repository}:{tag}
```


## 2. using `docker buildx`

> reference : https://docs.docker.com/build/building/multi-platform/

### 2.1. Build and Push multi-platform images at once
> **Note:**
> It must be a single Dockerfile.
> * If there are different contents for each architecture, consider multi-stage.
> * If writing it as a single Dockerfile is difficult, consider **2.2. Build each platform separately and push with one tag**.

**2.1.1. Create builder instance for multi-platform**

```
$ docker buildx create --platform=linux/arm64,linux/amd64 --name multi-platform-builder
$ docker buildx --builder multi-platform-builder inspect --bootstrap
```

**2.1.2. Build and Push multi-platform images**
```
$ docker buildx build \
  --builder multi-platform-builder \
  --platform linux/amd64,linux/arm64 \
  -t {user-name}/{repository}:revlot-ros2 \
  -f ./{repository}/{tag}/Dockerfile \
  --push .
```
### 2.2. Build each platform iamge separately and push with one tag
**2.2.1. Build and Push image for amd64**
```
$ docker buildx build \
  --platform linux/amd64 \
  -t {user-name}/{repository}:{tag}-amd64 \
  -f ./{repository}/{tag}/Dockerfile.amd64 \
  --push .
```
**2.2.2. Build and Push image for arm64**
```
$ docker buildx build \
  --platform linux/arm64 \
  -t {user-name}/{repository}:{tag}-arm64 \
  -f ./{repository}/{tag}/Dockerfile.arm64 \
  --push .
```
**2.2.3. Create and Push manifest for multi-arch image**
```
$ docker buildx create \
  -t {user-name}/{tag} \
  {user-name}/{repository}:{tag}-amd64 {user-name}/{repository}:{tag}-arm64
```
