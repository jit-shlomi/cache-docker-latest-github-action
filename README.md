# Cache Docker images using GitHub Actions cache

This GitHub Action caches Docker images using the GitHub Actions cache service. It downloads the latest version of the Docker image and caches it for subsequent runs.

**Note:** The GitHub Actions cache is immutable, which means that once a cache is created, it cannot be updated. To cache a new version of a Docker image, you must create a new cache. However, to avoid using up the entire cache quota, you should only create a new cache when the Docker image has been updated in the registry.

To achieve this, this action queries the digest of the Docker image and creates a new cache only if the digest has changed. Otherwise, it restores the image from the existing cache.

## Usage

To use this action, add the following step to your GitHub Actions workflow:

```yaml
- name: Cache Docker image
  uses: myorg/cache-docker-image@v1
  with:
    image-name: <name of Docker image>
    cache-key: <unique key for caching the image>
```

Replace `<name of Docker image>` with the name of the Docker image you want to cache, and `<unique key for caching the image>` with a unique key to identify the cached image.

## Inputs

* `image-name` (required): The name of the Docker image to cache.
* `cache-path` (optional): The path to the directory where the Docker image should be cached (default: `ci/cache/docker`).

## Outputs

* `cache-hit`: Whether the Docker image was restored from the cache.

## License

This project is licensed under the terms of the MIT license. See the `LICENSE` file for details.

**Note:** The GitHub Actions cache service has limitations on the amount of disk space that can be used by a repository. Please refer to the [GitHub documentation](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepsuseswith) for more information on these limitations.
