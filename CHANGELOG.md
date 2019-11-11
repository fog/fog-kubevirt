### 1.3.3 / 2019-11-11

* Fix api versions
* Add option to specify the kubevirt API version

### 1.3.2 / 2019-08-26

* Fixes #1728671 - fix undefined boot_order
* Add VNC console details function


### 1.3.1 / 2019-07-07

* Fixes #1726635 - Add token for detect version request

### 1.3.0 / 2019-05-14

* Log exception for client errors
* Support memory unit in create_vm
* Exception handling improvements
* Add tests to allow configure namespace
* Add tests for provision vmi/server and check mac
* Add volumes tests
* Refactor utils module
* Add network attachement definitions tests

### 1.2.5 / 2019-04-24

* Add validattion for PVC request size and limit
* Update networks from vmi on Server
* Update kubeclient version to 4.3.0

### 1.2.4 / 2019-04-18

* Do not rely on attributes defaults
* Populate PVC attributes for Volume

### 1.2.3 / 2019-04-15

* Add network details to VmNic

### 1.2.2 / 2019-04-12

* Fix minor bugs

### 1.2.1 / 2019-04-12

* Use mac address reported by kubevirt
* Do not pass an empty selector
* Populate PVC for VM volume

### 1.2.0 / 2019-04-08

* Replace state with phase of Server model
* Add mocks

### 1.1.3 / 2019-04-05

* Refactor VM modules
* Pull VmNic to its one file
* Add identity to VmNic
* Set default value to vm collections

### 1.1.2 / 2019-04-04

* Verify server is accessible before other validations
* Do not rely on IP Address for VM readiness

### 1.1.1 / 2019-04-03

* Support SSL
* Validate namespace exists
* Make VmNic fog model
* Minor bug

### 1.1.0 / 2019-03-31

* Replace VmVolume with Volume as main collection
* Allow to create vm with multiple pvcs
* Rename Volume to PersistentVolume
* Add support for Storage Class
* Make VmVolume a Fog model
* Extend VMs, VM Instances and servers

### 1.0.2 / 2019-02-27

* Asdd Watch VMIs
* Differentiate status and state
* Change kubevirt api version
* Change registry to container disk
* Remove bundler dependency
* Bump kubeclient to 4.1.2
* Support Persistent Volume Claims
* Support Persistent Volumes
* Support networks and interfaces
* Volume name should respect restrictions
* Introduce config file based client
* Add vm cloud-init support
* server and servers
* Allow local Gemfile.dev.rb
* Support services
* Make VM memory optional

### 1.0.1 / 2018-10-09

* fog-core bumped to 2.1.1
* Namespace change to Fog::Kubevirt per fog-core 2
* Added VM status property
* Allow to create VM without a template

### 0.1.6 / 2018-07-16

* Support openshift parameters processing ${{PARAM_NAME}} in templates.

### 0.1.4 / 2018-06-25

* Save resource_version and kind for entitiy collections

### 0.1.3 / 2018-06-17

* Work against api v1alpha2
* Change code to match new entities names:
  VirtualMachine ==> VirtualMachineInstance
  OfflineVirtualMachine ==> VirtualMachine

### 0.1.2 / 2018-05-25

* Collect vm status from kubevirt
* Fix resource_version naming

### 0.1.1 / 2018-05-22

* Move code from `manageiq-provider-kubevirt`.

### 0.1.0 / 2018-02-09

* Initial release of `fog-kubevirt` module. It provides basic `kubevirt`
  management capabilities.
