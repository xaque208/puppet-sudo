define sudo::entry ($entry) {
  include sudo
  $content = "# ${name}\n${entry}\n"

  concat::fragment { "sudoers-entry-${name}":
    target  => $sudo::sudoers_tmp,
    content => $content,
  }
}
