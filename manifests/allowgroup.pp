define sudo::allowgroup {
  include sudo

  concat::fragment { "sudoers-group-${name}":
    target  => $sudo::sudoers_tmp,
    content => "%${name} ALL=(ALL) NOPASSWD: ALL\n",
  }
}
