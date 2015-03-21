if [ x"$TERM" != "xscreen" ]
  function iterm_status
    printf "\033]133;D;%s\007" $argv
  end

  # iTerm2 mark start of prompt
  function iterm_prompt_start
    printf "\033]133;A\007"
  end

  # iTerm2 mark end of prompt
  function iterm_prompt_end
    printf "\033]133;B\007"
  end

  # iTerm2 tell terminal to create a mark at this location
  function iterm_preexec
    # For other shells we would output status here but we can't do that in fish.
    printf "\033]133;C\007"
  end

  # iTerm2 inform terminal that command starts here
  function iterm_precmd
    printf "\033]1337;RemoteHost=%s@%s\007\033]1337;CurrentDir=$PWD\007" $USER (hostname -f)
  end

  functions -c fish_prompt iterm_fish_prompt

  function fish_prompt --description 'Write out the prompt; do not replace this. Instead, change fish_prompt before sourcing .iterm2_shell_integraiton.fish.'
    # Save our status
    set -l last_status $status

    iterm_status $last_status
    iterm_prompt_start
    # Restore the status
    sh -c "exit $last_status"
    iterm_fish_prompt
    iterm_prompt_end
  end

  function -v _ underscore_change
    if [ x$_ = xfish ]
      iterm_precmd
    else
      iterm_preexec
    end
  end

  printf "\033]1337;RemoteHost=%s@(hostname -f)\007" $USER
  printf "\033]1337;CurrentDir=%s\007" $PWD
  printf "\033]1337;ShellIntegrationVersion=1\007"
end
