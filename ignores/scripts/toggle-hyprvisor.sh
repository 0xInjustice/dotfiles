#!/bin/bash
if lsmod | grep -q kvm; then
  echo "Disabling KVM modules..."
  sudo modprobe -r kvm_intel kvm_amd kvm
  echo "Starting VirtualBox..."
  virtualbox &
else
  echo "Re-enabling KVM..."
  sudo modprobe kvm_intel 2>/dev/null || sudo modprobe kvm_amd
fi

