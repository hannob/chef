name "nominatim"
description "Role applied to all nominatim servers"

default_attributes(
  :accounts => {
    :users => {
      :lonvia => { :status => :administrator },
      :twain => { :status => :administrator },
      :nominatim => {
        :status => :role,
        :members => [ :lonvia, :tomh, :twain ]
      },
    }
  },
  :apache => {
    :mpm => "event",
    :timeout => 60,
    :keepalive => false,
    :event => {
      :server_limit => 32,
      :max_clients => 1600,
      :threads_per_child => 50
    }
  },
  :postgresql => {
    :settings => {
      :defaults => {
        :max_connections => "450",
        :synchronous_commit => "off",
        :checkpoint_segments => "50",
        :checkpoint_timeout => "10min",
        :checkpoint_completion_target => "0.9",
        :autovacuum_max_workers => "1"
      }
    }
  },
  :sysctl => {
    :postgres => {
      :comment => "Increase shared memory for postgres",
      :parameters => { 
        "kernel.shmmax" => 26 * 1024 * 1024 * 1024,
        "kernel.shmall" => 26 * 1024 * 1024 * 1024 / 4096
      }
    },
    :kernel_scheduler_tune => {
      :comment => "Tune kernel scheduler preempt",
      :parameters => {
        "kernel.sched_min_granularity_ns" => 10000000,
        "kernel.sched_wakeup_granularity_ns" => 15000000
      }
    },
    :swappiness => {
      :comment => "Reduce swap usage",
      :parameters => {
        "vm.swappiness" => 10
      }
    }
  },
  :nominatim => {
    :enabled => true,
    :repository => "git://git.openstreetmap.org/nominatim.git"
  }
)

run_list(
  "recipe[nominatim]"
)
