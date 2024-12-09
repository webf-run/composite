# composite
A Docker image

```bash

# Mac
docker buildx build --progress plain -t mistyharsh/composite .
docker run --rm -it mistyharsh/composite bash

# AMD64/X86_64
docker buildx build --progress plain --platform=linux/amd64 -t mistyharsh/composite .
docker run --rm -it --platform=linux/amd64 mistyharsh/composite bash
```
