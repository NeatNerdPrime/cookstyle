# Chef/Correctness

## Chef/Correctness/BlockGuardWithOnlyString

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

A resource guard (not_if/only_if) that is a string should not be wrapped in {}. Wrapping a guard string in {} causes it to be executed as Ruby code which will always returns true instead of a shell command that will actually run.

### Examples

```ruby
#### incorrect
template '/etc/foo' do
  mode '0644'
  source 'foo.erb'
  only_if { 'test -f /etc/foo' }
end

#### correct
template '/etc/foo' do
  mode '0644'
  source 'foo.erb'
  only_if 'test -f /etc/foo'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.2.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessblockguardwithonlystring](https://rubystyle.guide#chefcorrectnessblockguardwithonlystring)

## Chef/Correctness/ChefApplicationFatal

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Use raise to force Chef Infra Client to fail instead of using Chef::Application.fatal, which masks the full stack trace of the failure and makes debugging difficult.

### Examples

```ruby
#### incorrect
Chef::Application.fatal!('Something horrible happened!')

#### correct
raise "Something horrible happened!"
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.0.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnesschefapplicationfatal](https://rubystyle.guide#chefcorrectnesschefapplicationfatal)

## Chef/Correctness/ConditionalRubyShellout

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Don't use Ruby to shellout in a only_if / not_if conditional when you can just shellout directly. Any string value used with only_if / not_if is executed in your system's shell and the return code of the command is the result for the not_if / only_if determination.

### Examples

```ruby
#### incorrect
cookbook_file '/logs/foo/error.log' do
  source 'error.log'
  only_if { system('wget https://www.bar.com/foobar.txt -O /dev/null') }
end

cookbook_file '/logs/foo/error.log' do
  source 'error.log'
  only_if { shell_out('wget https://www.bar.com/foobar.txt -O /dev/null').exitstatus == 0 }
end

#### correct
cookbook_file '/logs/foo/error.log' do
  source 'error.log'
  only_if 'wget https://www.bar.com/foobar.txt -O /dev/null'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.1.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessconditionalrubyshellout](https://rubystyle.guide#chefcorrectnessconditionalrubyshellout)

## Chef/Correctness/CookbookUsesNodeSave

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Don't use node.save to save partial node data to the Chef Infra Server mid-run unless it's
absolutely necessary. Node.save can result in failed Chef Infra runs appearing in search and
increases load on the Chef Infra Server."

### Examples

```ruby
#### incorrect
node.save
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.5.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnesscookbookusesnodesave](https://rubystyle.guide#chefcorrectnesscookbookusesnodesave)

## Chef/Correctness/DnfPackageAllowDowngrades

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

dnf_package does not support the allow_downgrades property

### Examples

```ruby
#### incorrect
dnf_package 'nginx' do
  version '1.2.3'
  allow_downgrades true
end

#### correct
dnf_package 'nginx' do
  version '1.2.3'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.16.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessdnfpackageallowdowngrades](https://rubystyle.guide#chefcorrectnessdnfpackageallowdowngrades)

## Chef/Correctness/IncorrectLibraryInjection

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Libraries should be injected into the Chef::DSL::Recipe class and not Chef::Recipe or Chef::Provider classes directly.

### Examples

```ruby
#### incorrect
::Chef::Recipe.send(:include, Filebeat::Helpers)
::Chef::Provider.send(:include, Filebeat::Helpers)
::Chef::Recipe.include Filebeat::Helpers
::Chef::Provider.include Filebeat::Helpers

#### correct
::Chef::DSL::Recipe.send(:include, Filebeat::Helpers) # covers previous Recipe & Provider classes
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.10.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessincorrectlibraryinjection](https://rubystyle.guide#chefcorrectnessincorrectlibraryinjection)

## Chef/Correctness/InvalidDefaultAction

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

No documentation

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.13.0` | String
Include | `**/libraries/*.rb`, `**/resources/*.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvaliddefaultaction](https://rubystyle.guide#chefcorrectnessinvaliddefaultaction)

## Chef/Correctness/InvalidNotificationTiming

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Valid notification timings are :immediately, :immediate (alias for :immediately), :delayed, and :before.

### Examples

```ruby
#### incorrect

template '/etc/www/configures-apache.conf' do
  notifies :restart, 'service[apache]', :nope
end

#### correct

template '/etc/www/configures-apache.conf' do
  notifies :restart, 'service[apache]', :immediately
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.16.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidnotificationtiming](https://rubystyle.guide#chefcorrectnessinvalidnotificationtiming)

## Chef/Correctness/InvalidPlatformFamilyHelper

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Pass valid platform families to the platform_family? helper.

### Examples

```ruby
#### incorrect
platform_family?('redhat')
platform_family?('sles')

#### incorrect
platform_family?('rhel')
platform_family?('suse')
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.15.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformfamilyhelper](https://rubystyle.guide#chefcorrectnessinvalidplatformfamilyhelper)

## Chef/Correctness/InvalidPlatformFamilyInCase

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Use valid platform family values in case statements.

### Examples

```ruby
#### incorrect
case node['platform_family']
when 'redhat'
  puts "I'm on a RHEL-like system"
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.6.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformfamilyincase](https://rubystyle.guide#chefcorrectnessinvalidplatformfamilyincase)

## Chef/Correctness/InvalidPlatformHelper

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Pass valid platforms to the platform? helper.

### Examples

```ruby
#### incorrect
platform?('darwin')
platform?('rhel)
platform?('sles')

#### correct
platform?('mac_os_x')
platform?('redhat)
platform?('suse')
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.15.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformhelper](https://rubystyle.guide#chefcorrectnessinvalidplatformhelper)

## Chef/Correctness/InvalidPlatformInCase

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Use valid platform values in case statements.

### Examples

```ruby
#### incorrect
case node['platform']
when 'rhel'
  puts "I'm on a Red Hat system!"
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.6.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformincase](https://rubystyle.guide#chefcorrectnessinvalidplatformincase)

## Chef/Correctness/InvalidPlatformMetadata

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

metadata.rb supports methods should contain valid platforms.

### Examples

```ruby
#### incorrect
supports 'darwin'
supports 'mswin'

#### correct
supports 'mac_os_x'
supports 'windows'
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.2.0` | String
Include | `**/metadata.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformmetadata](https://rubystyle.guide#chefcorrectnessinvalidplatformmetadata)

## Chef/Correctness/InvalidPlatformValueForPlatformFamilyHelper

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Pass valid platforms families to the value_for_platform_family helper.

### Examples

```ruby
#### incorrect
value_for_platform_family(
  %w(rhel sles) => 'foo',
  %w(mac) => 'foo'
)

#### correct
value_for_platform_family(
  %w(rhel suse) => 'foo',
  %w(mac_os_x) => 'foo'
)
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.15.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformvalueforplatformfamilyhelper](https://rubystyle.guide#chefcorrectnessinvalidplatformvalueforplatformfamilyhelper)

## Chef/Correctness/InvalidPlatformValueForPlatformHelper

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Pass valid platforms to the value_for_platform helper.

### Examples

```ruby
#### incorrect
value_for_platform(
  %w(rhel mac_os_x_server) => { 'default' => 'foo' },
  %w(sles) => { 'default' => 'bar' }
)
#### correct
value_for_platform(
  %w(redhat mac_os_x) => { 'default' => 'foo' },
  %w(opensuseleap) => { 'default' => 'bar' }
)
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.15.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidplatformvalueforplatformhelper](https://rubystyle.guide#chefcorrectnessinvalidplatformvalueforplatformhelper)

## Chef/Correctness/InvalidVersionMetadata

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Cookbook metadata.rb version field should follow X.Y.Z version format.

### Examples

```ruby
#### incorrect
version '1.2.3.4'

#### correct
version '1.2.3'
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.8.0` | String
Include | `**/metadata.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnessinvalidversionmetadata](https://rubystyle.guide#chefcorrectnessinvalidversionmetadata)

## Chef/Correctness/LazyEvalNodeAttributeDefaults

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

When setting a node attribute as the default value for a custom resource property, wrap the node attribute in `lazy {}` so that its value is available when the resource executes.

### Examples

```ruby
#### incorrect
property :Something, String, default: node['hostname']

#### correct
property :Something, String, default: lazy { node['hostname'] }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.6.0` | String
Include | `**/libraries/*.rb`, `**/resources/*.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnesslazyevalnodeattributedefaults](https://rubystyle.guide#chefcorrectnesslazyevalnodeattributedefaults)

## Chef/Correctness/LazyInResourceGuard

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Using `lazy {}` within a resource guard (not_if/only_if) will cause failures and is unnecessary as resource guards are always lazily evaluated.

### Examples

```ruby
#### incorrect
template '/etc/foo' do
  mode '0644'
  source 'foo.erb'
  only_if { lazy { ::File.exist?('/etc/foo')} }
end

#### correct
template '/etc/foo' do
  mode '0644'
  source 'foo.erb'
  only_if { ::File.exist?('/etc/foo') }
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.18.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnesslazyinresourceguard](https://rubystyle.guide#chefcorrectnesslazyinresourceguard)

## Chef/Correctness/MacosUserdefaultsInvalidType

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

The macos_userdefaults resource prior to Chef Infra Client 16.3 would silently continue if invalid types were passed resulting in unexpected behavior. Valid values are: "array", "bool", "dict", "float", "int", and "string".

### Examples

```ruby
#### incorrect
macos_userdefaults 'set a value' do
  global true
  key 'key'
  type 'boolean'
end

#### correct
macos_userdefaults 'set a value' do
  global true
  key 'key'
  type 'bool'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.14.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessmacosuserdefaultsinvalidtype](https://rubystyle.guide#chefcorrectnessmacosuserdefaultsinvalidtype)

## Chef/Correctness/MalformedPlatformValueForPlatformHelper

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

When using the value_for_platform helper you must include a hash of possible platforms where each platform contains a hash of versions and potential values. If you don't wish to match on a particular version you can instead use the key 'default'.

### Examples

```ruby
#### incorrect
value_for_platform(
  %w(redhat oracle) => 'baz'
)

#### correct
value_for_platform(
  %w(redhat oracle) => {
    '5' => 'foo',
    '6' => 'bar',
    'default'd => 'baz',
  }
)

value_for_platform(
  %w(redhat oracle) => {
    'default' => 'foo',
  },
  'default' => 'bar'
)
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.16.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessmalformedplatformvalueforplatformhelper](https://rubystyle.guide#chefcorrectnessmalformedplatformvalueforplatformhelper)

## Chef/Correctness/MetadataMissingName

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

No documentation

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.2.0` | String
Include | `**/metadata.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnessmetadatamissingname](https://rubystyle.guide#chefcorrectnessmetadatamissingname)

## Chef/Correctness/NodeNormal

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Normal attributes are discouraged since their semantics differ importantly from the
default and override levels. Their values persist in the node object even after
all code referencing them has been deleted, unlike default and override.

Code should be updated to use default or override levels, but this will change
attribute merging behavior so needs to be validated manually and force_default or
force_override levels may need to be used in recipe code.

### Examples

```ruby
#### incorrect
node.normal['foo'] = true

#### correct
node.default['foo'] = true
node.override['foo'] = true
node.force_default['foo'] = true
node.force_override['foo'] = true
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.1.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessnodenormal](https://rubystyle.guide#chefcorrectnessnodenormal)

## Chef/Correctness/NodeNormalUnless

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Normal attributes are discouraged since their semantics differ importantly from the
default and override levels. Their values persist in the node object even after
all code referencing them has been deleted, unlike default and override.

Code should be updated to use default or override levels, but this will change
attribute merging behavior so needs to be validated manually and force_default or
force_override levels may need to be used in recipe code.

### Examples

```ruby
#### incorrect
node.normal_unless['foo'] = true

#### correct
node.default_unless['foo'] = true
node.override_unless['foo'] = true
node.force_default_unless['foo'] = true
node.force_override_unless['foo'] = true
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.1.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

## Chef/Correctness/NotifiesActionNotSymbol

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

When notifying or subscribing an action within a resource the action should always be a symbol. In Chef Infra Client releases before 14.0 this may result in double notification.

### Examples

```ruby
#### incorrect
execute 'some command' do
  notifies 'restart', 'service[httpd]', 'delayed'
end

execute 'some command' do
  subscribes 'restart', 'service[httpd]', 'delayed'
end

#### correct
execute 'some command' do
  notifies :restart, 'service[httpd]', 'delayed'
end

execute 'some command' do
  subscribes :restart, 'service[httpd]', 'delayed'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.10.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessnotifiesactionnotsymbol](https://rubystyle.guide#chefcorrectnessnotifiesactionnotsymbol)

## Chef/Correctness/OctalModeAsString

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Don't represent file modes as Strings containing octal values.

### Examples

```ruby
#### incorrect
file '/etc/some_file' do
  mode '0o755'
end

#### correct
file '/etc/some_file' do
  mode '0755'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.21.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessoctalmodeasstring](https://rubystyle.guide#chefcorrectnessoctalmodeasstring)

## Chef/Correctness/OpenSSLPasswordHelpers

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

The openSSL cookbook provides a deprecated `secure_password` helper in the `Opscode::OpenSSL::Password` class, which should not longer be used. This helper would generate a random password that would be used when a data bag or attribute was no present. The practice of generating passwords to be stored on the node is bad security as it exposes the password to anyone that can view the nodes, and deleting a node deletes the password. Passwords should be retrieved from a secure source for use in cookbooks.

  #### incorrect
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  basic_auth_password = secure_password

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.6.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessopensslpasswordhelpers](https://rubystyle.guide#chefcorrectnessopensslpasswordhelpers)

## Chef/Correctness/PowershellScriptDeleteFile

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Use the `file` or `directory` resources built into Chef Infra Client with the :delete action to remove files/directories instead of using Remove-Item in a powershell_script resource

 #### correct
 file 'C:\Windows\foo\bar.txt' do
   action :delete
 end

### Examples

```ruby
#### incorrect
powershell_script 'Cleanup old files' do
  code 'Remove-Item C:\Windows\foo\bar.txt'
  only_if { ::File.exist?('C:\\Windows\\foo\\bar.txt') }
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.0.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnesspowershellscriptdeletefiles](https://rubystyle.guide#chefcorrectnesspowershellscriptdeletefiles)

## Chef/Correctness/PropertyWithoutType

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Resource properties or attributes should always define a type to help users understand the correct allowed values.

### Examples

```ruby
#### incorrect
property :size, regex: /^\d+[KMGTP]$/
attribute :size, regex: /^\d+[KMGTP]$/

#### correct
property :size, String, regex: /^\d+[KMGTP]$/
attribute :size, kind_of: String, regex: /^\d+[KMGTP]$/
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.18.0` | String
Include | `**/libraries/*.rb`, `**/resources/*.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnesspropertywithouttype](https://rubystyle.guide#chefcorrectnesspropertywithouttype)

## Chef/Correctness/ResourceSetsInternalProperties

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Chef Infra Client uses properties in several resources to track state. These
should not be set in recipes as they break the internal workings of the Chef
Infra Client

### Examples

```ruby
#### incorrect
service 'foo' do
  running true
  action [:start, :enable]
end

#### correct
service 'foo' do
  action [:start, :enable]
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.5.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessresourcesetsinternalproperties](https://rubystyle.guide#chefcorrectnessresourcesetsinternalproperties)

## Chef/Correctness/ResourceSetsNameProperty

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Use name properties instead of setting the name property in a resource. Setting the name property directly causes notification and reporting issues.

### Examples

```ruby
#### incorrect
service 'foo' do
 name 'bar'
end

#### correct
service 'foo' do
 service_name 'bar'
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.5.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessresourcesetsnameproperty](https://rubystyle.guide#chefcorrectnessresourcesetsnameproperty)

## Chef/Correctness/ResourceWithNoneAction

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

The :nothing action is often typo'd as :none

### Examples

```ruby
#### incorrect
service 'foo' do
 action :none
end

#### correct
service 'foo' do
 action :nothing
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.5.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessresourcewithnoneaction](https://rubystyle.guide#chefcorrectnessresourcewithnoneaction)

## Chef/Correctness/ScopedFileExist

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Scope file exist to access the correct File class by using ::File.exist? not File.exist?.

### Examples

```ruby
#### incorrect
not_if { File.exist?('/etc/foo/bar') }

#### correct
not_if { ::File.exist?('/etc/foo/bar') }
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.15.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessscopedfileexist](https://rubystyle.guide#chefcorrectnessscopedfileexist)

## Chef/Correctness/ServiceResource

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Use a service resource to start and stop services

### Examples

#### when command starts a service

```ruby
#### incorrect
command "/etc/init.d/mysql start"
command "/sbin/service/memcached start"
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.0.0` | String
Exclude | `**/attributes/*.rb`, `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessserviceresource](https://rubystyle.guide#chefcorrectnessserviceresource)

## Chef/Correctness/SupportsMustBeFloat

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | Yes | All Versions

Versions used in metadata.rb supports calls should be floats not integers.

### Examples

```ruby
#### incorrect
supports 'redhat', '> 8'

#### correct
supports 'redhat', '> 8.0'
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `6.13.0` | String
Include | `**/metadata.rb` | Array

### References

* [https://rubystyle.guide#chefcorrectnesssupportsmustbefloat](https://rubystyle.guide#chefcorrectnesssupportsmustbefloat)

## Chef/Correctness/TmpPath

Enabled by default | Supports autocorrection | Target Chef Version
--- | --- | ---
Enabled | No | All Versions

Use file_cache_path rather than hard-coding tmp paths

### Examples

#### downloading a large file into /tmp/

```ruby
#### incorrect
remote_file '/tmp/large-file.tar.gz' do

#### correct
remote_file "#{Chef::Config[:file_cache_path]}/large-file.tar.gz" do
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
VersionAdded | `5.0.0` | String
Exclude | `**/metadata.rb`, `**/Berksfile` | Array

### References

* [https://rubystyle.guide#chefcorrectnessnodenormalunless](https://rubystyle.guide#chefcorrectnessnodenormalunless)
