# k3s

Chef cookbook to install [K3s](https://k3s.io/) using MariaDB as a [Cluster Datastore](https://rancher.com/docs/k3s/latest/en/installation/datastore/).

## Getting Started

This cookbook requires a running MariaDB instance to use as a backend for K3s. See the [mariadb cookbook](https://supermarket.chef.io/cookbooks/mariadb) for examples of how to setup a standalone or Galera instance.

## Resources

### `k3s_install`

The `k3s_install` resource is responsible for fetching and running a Terraform Cloud Agent docker image.

#### Actions

default_action :run

* `:create` -  Pulls the container image.
* `:remove` - Removes the cached image.

#### Properties

* `datastore` - Cluster Datastore to use, at the moment only `mariadb` is supported. Defaults to `mariadb`.
* `kubeconfig_mode` - kube config file mode. Defaults to `0644`.
* `mariadb_database` - MariaDB database to use. Defaults to `k3s`.
* `mariadb_user` - MariaDB username used by k3s. Defaults to `k3s`.
* `mariadb_password` - MariaDB password used by k3s. Defaults to `k3s`.
* `mariadb_host` - MariaDB host to use. Defaults to `localhost`.
* `node_labels` - Array of `key=value` pairs to apply as node labels.
* `tls_san` - TLS SAN(s); can be specified either as an array or string.

#### Examples

Minimal usage:

```ruby
k3s_install 'server'
```

Using non-default MariaDB settings:

```ruby
k3s_install 'server' do
  mariadb_user     'k3s'
  mariadb_password 'p4ssw0rd'
  mariadb_host     'db.local'
end
```

Specifying custom node labels and additional TLS SAN:

```hcl
k3s_install 'server' do
  node_labels ['foo=bar', 'something=amazing']
  tls_san     'k3s.example.com'
end
```

## Versioning

This cookbook uses [Semantic Versioning 2.0.0](http://semver.org/).

Given a version number MAJOR.MINOR.PATCH, increment the:

* MAJOR version when you make functional cookbook changes,
* MINOR version when you add functionality in a backwards-compatible manner,
* PATCH version when you make backwards-compatible bug fixes.

## Contributing

We welcome contributed improvements and bug fixes via the usual work flow:

1. Fork this repository
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new pull request

## License and Authors

Authors and contributors:

* Stephen Hoekstra <shoekstra@schubergphilis.com>

```
Copyright 2020 Stephen Hoekstra <stephenhoekstra@gmail.com>
Copyright 2020 Schuberg Philis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
