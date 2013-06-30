name "orm"
description "Master role applied to orm"

default_attributes(
  :munin => {
    :plugins => {
      :ipmi_fans => {
        :Sys6 => { :graph => "no" },
        :Sys8 => { :graph => "no" }
      },
      :sensors_fan => {
        :fan3 => { :graph => "no" },
        :fan4 => { :graph => "no" },
        :fan5 => { :graph => "no" },
        :fan6 => { :graph => "no" },
        :fan7 => { :graph => "no" },
        :fan8 => { :graph => "no" },
        :fan9 => { :graph => "no" },
        :fan10 => { :graph => "no" },
        :fan11 => { :graph => "no" },
        :fan12 => { :graph => "no" }
      },
      :sensors_volt => {
        :contacts => "null",
      }
    }
  },
  :networking => {
    :interfaces => {
      :external_ipv4 => {
        :interface => "eth0",
        :role => :external,
        :family => :inet,
        :address => "193.63.75.98"
      },
      :external_ipv6 => {
        :interface => "eth0",
        :role => :external,
        :family => :inet6,
        :address => "2001:630:12:500:2e0:81ff:fec5:2a8c"
      }
    }
  },
  :postgresql => {
    :versions => [ "9.1" ],
    :settings => {
      :defaults => {
        :shared_buffers => "8GB",
        :maintenance_work_mem => "7144MB",
        :effective_cache_size => "16GB"
      }
    }
  },
  :sysctl => {
    :postgres => {
      :comment => "Increase shared memory for postgres",
      :parameters => { 
        "kernel.shmmax" => 9 * 1024 * 1024 * 1024,
        "kernel.shmall" => 9 * 1024 * 1024 * 1024 / 4096
      }
    }
  },
  :tile => {
    :tile_directory => "/store/tiles",
    :node_file => "/store/database/nodes"
  }
)

override_attributes(
  :networking => {
    :nameservers => [ "8.8.8.8", "8.8.4.4" ]
  }
)

run_list(
  "role[ic]",
  "role[tile]"
)