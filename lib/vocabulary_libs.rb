require_relative 'vocabulary/migration_android_studio_copy'
require_relative 'vocabulary/migration_java_maven_copy'

# In migration code, it depends on other codes, such as android_studio_copy, java_maven_copy
# require 'android_studio_copy'
# require 'java_maven_copy'
# AndroidStudioCopy.new
# JavaMavenCopy.new
# How to call above code in runtime?
# Solution 1
# Add a gem vocabulary_migration_libs
# gem templatecli depends on gem vocabulary_migration_libs
# require 'vocabulary_migration_libs'
# And create class instances base on the defined class in gem vocabulary_migration_libs
# which means templatecli need provide a changelist of migration
# version 1.0.0
# => Add AndroidStudio vocabulary
# version 1.0.1
# => Add JavaMaven vocabulary