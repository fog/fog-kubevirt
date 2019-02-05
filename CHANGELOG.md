### 0.2.1 / 2019-02-5

* Fix broken create VM due to API changes
* Fix VM status, nics and cloud-init to support vagrant
* Add VMI watches
* Introduce config file based client

### 0.2.0 / 2019-01-23

* Detect kubevirt api version
* Change registry to container disk
* Support Persistent Volume Claims
* Bump kubeclient to 4.1.2
* Support Persistent Volumes
* Volume name should respect restrictions

### 0.1.8 / 2018-12-3

* Bump kubeclient version to 4.1

### 0.1.7 / 2018-11-27

* Use kubeclient 4.0
* Introduce Server and Servers
* Extend VMs and Server reported data to include networks, interfaces,
  disks and volumes
* Support SSL
* Support Services kubernetes resource
* Support cloud-init

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
