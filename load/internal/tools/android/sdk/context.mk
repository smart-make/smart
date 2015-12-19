#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart.context.android/sdk := CERT SOURCES \
  APK LIBRARY PACKAGE EXTRA_PACKAGES PLATFORM \
  SUPPORTS LIBS CLASSPATH PROGUARD \
  R_PACKAGE RES ASSETS MANIFEST

# PROGUARD: obfuscate configure
# R_PACKAGE: custom package name for R.java
# RES: list of "res" dirs
