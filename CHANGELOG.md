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
