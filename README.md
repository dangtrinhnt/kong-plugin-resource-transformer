# Resource Transformer

> A kong plugin that will analyze the request path and transforms the ids.

This plug will take the nginx request path and scan againts the configured resources. 
If found, and the resource ids are integers, the resource transformer will change the upstream uri to the 
transformed path with the transformed uuid.


### Why we need this 

This plugin was needed because while migrating our databases, we needed to 
migrate the ids of several resources to uuid.
The transformation *can* be done at the application but we came across an
issue where different services would need several keys to transform the ids 
to the new uuids. This required extra configuration and we wanted to isolate
the keys for each service.

## Compatibility matrix

- Resource Transformer v0.0.6.1: Kong v0.14.x
- Resource Transformer v0.0.7.1: Kong v1.5.x


## Installation

### Install from the Luarocks repository

``` sh
$ luarocks install resource-transformer
```
Note: install resource-transformer plugin from the Luarocks repository does not guarantee you with the latest version.

### Install from the git repository

``` sh
$ git clone https://github.com/dangtrinhnt/kong-plugin-resource-transformer.git
$ cd kong-plugin-resource-transformer
$ luarocks make kong-plugin-resource-transformer-0.0.7-1.rockspec
```

## Usage

This follows the kong plugin spec so extra references can be found [here](https://docs.konghq.com/1.5.x/plugin-development/).

### Configuration

**Enabling the plugin**

This plugin is currently a global plugin and will be run against all requests.

``` sh
$ curl -X POST http://kong:8001/plugins/ --data "name=resource-transformer"
```

**Parameters**

Here is a list of the parameters which can be used in this plugin's configurations:

| Parameter | Default | Description |
| --------: | ------- | :---------- |
| `name` | | The name of the plugin to use, in this case `resource-trasformer` |


## Documentation

In order to use the plugin, you first need to create the resource names to look for and either respective transform uuids.

**Create a transformer**

``` sh
$ curl -X POST -H "Content-type: application/json" --data '{"resource_name":"user", "transform_uuid":"2f4b5070-73b9-5c1c-8d3c-da8ae80051b0"}' http://kong:8001/resource-transformer/
HTTP/1.1 201 Created

{
  "transform_uuid":"2f4b5070-73b9-5c1c-8d3c-da8ae80051b0",
  "created_at":1524750123000,
  "resource_name":"user",
  "id":"bbd7ee37-9aaf-493b-86e3-d4642e4d00b3"
}

```

| Parameter | Default | Description | 
| ----: | ------ | :----- |
| `resource_name` *required* | | `unique` The resource string to search in the uri. |
| `transform_uuid` *required* | | `required` The uuid that will be used as the namespace for uuid5 generation. |

This will look in the path of uri for `user` and if an integer id is found trailing the resource name(ex. `/user/726`), the `726` will 
be taken and coverted to a uuid5 with the transform_uuid. So `uuid.generate_v5("2f4b5070-73b9-5c1c-8d3c-da8ae80051b0", "726)` and the resulting 
uuid will be rewritten in place of the integer ids, resulting in the upstream uri to be rewritten as `/user/698aa227-04b1-53be-9a46-1459d8a0f493`.

**List transformers**
``` sh
$ curl -X GET http://kong:8001/resource-transformer/
HTTP/1.1 200 OK

{
  "total":1,
  "data":[
    {
      "transform_uuid":"2f4b5070-73b9-5c1c-8d3c-da8ae80051b0",
      "created_at":1525061288000,
      "resource_name":"user",
      "id":"332f012f-5b37-4fcd-917c-d742855989af"
    }
  ]
}
```

**Get a transformer**

``` sh
$ curl -X GET http://kong:8001/resource-transformer/{id_or_resource_name}
HTTP/1.1 200 OK
{
  "transform_uuid":"2f4b5070-73b9-5c1c-8d3c-da8ae80051b0",
  "created_at":1525061288000,
  "resource_name":"user",
  "id":"332f012f-5b37-4fcd-917c-d742855989af"
}
```

* `id`: The `id` or `resource_name` property of the `resource-transformer` entity to fetch.

**Update a transformer**

``` sh 
$ curl -X PUT -H "Content-type: application/json" --data '{"resource_name":"user", "transform_uuid":"2f4b5070-73b9-5c1c-8d3c-da8ae80051b0"}' http://kong:8001/resource-transformer/{id_or_resource_name}
```

| Parameter | Default | Description | 
| ----: | ------ | :----- |
| `resource_name` *required* | | `unique` The resource string to search in the uri. |
| `transform_uuid` *required* | | `required` The uuid that will be used as the namespace for uuid5 generation. |


**Delete a transformer**

``` sh 
$ curl -X DELETE http://kong:8001/resource-transformer/{id}
HTTP/1.1 204 No Content
```

* `id`: The `id` or `resource_name` property of the `resource-transformer` entity to delete.

## Running Tests

## Development

*Reference: https://github.com/Kong/kong-vagrant#development-environment*

``` sh
# clone kong-vagrant
$ git clone https://github.com/Kong/kong-vagrant
$ cd kong-vagrant

# clone kong repo
$ git clone https://github.com/Kong/kong

# run vagrant (eg.'KONG_PLUGIN_PATH=../kong-plugin-resource-transformer/ vagrant up')
$ KONG_PLUGIN_PATH=/path/to/plugin vagrant up 
$ vagrant ssh
$ cd /kong
$ make dev

# to enable resource-transformer plugin
$ export KONG_CUSTOM_PLUGINS=resource-transformer

# start kong
# cd /kong
$ bin/kong migrations up
$ bin/kong start

# make sure to enable resource-transformer with admin api
# for global
$ curl -X POST http://kong:8001/plugins/ --data "name=resource-transformer"

# to restart after code changes
$ bin/kong restart
```


## Uploading to Package Manager

### Luarocks

``` sh
$ git tag vX.X.X
$ git push origin vX.X.X
$ luarocks upload kong-plugin-resource-transformer-X.X.X.rockspec
```

where `X.X.X` is the new version.

## Maintainers

* Trinh Nguyen - [dangtrinhnt](https://www.dangtrinh.com)

## Original Authors

* Kwang Jin Kim - [crazytruth](https://github.com/crazytruth)

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

