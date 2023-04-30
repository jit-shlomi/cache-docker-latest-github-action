
# Cache Docker images using GitHub Actions cache

This GitHub Action caches Docker images using the GitHub Actions cache service. It downloads the latest version of the Docker image and caches it for subsequent runs.
Usage

To use this action, add the following step to your GitHub Actions workflow:

```yaml

- name: Cache Docker image
  uses: myorg/cache-docker-image@v1
  with:
    image-name: <name of Docker image>
    cache-key: <unique key for caching the image>
``` 

Replace <name of Docker image> with the name of the Docker image you want to cache, and <unique key for caching the image> with a unique key to identify the cached image.
Inputs

* image-name (required): The name of the Docker image to cache.
* cache-path (optional): The path to the directory where the Docker image should be cached (default: ci/cache/docker).
* cache-key (optional): The key used to identify the cached Docker image (default: docker-image-${{ github.sha }}).
* cache-duration (optional): The time period for which the cache should be kept (default: 7 days).

Outputs

* cache-hit: Whether the Docker image was restored from the cache.

License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.
